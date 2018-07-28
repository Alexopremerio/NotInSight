package map
{
	/**
	 * graphic assets 
	 */	
	import asset.BankMap;
	
	/**
	 * local game imports 
	 */	
	import interactive.InteractiveObjects;
	import map.CoinDrop;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;


	public class Map extends DisplayStateLayerSprite
	{
		/**
		 * Map width  
		 */		
		public const MAP_WIDTH:int = 800;
		
		/**
		 * Map height 
		 */		
		public const MAP_HEIGHT:int = 550;
		
		/**
		 * Map startPosition in y axes 
		 */		
		public const MAP_START:int = 50;
		
		/**
		 * Map instance (singleton). 
		 */		
		private static var m_instance:Map = null;
		
		/**
		 * control if bank is robbed 
		 */		
		public var isBankRobbed:Boolean = false;
		
		/**
		 * control if bank can be robbed. 
		 */		
		public var canBeRobbed:Boolean = true;
		
		/**
		 * control if platfroms are ready to change position 
		 */		
		public var canChangePlatformsPosition:Boolean = false;
		
		/**
		 * control for the second vaultdoor only Multiplayer. 
		 */		
		public var gameMode2DoorCheck:Boolean = false;
		
		/**
		 * Game mode singleplayer/multiplayer 
		 */		
		public var m_gameMode:int;
		
		/**
		 * refrence to buildmap 
		 */		
		private var m_buildMap:BuildMap;
		
		/**
		 * list containing object that should is solid = players and enemys cant walk through.
		 */		
		public var m_collisionObjects:Vector.<Object>;
		
		/**
		 * safe places for the players. Vault and player base. 
		 */		
		public var m_mapSafePlaces:Vector.<Object>;
		
		/**
		 *  list containing object that either player can take money from(vault) or leave(car).
		 */		
		public var m_moneyPlaces:Vector.<Object>;
		
		/**
		 * list containing vaultdoors 
		 */		
		public var m_vault_doors:Vector.<Object>;
		
		/**
		 * list of objects where guards not is allowed to walk on the map(outside playbse and vault). 
		 */		
		public var m_guardRestrict:Vector.<Object>;
		
		/**
		 * coin array for when player drop coins. 
		 */		
		private var m_dropCoinArray:Vector.<Object> = new Vector.<Object>;
		
		/**
		 * how many bag that should spawn 
		 */		
		private const SPAWN_BAGS:int = 5;
		
		/**
		 *	coin asset 
		 */		
		private var m_coin:BankMap;
		
		/**
		 * coin refrence 
		 */		
		private var m_coinDrop:CoinDrop;
		
		/**
		 * sound when player drop coin. 
		 */		
		[Embed(source = "../../asset/mp3/coindrop.mp3")]
		private static const SOUND_COIN_DROP:Class;
		private var m_soundCoinDrop:SoundObject;
		
		/**
		 * sound when player hit platfrom 
		 */		
		[Embed(source = "../../asset/mp3/platform.mp3")]
		private  const SOUND_PLATFORM:Class;
		private static var m_soundPlatform:SoundObject;
		
		
		/**
		 * This class controls most of the game logic in the game. 
		 * 
		 */		
		public function Map():void {
			
		}
		
		
		/**
		 * set game mode 
		 * @param mode
		 * 
		 */		
		public function set setGameMode (mode:int):void {
			m_gameMode = mode;
		}
		
		/**
		 * return game mode. 
		 * @return 
		 * 
		 */		
		public function get gameMode():int {
			return m_gameMode;
		}
		
		/**
		 * singleton always return the same instance. If the are no instance then one gets created 
		 * @return instance
		 * 
		 */		
		public static function sharedInstance():Map {
			if (m_instance == null) {
				m_instance = new Map();
			}
			return m_instance;
		}
		
		/**
		 * init sound 
		 * 
		 */		
		override public function init():void{
			initSound();
		}
		
		/**
		 * Loads sound.
		 * Sound 1: When player drop a coin
		 * Sound 2: When player hit a platfrom
		 * 
		 */		
		private function initSound():void {
			Session.sound.soundChannel.sources.add("CoinDrop", SOUND_COIN_DROP);
			m_soundCoinDrop = Session.sound.soundChannel.get("CoinDrop");
			Session.sound.soundChannel.sources.add("Platform", SOUND_PLATFORM);
			m_soundPlatform = Session.sound.soundChannel.get("Platform");
		}
		
		/**
		 * Game loop 
		 * 
		 */		
		public override function update():void {
			checkMapPlatForms();
			if(m_gameMode == 2 ) updateMultiPlayer();
			

		}
		
		/**
		 * Only for multiplayer game loop
		 * 
		 */		
		private function updateMultiPlayer():void {
			checkVaultPlatforms();
		}
		
		/**
		 * if both vault are collided with both players then vault door opens and platfroms turn green.
		 * 
		 */		
		private function checkVaultPlatforms():void {
			
			if(InteractiveObjects.m_vaultPlatformList[0].m_hit == true && InteractiveObjects.m_vaultPlatformList[1].m_hit == true){
				if(gameMode2DoorCheck == true) return;
				gameMode2DoorCheck = true;
				InteractiveObjects.m_vaultPlatformList[0].turnPlatformGreen();
				InteractiveObjects.m_vaultPlatformList[1].turnPlatformGreen();
				m_vault_doors[0].closeVault();
				m_vault_doors[1].openVault();
			}
		}
		
		/**
		 * Check if both platforms on the bankfloor is hit, if true open vaultdoor 1 
		 * 
		 */		
		public function checkMapPlatForms():void {
			if(InteractiveObjects.m_mapPlatformList[0].m_hit == true && InteractiveObjects.m_mapPlatformList[1].m_hit == true) m_vault_doors[0].openVault();
		}

		/**
		 * 
		 * @param playerX
		 * @param playerY
		 * @param label
		 * @param coinArray 
		 * 
		 */
		public function addCoin(playerX,playerY,label:String):void {
			m_coinDrop = new CoinDrop(playerX,playerY,label);
			m_dropCoinArray.push(m_coinDrop);
			this.addChild(m_coinDrop.m_skin_coin);
			m_soundCoinDrop.play();
			
		}
		
		
		/**
		 * Control for reset the map. the reset is done when player have robbed the bank and left the money in the base. 
		 * 
		 */		
		public function resetMapControl():void{
			trace("GAME MODE !!!!!",this.gameMode);
			if(this.gameMode == 2){
				if(InteractiveObjects.m_robberList[0].m_gotBankMoney == false && InteractiveObjects.m_robberList[1].m_gotBankMoney == false) spawnNewPlatformsPoints();
				for(var i:int = 0; i <InteractiveObjects.m_robberList.length; i++){
					if(InteractiveObjects.m_robberList[i].m_gotBankMoney == false) resetMapMulti();
					
				}
			} else resetMapSingle();
			
		} 
		
		
		/**
		 * Reset map multiplayer
		 * 
		 */		
		public function resetMapMulti():void {
			this.isBankRobbed = false;
			this.canBeRobbed = true;
			InteractiveObjects.m_mapPlatformList[0].m_hit = false;
			InteractiveObjects.m_mapPlatformList[1].m_hit = false;
			m_vault_doors[1].closeVault();
			m_vault_doors[0].closeVault();
			InteractiveObjects.m_vaultPlatformList[0].reset();
			InteractiveObjects.m_vaultPlatformList[1].reset();
			gameMode2DoorCheck = false;
			checkIfPlayerInsideVault();
		}
		
		/**
		 * Check if a player is inside the vault while the other player is leaving money. Only for Multiplayer 
		 * 
		 */		
		private function checkIfPlayerInsideVault():void {
			for(var i:int = 0; i <InteractiveObjects.m_robberList.length; i++){
				if(InteractiveObjects.m_robberList[i].hitTestObject(m_buildMap.m_skinVault1) || 
					InteractiveObjects.m_robberList[i].hitTestObject(m_buildMap.m_skinVault2)){
					InteractiveObjects.m_robberList[0].m_captured = true;
					InteractiveObjects.m_robberList[1].m_captured = true;
					InteractiveObjects.m_robberList[i].m_stuckinVault = true;	
				}
			}	
		}
		
		
		/**
		 * reset the map in singleplayer mode 
		 * 
		 */		
		public function resetMapSingle():void {
			this.isBankRobbed = false;
			this.canBeRobbed = true;
			m_vault_doors[0].closeVault();
			 spawnNewPlatformsPoints();
			
		}
		
		/**
		 * Updates platforms position
		 * 
		 */		
		private function spawnNewPlatformsPoints():void {
			if(this.canChangePlatformsPosition == false) return; 
			this.canChangePlatformsPosition = false;
			for(var i:int = 0; i <InteractiveObjects.m_mapPlatformList.length; i++){
				InteractiveObjects.m_mapPlatformList[i].getnewPosition();
			}
			preventPlatformFromSpawnOnEachOther();
		}
		
		/**
		 * Prevent platfroms from spawning on each other  
		 * 
		 */		
		public function preventPlatformFromSpawnOnEachOther():void {
			var counter:int = 0;
			do{
				InteractiveObjects.m_mapPlatformList[0].getnewPosition();
				counter++
			} while(InteractiveObjects.m_mapPlatformList[0].hitTestObject(InteractiveObjects.m_mapPlatformList[1]) || counter > 10);

		}
		
		/**
		 *	 Setting platforms postion to outside the scene instead of removing them.
		 * 
		 */		
		public function bankIsRobbed():void {
			this.isBankRobbed = true;
			this.canChangePlatformsPosition = true;
			for(var i:int = 0; i <InteractiveObjects.m_mapPlatformList.length; i++){
				InteractiveObjects.m_mapPlatformList[i].m_platform.y = 601;
			}	
		}
		
		
		
		/**
		 * Loads BuildMap. Copy map assets and add them to the stage
		 * 
		 */		
		public function mapSetup():void {
			
			m_buildMap = new BuildMap(gameMode);
			this.addChild(m_buildMap.m_bankFloor);
			this.m_collisionObjects = m_buildMap.m_collisionObjects;
			this.m_mapSafePlaces = m_buildMap.m_mapSafePlaces;
			this.m_moneyPlaces = m_buildMap.m_moneyPlaces;
			this.m_vault_doors = m_buildMap.m_vault_doors;
			this.m_guardRestrict = m_buildMap.m_guardRestrict;
			addMapAssetsOnStage(this.m_mapSafePlaces);
			addMapAssetsOnStage(this.m_collisionObjects);
			addMapAssetsOnStage(this.m_moneyPlaces);
			addMapAssetsOnStage(this.m_guardRestrict);
		}
		
		/**
		 * Add map assets to the stage 
		 * @param list
		 * 
		 */		
		private function addMapAssetsOnStage(list:Vector.<Object>):void {
			for(var i:int = 0; i < list.length; i++){
				this.addChild(list[i]);
			}	
		}
		
		
		/**
		 * Dispose Map 
		 * 
		 */		
		public override function dispose():void {
			m_buildMap.dispose();
			clearList(m_dropCoinArray);
			m_instance = null;
			trace("dispose MAP");	
		}
		
		/**
		 * clear list
		 * @param list
		 * 
		 */		
		private function clearList(list:Vector.<Object>):void {
			for(var i:int = 0; i < list.length; i++){	
				list[i] = null;
				
			}
		}

	}
}


