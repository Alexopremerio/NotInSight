package character.player
{
	
	
	
	/**
	 * local imports 
	 */	
	import character.Character;
	import hud.PlayerBagScore;
	import hud.Score;
	import interactive.InteractiveObjects;
	import map.Map;
	import utils.UtilsHelper;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	
	
	public class Player extends Character
	{
		
		/**
		 * control if player have robbed the bank
		 */		
		public var m_gotBankMoney:Boolean = false;
		
		/**
		 * if player is captured by guard or not 
		 */		
		public var m_captured:Boolean = false;
		
		/**
		 *  if player is immortal or not. player is immortal short duration after bein save in MultiPlayer mode 
		 */		
		public var m_immortal:Boolean = false;
		
		
		/**
		 * if player get stuck in vault = game over (MultiPlayer) 
		 */		
		public var m_stuckinVault:Boolean = false;
		
		
		
		/**
		 * if player can be rescued or not in MultiPlayer 
		 */
		protected var m_canBeRescued:Boolean = false;
		
		/**
		 *	players money bag 
		 */		
		protected var m_playerBagScore:PlayerBagScore;
		
		

		
		/**
		 * evertron controls.
		 */		
		private var m_controls:EvertronControls = new EvertronControls();
		
		/**
		 *	map instance used for collison with map object and spend coin
		 */		
		private var m_map:Map = Map.sharedInstance();
		
		/**
		 *	 total score instance used increase or reduce score
		 */		
		private var m_scoreTotal:Score = Score.sharedInstance();
		
		/**
		 * control for when players alpha can be set 
		 */		
		private var m_alphaCtrl:Boolean = true;
		
	
		/**
		 * label for coin asset
		 */		
		private var m_coinLabel:String = "";
		
		/**
		 * sound asset when player pick up coinbag
		 */	
		[Embed(source = "../../../asset/mp3/coinbags.mp3")]
		private static const SOUND_COIN_BAG:Class;
		private var m_soundCoinBag:SoundObject;
		
		/**
		 * sound asset when player take money inside vault 
		 */		
		[Embed(source = "../../../asset/mp3/vault_coins.mp3")]
		private static const SOUND_VAULT_MONEY:Class;
		private var m_soundVaultMoney:SoundObject;
		
		
		/**
		 *	 Constructor init player skin and controls. Setting callback from parent to allowedToMoveControl
		 * 	
		 * @param player - player skin
		 * @param label - coin skin
		 * @param controls - control player one or two
		 * 
		 */		
		public function Player(player:Class,label,controls:int = 0){
			m_controls.player = controls;
			m_coinLabel = label;
			m_callbackMovement = allowedToMoveControl;
			super(player,20,26);
		}
		
		/**
		 * Init, set movementspeed and idle skin. 
		 * 
		 */		
		override public function init():void{
			super.init();
			this.m_movementSpeed = 3;
			
			m_skin.gotoAndStop("idle_walk_down");
			initSound();
		}
		
	
		
		/**
		 * 	Init sounds 
		 *   - Coinbag sound
		 *   - Vault money sound
		 */		
		private function initSound():void {
			Session.sound.soundChannel.sources.add("CoinBag", SOUND_COIN_BAG);
			m_soundCoinBag = Session.sound.soundChannel.get("CoinBag");
			Session.sound.soundChannel.sources.add("Vaultcoin", SOUND_VAULT_MONEY);
			m_soundVaultMoney = Session.sound.soundChannel.get("Vaultcoin");
		}
		
		/**
		 * update each frame 
		 * 
		 */		
		override public function update():void{
			super.update();
			updateControlls();
			visibleInPos();
			updateSkin();
			playerCollision();
			
		}
		/**--------------------------------------------
		 * -----------  START LOOP COLLISiON  ---------
		 *---------------------------------------------	*/
		
		/**
		 * player collision 
		 * 
		 */		
		private function playerCollision():void {
			mapPlatformCollision();
			guardCollision();
			coinBagsCollision();
			moneyPlacesCollision();
		}
		
		
		/**
		 *	Collision map platforms 
		 * 
		 */		
		private function mapPlatformCollision():void {
			for(var i:int =0; i < InteractiveObjects.m_mapPlatformList.length; i++ )
				if(this.hitTestObject(InteractiveObjects.m_mapPlatformList[i].m_platform)){ 
					InteractiveObjects.m_mapPlatformList[i].gotHit();
					this.collideInObstacle();
				}
		}
		
		/**
		 * Collision guards 
		 * 
		 */		
		private function guardCollision():void {
			if(this.m_immortal) return
				for(var i:int =0; i < InteractiveObjects.m_guardList.length; i++ ){
					if(this.hitTestObject(InteractiveObjects.m_guardList[i].m_objectHitBox)) {
						if(m_map.gameMode == 2) this.multiCaptured()
						else this.m_captured = true;	
					}
				}
		}
		
		
		/**
		 * Collision coinBags 
		 * 
		 */		
		private function coinBagsCollision():void {
			for(var i:int =0; i < InteractiveObjects.m_coinBagsList.length; i++ ){
				if(this.hitTestObject(InteractiveObjects.m_coinBagsList[i].m_bag)){
					this.pickedUpMoneyBag();
					this.collideInObstacle();
					if(InteractiveObjects.m_coinBagsList[i] && InteractiveObjects.m_coinBagsList[i].parent){
						InteractiveObjects.m_coinBagsList[i].removeBag();
						InteractiveObjects.m_coinBagsList.splice(i,1);
					}
					return	
				}
			}
		}
		
		/**
		 * Collision robbing vault and leave money in base 
		 * 
		 */		
		private function moneyPlacesCollision():void {
			if(this.hitTestObject(m_map.m_moneyPlaces[0])) this.dropMoney();
			
			if(this.hitTestObject(m_map.m_moneyPlaces[1])){
				this.robbingVault();	 
				this.collideInObstacle();
			}
		}
		
		
		/**--------------------------------------------
		 * ------------  END LOOP COLLISiON  ----------
		 *---------------------------------------------	*/
		
		/**
		 * player controls 
		 * 
		 */		
		private function updateControlls():void {
			if(m_captured == true){
				return;
			} 
			
			if (Input.keyboard.justPressed(m_controls.PLAYER_BUTTON_1))	this.spendCoin()
			
			if (Input.keyboard.pressed(m_controls.PLAYER_UP)) this.moveUp();
			else if (Input.keyboard.pressed(m_controls.PLAYER_RIGHT)) this.moveRight();
			else if (Input.keyboard.pressed(m_controls.PLAYER_DOWN)) this.moveDown();
			else if (Input.keyboard.pressed(m_controls.PLAYER_LEFT)) this.moveLeft();
				
				
			else if (Input.keyboard.justReleased(m_controls.PLAYER_UP))    this.releaseUp();	
			else if (Input.keyboard.justReleased(m_controls.PLAYER_RIGHT)) this.releaseRight();	
			else if (Input.keyboard.justReleased(m_controls.PLAYER_DOWN))  this.releaseDown();	
			else if (Input.keyboard.justReleased(m_controls.PLAYER_LEFT))  this.releaseLeft();	
		}
		
		
		/**
		 *	 Movement control. Check for collison before player moves.
		 * 	 Using ghostpoints to check if player is going to colide instead of playerskin.	
		 * 
		 */		
		public function allowedToMoveControl():void {
			
			if(this.m_lastDirection == "up"){
				m_testAgainstY = (this.y + m_objectHitBox.y) - m_movementSpeed;
				m_testAgainstX = this.x; 
					
				if(testUp(m_map.m_collisionObjects) && testUp(InteractiveObjects.m_sensorList))canMove();
				else if (testUp(InteractiveObjects.m_sensorList) == false) collideInObstacle();
			}
			else if(this.m_lastDirection == "down"){
				m_testAgainstY = this.y + (m_movementSpeed + m_objectHitBox.y);
				m_testAgainstX = this.x; 
				
				if(testDown(m_map.m_collisionObjects) && testDown(InteractiveObjects.m_sensorList))canMove();
				else if (testDown(InteractiveObjects.m_sensorList) == false) collideInObstacle();
			}
			
			else if(this.m_lastDirection == "left"){
			
				m_testAgainstX = this.x - m_movementSpeed ;
				m_testAgainstY = this.y+ m_objectHitBox.y;
				
				if(testLeft(m_map.m_collisionObjects) && testLeft(InteractiveObjects.m_sensorList))canMove();
				else if (testLeft(InteractiveObjects.m_sensorList) == false) collideInObstacle();
				
			}
			else if(this.m_lastDirection == "right"){
				m_testAgainstX = this.x + m_movementSpeed 
				m_testAgainstY = this.y + m_objectHitBox.y;
				
				
				if(testRight(m_map.m_collisionObjects) && testRight(InteractiveObjects.m_sensorList))canMove();
				else if (testRight(InteractiveObjects.m_sensorList) == false) collideInObstacle();
				
			}
			
		}
		
		
		
		
		/**
		 * playing deadscene when player dies 
		 * 
		 */		
		public function playDeadScene():void {
			disconnectControls();
			m_alphaCtrl = false;
			this.alpha = 1;
			m_skin.gotoAndStop("death_electric");
			
		}
		
		public function playDeadScene2():void {
			disconnectControls();
			this.alpha = 1;
			if(m_stuckinVault) m_skin.gotoAndStop("death");
			
			
		}
		
		/**
		 * clear controls, used when game is over. 
		 * 
		 */		
		public function disconnectControls():void{
			m_controls = null;
		}
		
		/**
		 * dropping coin 
		 * Map is adding coin to the stage
		 * 
		 */		
		private function spendCoin():void{
			if(m_scoreTotal.canSpend() == true){
				m_scoreTotal.reducePoints();	
				m_map.addCoin(this.x,this.y +10,m_coinLabel);
			}	
		}
		
		
		
		/**
		 * visible controlmode
		 * 
		 */		
		private function visibleInPos():void {
			if(m_captured) return;
			if(m_map.gameMode == 2)	visibleInPosMulti();
			else if(m_map.gameMode == 1) visibleInPosSingle();
			
		}
		
		/**
		 * Where player is visible on the map (MultiPlayer)
		 * 
		 */		
		private function visibleInPosMulti():void {
			if(m_immortal == true) return;
			if(this.inRangeOfBasesMulti() == true) playerAlpha(0.5);
			else if(UtilsHelper.insideObj(this,m_map.m_mapSafePlaces[0]) == true)playerAlpha(1);
			else if(UtilsHelper.insideObj(this,m_map.m_mapSafePlaces[1]) == true)playerAlpha(1);
			else if(UtilsHelper.insideObj(this,m_map.m_mapSafePlaces[2]) == true)playerAlpha(1);
			else playerAlpha(0);
		}
		
		/**
		 * Where to be visible on the map (SinglePlayer)
		 * 
		 */		
		private function visibleInPosSingle():void {
			if(this.inRangeOfBasesSingle() == true) playerAlpha(0.5);
			else if(UtilsHelper.insideObj(this,m_map.m_mapSafePlaces[0]) == true)playerAlpha(1);
			else if(UtilsHelper.insideObj(this,m_map.m_mapSafePlaces[1]) == true)playerAlpha(1); 
			else playerAlpha(0);
		}
		
		/**
		 *	Visible outside player base and outside of vault (SinglePlayer) 
		 * @return 
		 * 
		 */		
		private function inRangeOfBasesSingle():Boolean {
			if(this.x > 650 && this.y > 400 && this.y < 500 || this.x < (130 - this.m_skin_width) && this.y < (280 - this.m_skin_height) && this.y > 179) return true;
			else return false;
			
			
		}
		
		/**
		 *	Visible outside player base and outside of vault (MultiPlayer) 
		 * @return 
		 * 
		 */	
		private function inRangeOfBasesMulti():Boolean {
			if(this.x > 650 && this.y > 300 && this.y < 405 || this.x < (130 - this.m_skin_width) && this.y < (280 - this.m_skin_height) && this.y > 179) return true;
			else return false;
			//this.x < 130 && this.y < 280)   179
			
		}
		
		/**
		 *	Player picked up a GoldBag 
		 * 
		 */		
		public function pickedUpMoneyBag():void{
			m_soundCoinBag.play();
			m_playerBagScore.addGoldBag();	
		}
		
		
		
		/**
		 * When player robbing the vault 
		 * 
		 */		
		public function robbingVault():void {
			if(this.m_gotBankMoney == true) return;
			this.m_gotBankMoney = true;
			this.m_movementSpeed = 2;
			m_playerBagScore.addGoldBank();	
			m_map.bankIsRobbed();
			m_soundVaultMoney.play();
			
			
		}
		
		/**
		 *	Player drop money in base(car) 
		 * 
		 */		
		public function dropMoney():void {
			m_playerBagScore.addToTotal();
			if(this.m_gotBankMoney == false) return;
			this.m_gotBankMoney = false;
			this.m_movementSpeed = 3;
			m_map.resetMapControl();		
		}
		
		
		
		/**
		 * Make player visible for a short duration of time 
		 * 
		 */		
		public function collideInObstacle():void {
			if(m_alphaCtrl == false) return;
			playerEase();
		}
		
		
		/**
		 *	 
		 * @param value - alpha value
		 * 
		 */		
		public function playerAlpha(value):void {
			if(m_alphaCtrl == false) return;
			this.alpha = value;
		}
		
		/**
		 *  fade alpha
		 * 
		 */		
		private function playerEase():void {
			m_alphaCtrl = false;
			this.alpha = 1;
			var counter:int = 0;
			var alphaTimer:Timer = Session.timer.add(new Timer(100, function():void {	
				alpha -= 0.1;
				counter++;
				if(counter >= 10) m_alphaCtrl = true;
			},10 -1));
			//alphaTimer = null;
			
		}
		
		/**
		 * MultiPlayer captured 
		 * 
		 */		
		public function multiCaptured():void {
			if(m_captured) return;
			m_captured = true;
			var rescueTimer:Timer = Session.timer.add(new Timer(500, function():void {m_canBeRescued = true;}))
			this.playerAlpha(1);
			trace(" GOT BANK MONEY ",m_gotBankMoney)
			if(m_gotBankMoney) m_skin.gotoAndStop("death_gold");
			else m_skin.gotoAndStop("death");
		}
		
		/**
		 * player animation when turning.
		 * mode 1 = without gold
		 * mode 2 = with gold
		 * 
		 */		
		private function updateSkin():void {
			if(m_skinDirection == "down"){
				m_skinDirection = "";
				if(this.m_gotBankMoney == false) m_skin.gotoAndStop("down");
				else m_skin.gotoAndStop("down_gold");
				
				
			}
			else if(m_skinDirection == "up") {
				m_skinDirection = "";
				if(this.m_gotBankMoney == false) m_skin.gotoAndStop("up");
				else  m_skin.gotoAndStop("up_gold");
				
			}
			else if(m_skinDirection == "left") {
				m_skinDirection = "";
				if(this.m_gotBankMoney == false) m_skin.gotoAndStop("left");
				else m_skin.gotoAndStop("left_gold");
				
			}
			else if(m_skinDirection == "right") {
				m_skinDirection = "";
				if(this.m_gotBankMoney == false) m_skin.gotoAndStop("right");
				else  m_skin.gotoAndStop("right_gold");
				
			}
		}
		
		/**
		 * idle up
		 * mode 1 = without gold
		 * mode 2 = with gold
		 * 
		 */		
		private function releaseUp():void {
			if(this.m_gotBankMoney == false) m_skin.gotoAndStop("idle_walk_up");
			else m_skin.gotoAndStop("idle_up_gold");
			
		}
		
		/**
		 * idle down
		 * mode 1 = without gold
		 * mode 2 = with gold
		 * 
		 */	
		protected function releaseDown():void {
			
			if(this.m_gotBankMoney == false) m_skin.gotoAndStop("idle_walk_down");
			else  m_skin.gotoAndStop("idle_down_gold");
		}
		
		/**
		 * idle right
		 * mode 1 = without gold
		 * mode 2 = with gold
		 * 
		 */	
		private function releaseRight():void {
			if(this.m_gotBankMoney == false) m_skin.gotoAndStop("idle_walk_right");
			else m_skin.gotoAndStop("idle_right_gold");
		}
		
		/**
		 * idle left
		 * mode 1 = without gold
		 * mode 2 = with gold
		 * 
		 */	
		private function releaseLeft():void {
			if(this.m_gotBankMoney == false) m_skin.gotoAndStop("idle_walk_left");
			else m_skin.gotoAndStop("idle_left_gold");
		}
		
		/**
		 * dispose
		 * 
		 */	
		override public function dispose():void{
			super.dispose();
			m_controls = null;
			m_playerBagScore = null;
			trace("dispose PLAYER");	
		}
		
	}
}