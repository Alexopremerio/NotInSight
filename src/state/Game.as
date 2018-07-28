package state
{

	/**
	 * Local imports 
	 */	
	import character.enemy.AIManager;
	import character.player.PlayerManager;
	import highscore.HighscoreList;
	import hud.Hud;
	import hud.Score;
	import interactive.InteractiveObjects;
	import map.CoinBagManager;
	import map.Map;
	import map.MapPlatforms;
	import map.VaultPlatform;
	import retry.RetryScreen;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;


	public class Game extends DisplayState	{
		
		
		/**
		 * Score reference 
		 */		
		private var m_score:Score = Score.sharedInstance();
		
		/**
		 * playermangaer init players 
		 */		
		private var m_playerManager:PlayerManager;
		private var m_playerID:String  = "Player";

		/**
		 *	Aimanager controls guards and sensors 
		 */		
		private var m_aiManager:AIManager;
		private var m_enemyID:String  = "Enemy";
		
		/**
		 *  Game map
		 */		
		private var m_map:Map;
		private var m_mapID:String = "Map";
		
		/**
		 * Game hud 
		 */		
		private var m_Hud:Hud;
		private var m_hudID:String = "Hud";
		
		/**
		 *	Retry screen  
		 */		
		private var m_retry:RetryScreen;
		private var m_retryID:String = "Retry";
		
		/**
		 * CoinbagManager controls coinbags
		 */		
		private var m_coinBagManager:CoinBagManager;
		private var m_coinBagID:String = "Coin";
		
		/**
		 *  All game layers 
		 */		
		private var m_hudLayer:DisplayStateLayer;
		private var m_enemyLayer:DisplayStateLayer;
		private var m_mapLayer:DisplayStateLayer;
		private var m_playerLayer:DisplayStateLayer;
		private var m_retryLayer:DisplayStateLayer;
		private var m_coinBagLayer:DisplayStateLayer;
		
		/**
		 * GameOver timer  
		 */		
		private var gameOverTimer:Timer;
		
		/**
		 * Gameover control 
		 */		
		private var m_gameOver:Boolean = false;
		
		/**
		 * Only Multiplayer. Retryscreen 2 if player get locked in the vault
		 */		
		private var m_retryScreen2:Boolean = false;
		
		public static var m_gameMode:int;
		
		
		/**
		 * Embedded font 
		 */		
		[Embed(source = "../../asset/ttf/DrivingAround.ttf", fontFamily = "DrivingAround", mimeType = "application/x-font", embedAsCFF="false")] 
		public static const HUD_1:Class;
	
		/**
		 * Sound when dying 
		 */		
		[Embed(source = "../../asset/mp3/electric_death.mp3")]
		private const SOUND_DEATH_PLAYER:Class;
		private var m_soundDeathSound:SoundObject;
		
		/**
		 * Background music in game 
		 */		
		[Embed(source = "../../asset/mp3/bg2_rollin.mp3")]
		private const SOUND_BG_MUSIC:Class;
		private var m_soundBgMusic:SoundObject;

		/**
		 * 
		 * @param mode - SinglePlayer or MultiPlayer
		 * 
		 */		
		public function Game(mode:int){
			super();
			m_gameMode = mode;
		}
		
		/**
		 * init methods 
		 * 
		 */		
		override public function init():void {
			m_initLayers();
			m_initMap();
			m_initCoinBags();
			m_initHud();
			m_initEnemys();
			m_initPlayer();
			m_initContent();
			m_initSounds();
			
		}
		
		
		
		/**
		 * init all game layers 
		 * 
		 */		
		private function m_initLayers():void {
			m_mapLayer = this.layers.add(this.m_mapID);
			m_hudLayer = this.layers.add(this.m_hudID);
			m_coinBagLayer = this.layers.add(this.m_coinBagID);
			m_enemyLayer = this.layers.add(this.m_enemyID);
			m_playerLayer = this.layers.add(this.m_playerID);
		}
		
		/**
		 * init game map. 
		 * 
		 */		
		private function m_initMap():void {
			m_map = Map.sharedInstance();
			m_map.setGameMode = m_gameMode;
			m_map.mapSetup();
			m_mapLayer.addChild(this.m_map);
			
		}
		
		/**
		 * init map platforms
		 * add platforms to InteractiveObjects and control that they wont spawn on each other 
		 * 
		 */		
		private function m_init_Map_Platforms(): void {
			InteractiveObjects.m_mapPlatformList = new Vector.<MapPlatforms>;
			var platform1:MapPlatforms = new MapPlatforms();
			var platform2:MapPlatforms = new MapPlatforms();
			m_mapLayer.addChild(platform1);
			m_mapLayer.addChild(platform2);
			InteractiveObjects.m_mapPlatformList.push(platform1);
			InteractiveObjects.m_mapPlatformList.push(platform2);	
			m_map.preventPlatformFromSpawnOnEachOther();
		}
		
		/**
		 * init vault platforms only used in multiplayer. add to InteractiveObjects.
		 * 
		 */		
		private function m_init_Vault_Platforms(): void {
			InteractiveObjects.m_vaultPlatformList = new Vector.<VaultPlatform>;
			var platform1:VaultPlatform = new VaultPlatform();
			var platform2:VaultPlatform = new VaultPlatform();
			platform1.m_platform.x = 760;
			platform1.m_platform.y = 450;
			
			platform2.m_platform.x = 680;
			platform2.m_platform.y = 450;
			m_mapLayer.addChild(platform1);
			m_mapLayer.addChild(platform2);
			InteractiveObjects.m_vaultPlatformList.push(platform1);
			InteractiveObjects.m_vaultPlatformList.push(platform2);
		}
		
		/**
		 * init players and adds playerlist to InteractiveObjects = public.
		 * 
		 */		
		private function m_initPlayer():void {
			m_playerManager = new PlayerManager(m_gameMode,m_playerLayer);
			InteractiveObjects.m_robberList = m_playerManager.m_robberList;
			
		}
		
		/**
		 *	 init coinbags passing coinBagLayer 
		 * 
		 */		
		private function m_initCoinBags():void {
			m_coinBagManager = new CoinBagManager(m_coinBagLayer);
		}
		
		/**
		 * init enemys(guards and sensors). Add sensorlist and guardlist to InteractiveObjects = public.
		 * 
		 */		
		private function m_initEnemys():void {
			m_aiManager = new AIManager(m_enemyLayer);
			InteractiveObjects.m_guardList = m_aiManager.m_guardList;
			InteractiveObjects.m_sensorList = m_aiManager.m_sensorList;	
		}
		
		/**
		 * init hud instance 
		 * 
		 */		
		private function m_initHud():void {
			m_Hud = Hud.sharedInstance();
			m_hudLayer.addChild(this.m_Hud);
		}
		
		
		/**
		 *  init Sound 
		 *  Sound 1: sound when player dies
		 * 	Sound 2: background music when playing
		 */		
		private function m_initSounds():void {
			Session.sound.soundChannel.sources.add("Death", SOUND_DEATH_PLAYER);
			m_soundDeathSound = Session.sound.soundChannel.get("Death");
			Session.sound.musicChannel.sources.add("bgMusic", SOUND_BG_MUSIC);
			m_soundBgMusic = Session.sound.musicChannel.get("bgMusic");
			m_soundBgMusic.play(3);
		}
		
		/**
		 *	 Game loop
		 * 
		 */		
		override public function update():void{
			checkIfBankIsRobbed();
			gameOverControl();	
		}
		
		/**
		 *	Check if the bank have been robbed. If robbed moves sensors and remove coinbags.
		 * 
		 */		
		private function checkIfBankIsRobbed():void {
			
			if(m_map.canBeRobbed   == true){
				if(m_map.isBankRobbed  == true){
					m_map.isBankRobbed = false;
					m_map.canBeRobbed  = false;
					m_aiManager.moveSensors();
					m_coinBagManager.goldBagsTimer();
				}
			}
		}
		
		
		/**
		 * Checks game mode and call right gameover check.
		 * 
		 */		
		private function gameOverControl():void {
			if(m_gameOver == true) return;
			else if(m_gameMode == 1)  gameOverCheckSingePlayer();
			else if(m_gameMode == 2)  gameOverCheckMultiPlayer();
		}
		
	
		/**
		 * GAME OVER check for singleplayer. player deathscene after 2 seconds call gameOver.
		 * 
		 */		
		private function gameOverCheckSingePlayer():void {
			if(m_playerManager.m_robberList[0].m_captured){
				m_soundDeathSound.play();
				m_playerManager.m_robberList[0].playDeadScene();
				m_gameOver = true;
				gameOverTimer = Session.timer.add(new Timer(2000,function():void {gameOver(0)}));
			}
		}
		
		
		/**
		 * GAME OVER check for multiplayer mode. Got two death scenarios, one when players get captured and one when a player locks another play in the vault.
		 * After playing deadScene a timer for the gameover is set to 2 seconds that will display the retry screen.
		 * 
		 */		
		private function gameOverCheckMultiPlayer():void {
			if(m_playerManager.m_robberList[0].m_captured == true && m_playerManager.m_robberList[1].m_captured == true){
				m_gameOver = true;
				m_soundDeathSound.play();
				if(InteractiveObjects.m_robberList[0].m_stuckinVault|| InteractiveObjects.m_robberList[1].m_stuckinVault){
					m_playerManager.m_robberList[0].playDeadScene2();
					m_playerManager.m_robberList[1].playDeadScene2();
					m_retryScreen2 = true;
				} else {
					m_playerManager.m_robberList[0].playDeadScene();
					m_playerManager.m_robberList[1].playDeadScene();
				}
				gameOverTimer = Session.timer.add(new Timer(2000,function():void {gameOver(1)}));	
			}
		}
		
		
		/**
		 * GameOver. Calls for smartSend that check if the player got an highscore.
		 * @param mode - SinglePlayer or MultiPlayer.
		 * 
		 */		
		private function gameOver(mode:int):void {
		
			gameOverTimer = null;
			Session.highscore.smartSend(mode,m_score.getTotalPoints(),10,scoreVerifiaction,0);	
		}
		
		/**
		 * Loads retryscreen and updates the highscore.
		 * @param data - data from highscore table.
		 * 
		 */		
		private function scoreVerifiaction(data:XML):void {
			
			loadRetryScreen();
			if(data.header.success == true) {
				if( m_gameMode == 1)Session.highscore.receive(0,10,updateMultiplayerList);
				else if(m_gameMode == 2) Session.highscore.receive(1,10,updateSingleplayerList);
			}
			
		}
		
		
		/**
		 * Update highscore list for singleplayer table
		 * @param data - highscore table
		 * 
		 */		
		private function updateSingleplayerList(data:XML):void {
			disposeList(HighscoreList.m_singlePlayerRowScore);
			for(var i:int = 0; i < HighscoreList.m_singlePlayerRowScore.length; i++) {
				HighscoreList.m_singlePlayerRowScore.push(data.items.item[i].score);
			}
		}
		
		/**
		 * Update highscore list for Multiplayer table
		 * @param data - highscore table
		 * 
		 */	
		private function updateMultiplayerList(data:XML):void {
			
				disposeList(HighscoreList.m_multiPlayerRowScore);
				for(var i:int = 0; i < HighscoreList.m_multiPlayerRowScore.length; i++) {
					HighscoreList.m_multiPlayerRowScore.push(data.items.item[i].score);
				}
			}
		
		
		/**
		 * Clear highscore List 
		 * @param list - highscore List
		 * 
		 */		
		private  function disposeList(list:Vector.<int>):void {
			for (var i:int = 0; i < list.length; i++) {
				list[i] = null;
				list.splice(0,1);
			}
			list.length = 0;
		}	
		
		
		/**
		 *  init some content that must be added after the sensors. This content need sensors position so i wont spawn on them
		 * 
		 */		
		private function m_initContent():void {
			
			if(m_gameMode == 2) m_init_Vault_Platforms();	
			m_init_Map_Platforms();
			m_coinBagManager.initGoldBags();
			
		}
		
		
		/**
		 * Loads retry screen when the game is over. Two diffrent retryscreens based on the death scenario.
		 * 
		 */		
		private function loadRetryScreen():void {
			// retryscreen
			var type:String
			if(m_retryScreen2) type = "retry2";
			else type = "retry1";
			this.m_retryLayer = this.layers.add(this.m_retryID);
			this.m_retry = new RetryScreen(type);
			this.m_retryLayer.addChild(this.m_retry);
		}
		
		
		/**
		 * Dispose content 
		 * 
		 */		
		override public function dispose():void {
			trace(" DISPOSE GAME");
			m_playerManager.dispose();
			m_aiManager.dispose();
			m_retryLayer.dispose();
			m_coinBagManager.dispose();
			m_score.dispose();
			clearProperties();
			
			
		}
		
		/**
		 * Dispose content, clear class properties 
		 * 
		 */		
		private function clearProperties():void {	
			m_mapLayer.parent.removeChild(m_mapLayer);
			m_mapLayer = null;
			m_hudLayer.parent.removeChild(m_hudLayer);
			m_hudLayer = null;
			m_playerLayer.parent.removeChild(m_playerLayer);
			m_playerLayer = null;
			m_enemyLayer.parent.removeChild(m_enemyLayer);
			m_enemyLayer = null;
			m_retryLayer.parent.removeChild(m_retryLayer);
			m_retryLayer = null;
			m_coinBagLayer.parent.removeChild(m_coinBagLayer);
			m_coinBagLayer = null;
		}
		
		
		
		
	
	}
}