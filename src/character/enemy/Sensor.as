package character.enemy
{
	
	/**
	 * graphic asset 
	 */	
	import asset.Enemy_sensor;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	
	public class Sensor extends AI
	{
		/**
		 * While true, object got a new pos to move towards
		 */		
		public var m_moveToNewPosX:Boolean = false;
		
		/**
		 * While true, object got a new pos to move towards
		 */		
		public var m_moveToNewPosY:Boolean = false;
		
		/**
		 * While true object can move in x axes
		 */		
		public var m_changeDirectionX:Boolean = true;
		
		/**
		 * While true object can move in y axes 
		 */
		public var m_changeDirectionY:Boolean = false;
		
		/**
		 *  Alarm can be playing while true
		 */		
		public var m_alarmPlaying:Boolean = true;
		
		/**
		 * new x point to move towards 
		 */		
		public var m_newPointX:int;
		
		/**
		 * new y point to move towards 
		 */
		public var m_newPointY:int;
		
		/**
		 * how faar object should move before calculate new direction 
		 */		
		private var m_moveLength:int  = 5;
		
		/**
		 * area in which the sensor will notify guards to hunt player
		 */		
		private var m_areaToNotifyGuards:int = 200;
		
		/**
		 * sound for alarm 
		 */		
		[Embed(source = "../../../asset/mp3/hit_alarm2.mp3")]
		private static const SOUND_HIT_SENSOR:Class;
		private var m_soundHitSensor:SoundObject;
		
		/**
		 * 
		 * 
		 */		
		public function Sensor() {	
			super(null,37,37);
		}
		
		/**
		 *  Game loop
		 * 
		 */		
		override public function update():void {
			super.update();
			moveCheck();
			
		}
		
		/**
		 * init speed and update speed 
		 * 
		 */		
		override public function init():void {
			super.init();
			m_movementSpeed = 5;
			m_UpdatePosSpeed = 16;
			initSkin();
			m_initSound();
		}
		
		/**
		 * init sensor skin 
		 * 
		 */		
		override protected function initSkin():void {
			this.m_skin =  new Enemy_sensor();
			m_skin.gotoAndStop("idle_alarm");
			addChild(this.m_skin);
		}
		
		/**
		 * init sound
		 * Sound 1: Alarm when player collide with sensor
		 * 
		 */		
		private function m_initSound():void {
			Session.sound.soundChannel.sources.add("SensorHit", SOUND_HIT_SENSOR);
			m_soundHitSensor = Session.sound.soundChannel.get("SensorHit");
		}
		
		/**
		 *	Control if object is allowed to move new point 
		 * 
		 */		
		public function moveCheck():void {
			if(m_moveToNewPosX == true && this.m_changeDirectionX == true || m_moveToNewPosY == true && this.m_changeDirectionY == true) moveToPoint();
		}
		
		
		/**
		 *	Check if move if completed
		 * 	call for move in x direcrion and y direction. 
		 * 
		 */		
		public function moveToPoint():void{
			moveComplete();
			moveXdir();
			moveYdir();	
		}
		
		/**
		 * return array the is the area in which guards will be notified 
		 * @param robber - player that hit sensor
		 * @return 
		 * 
		 */		
		public function areaEffected(robber):Array{
			var effectCord:Array = [];
			effectCord[0] = robber.x - m_areaToNotifyGuards;
			effectCord[1] = robber.y - m_areaToNotifyGuards;
			effectCord[2] = robber.x + m_areaToNotifyGuards;
			effectCord[3] = robber.y + m_areaToNotifyGuards;
			return effectCord;
		}
		
		/**
		 * play alarm for 3 seconds.
		 * 3 seconds = the timer guard follow player
		 * 
		 */		
		public function onEnemyHitAlarm():void {
			if(m_alarmPlaying == false) return
			m_alarmPlaying = false;
			m_soundHitSensor.play();
			m_skin.gotoAndStop("big_alarm");
			var alarm:Timer =  Session.timer.add(new Timer(3000, function():void {
				m_skin.gotoAndStop("idle_alarm");
				m_alarmPlaying = true;
				alarm = null;
			}));
		}
		
		/**
		 * When sensors moves player alarm for 5 seconds.
		 * 5 seconds  =  the time sensors is moving. 
		 * 
		 */		
		public function onMoveAlarm():void {
			m_skin.gotoAndStop("small_alarm");
			var alarm:Timer =  Session.timer.add(new Timer(5000, function():void {
				m_skin.gotoAndStop("idle_alarm");
				alarm = null;
			}));
		}
		
		/**
		 *	 move on x axes
		 * 
		 */		
		public function moveXdir():void { 
			if(m_moveToNewPosX) setPosLimit(m_newPointX,this.x,this.moveLeft,this.moveRight);
		}
		
		/**
		 * move on y axes 
		 * 
		 */		
		public function moveYdir():void {
			if(m_moveToNewPosY) setPosLimit(m_newPointY,this.y,this.moveUp,this.moveDown);
		}
		
		/**
		 *	 Compare the new point with sensors position then move to get closer to point.
		 * 
		 * @param newpoint
		 * @param axes
		 * @param dirA - direction
		 * @param dirB - direction
		 * 
		 */		
		public function setPosLimit(newpoint,axes,dirA,dirB):void {
			
			if(this.x > 495 && this.y > 365){
				if (newpoint < axes )updatePosition(dirA,m_moveLength);
			}
			else if(this.x < 188 && this.y < 324){
				if (newpoint > axes )updatePosition(dirB,m_moveLength);
			}
			else{
				if (newpoint < axes )updatePosition(dirA,m_moveLength);
				else if (newpoint > axes )updatePosition(dirB,m_moveLength);
			}
		}
		
		/**
		 * 	control if the move is completed 
		 * 
		 */		
		private function moveComplete():void {
			if(this.x - m_newPointX > (- m_movementSpeed) && this.x - m_newPointX < m_movementSpeed) {
				this.m_moveToNewPosX = false;
				this.m_changeDirectionX = false;	
			}
			if( this.y - m_newPointY > (- m_movementSpeed) && this.y - m_newPointY< m_movementSpeed ) {
				this.m_moveToNewPosY = false;
				this.m_changeDirectionY = false;		
			}
		}
		
		
		/**
		 * move left 
		 * Override parent
		 * 
		 */		
		override protected function moveLeft():void {
			this.x-= m_movementSpeed;
			this.m_lastDirection = "left";
		}
		
		/**
		 * move right 
		 * Override parent
		 * 
		 */	
		override protected function moveRight():void {
			this.x+= m_movementSpeed;
			this.m_lastDirection = "right";
		}
		
		/**
		 * move down 
		 * Override parent
		 * 
		 */	
		override protected function moveDown():void {
			trace
			this.y+= m_movementSpeed;
			this.m_lastDirection = "down";
		}
		
		/**
		 * move up 
		 * Override parent
		 * 
		 */	
		override protected function moveUp():void {
			this.y-= m_movementSpeed;
			this.m_lastDirection = "up";
		}
		
		/**
		 * dispose 
		 * 
		 */		
		override public function dispose():void {
			super.dispose();
			trace("dispose SENSOR");
		}
		
	}
}