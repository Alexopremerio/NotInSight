package character.enemy
{
	/**
	 * graphic asset 
	 */	
	import asset.GuardAI;
	
	/**
	 * local game files 
	 */	
	import character.Character;
	import map.Map;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	import se.lnu.stickossdk.util.MathUtils;
	
	
	
	public class Guard extends Character
	{
		
		/**
		 * if guard is walking random or not 
		 */		
		public var m_walkingRandom:Boolean = true;
		
		/**
		 * object the guard will hunt 
		 */		
		public var m_huntObject:Object;
		
		/**
		 *  if guard is hunting
		 */		
		public var huntingWalk:Boolean = false;
		
		/**
		 * the distance will walk in a direction before calculate a new direction
		 */		
		public var huntingWalkDistance:int = 5;
		
		/**
		 *	If the guard can change direction
		 */		
		public var m_changeDirection:Boolean = false;
		
		/**
		 *	 last direction when hit a sensor in huntmode. Used for guard to be able to walk around objects while hunting
		 */		
		public var huntDirectionWalk2:String = "";
		
		
		public var stopCollisionCheck:int = 0;
		public var turnedOn:String = "right left down up";
		
		/**
		 *	the update speed in timer when walking 
		 */		
		protected var m_UpdatePosSpeed:int = 30;
		
		/**
		 * offset while hunting 
		 */		
		private var huntingoffset:int = huntingWalkDistance + 3;
		
		/**
		 * timer for updatepositon 
		 */		
		private var m_posTimer:Timer = null;
		
		/**
		 * sets to true when a guard should cancel is current move in one direction. 
		 */		
		private var m_cancelrandomWalk:Boolean = false;
		
		/**
		 * map refrence 
		 */		
		private var m_map:Map = Map.sharedInstance();
		
		
		private const HUNTING_DURATION:int = 3000;
		
		
		/**
		 * Sets guardSkin, width, height and movementSpeed
		 * Setting parent callback to allowedToMoveControl. Callback is called in each moveDirection
		 */		
		public function Guard()
		{
			super(GuardAI,20,26);
			this.m_movementSpeed = 1;
			m_callbackMovement = allowedToMoveControl;
		}
		
		/**
		 * Gameloop 
		 * 
		 */		
		override public function update():void {
			super.update();
			guardMode();
			updateSkin();
			//guardCollision2();
		}
		
		
		/**
		 * Start the hunting for 3 seconds then go back to randomWalk
		 * @param object - the object that will be hunted.
		 * 
		 */		
		public function startHunting(object):void{
			
			m_walkingRandom = false;
			m_cancelrandomWalk = true;
			m_huntObject = object;
			Session.timer.add(new Timer(HUNTING_DURATION, function():void {
				m_walkingRandom = true;
				m_changeDirection = true;
			},0));
		}
		
		
		/**
		 * when walkingRandom = true guards walk random. When false guard is hunting player.
		 * changeDirection = true when guard is ready to calculate next direction
		 * 
		 */		
		private function guardMode():void {
			if(this.m_walkingRandom == false && this.m_changeDirection == true)huntPlayer();
			else if(this.m_walkingRandom == true && this.m_changeDirection == true) randomWalk();
		}
		
		/**
		 * Guard hunting player x and y. 
		 * Movement speed is increased when hunting. 
		 * 
		 */		
		public function huntPlayer():void{	
			
			m_changeDirection = false;
			m_movementSpeed = 3;
			if 		(huntDirectionWalk2.indexOf("right") >=0  || m_huntObject.x > this.x && m_huntObject.x - this.x > huntingoffset && turnedOn.indexOf("right") >=0)updatePosition(this.moveRight,huntingWalkDistance);
			else if (huntDirectionWalk2.indexOf("left")  >=0  || m_huntObject.x < this.x && this.x - m_huntObject.x > huntingoffset && turnedOn.indexOf("left") >=0)	updatePosition(this.moveLeft,huntingWalkDistance);
			else if (huntDirectionWalk2.indexOf("down")  >=0  || m_huntObject.y > this.y && m_huntObject.y - this.y > huntingoffset && turnedOn.indexOf("down") >=0)	updatePosition(this.moveDown,huntingWalkDistance);
			else if (huntDirectionWalk2.indexOf("up")    >=0  || m_huntObject.y < this.y && this.y - m_huntObject.y > huntingoffset && turnedOn.indexOf("up") >=0)	updatePosition(this.moveUp,huntingWalkDistance);
			
		} // END huntPlayer
		
		
		
		
		/**
		 * randomize direction and range the guard should walk 
		 * 
		 */		
		public function randomWalk():void {
			this.m_movementSpeed = 1;
			this.m_changeDirection = false;
			var dir:int = MathUtils.randomRange(0,3) >> 0;
			var range:int = MathUtils.randomRange(10,40) >> 0;
			moveDirection(dir,range);		
		}
		
		
		
	
		/**
		 * paring the walk direction with walk method
		 * moveUp, moveDown, moveRight, moveLeft = callbacks
		 * @param dir   - direction  guard should walk
		 * @param range - how faar the guard should walk
		 * 
		 */		
		public function moveDirection(dir,range):void {
			if (dir == 0)updatePosition(this.moveUp,range);
			else if (dir == 1)updatePosition(this.moveDown,range);
			else if (dir == 2)updatePosition(this.moveRight,range);
			else if (dir == 3)updatePosition(this.moveLeft,range);
			
		}
		
		
		/**
		 *	Collision with map object and guardRestricted zone. Using ghost points that are set infront of the guard
		 * 	depending on its direction. If guard is going to collide the guard is not allowed to walk.
		 * 
		 */		
		public function allowedToMoveControl():void {
			if(this.m_lastDirection == "left"){
	
				m_testAgainstX = this.x - m_movementSpeed;
				m_testAgainstY = this.y +m_objectHitBox.y;
				if(testLeft(m_map.m_collisionObjects) &&testLeft(m_map.m_guardRestrict))canMove();
				
			}
			else if(this.m_lastDirection == "up"){
				
				m_testAgainstY = (this.y + m_objectHitBox.y) - m_movementSpeed;
				m_testAgainstX = this.x
				if(testUp(m_map.m_collisionObjects)  &&testLeft(m_map.m_guardRestrict))canMove();
				
			}
			else if(this.m_lastDirection == "down"){
				
				m_testAgainstY = (this.y + m_objectHitBox.y) + m_movementSpeed;
				m_testAgainstX = this.x
				if(testDown(m_map.m_collisionObjects)   &&testLeft(m_map.m_guardRestrict))canMove();
				
			}
			else if(this.m_lastDirection == "right"){
				
				m_testAgainstX = this.x + m_movementSpeed ;
				m_testAgainstY = this.y +m_objectHitBox.y;
				if(testRight(m_map.m_collisionObjects)  &&testLeft(m_map.m_guardRestrict))canMove();
				
			}
		}
		
		
		
		
		/**
		 * Moving guard each time the Timer loops. callback is the direction in which the guard will move. Once the counter = param range the guard have finnish moveing.
		 * The loop can be canceled if needed, it's used when the guard should hunt the player. 
		 * The stopCollisionCheck statement is used for the functionallity the guard uses to go around sensors. Useful when guard is hunting player.
		 * @param callback
		 * @param range     - how many times the timer should repeat = how far the gaurd moves
		 * 
		 */
		protected function updatePosition(callback, range):void {
			
			if (m_posTimer != null) return;
			var counter:int = 0;
			m_posTimer = Session.timer.add(new Timer(m_UpdatePosSpeed, function():void {
				callback();
				counter++;
				// exits the loop.
				if(m_cancelrandomWalk == true) counter = range;
				// done loop 
				if(counter == range) {
					m_changeDirection = true; 
					Session.timer.remove(m_posTimer);
					m_posTimer = null;
		
					if(stopCollisionCheck >0){
						if(huntDirectionWalk2 == "right") turnedOn = "right up down";
						else if(huntDirectionWalk2 == "left") turnedOn = "left up down";
						else if(huntDirectionWalk2 == "up") turnedOn = "right left up";
						else if (huntDirectionWalk2 == "down") turnedOn = "right left down";
						huntDirectionWalk2 = "";
						stopCollisionCheck--;
						// reset huntingWalkDistance back to five - guard should only make long walk first time when trying go around one sensor
						if(stopCollisionCheck == 1)huntingWalkDistance = 5;
					}else turnedOn = "right left down up";
					m_cancelrandomWalk = false;
				}
			},range));	
		}
		
		/**
		 * Changes guard skin based on directon it moves. 
		 * 
		 */		
		private function updateSkin():void {
			if(m_skinDirection == "down"){
				m_skinDirection = "";
				m_skin.gotoAndStop("down");	
			}
			else if(m_skinDirection == "up") {
				m_skinDirection = "";
				m_skin.gotoAndStop("up");
			}
			else if(m_skinDirection == "left") {
				m_skinDirection = "";
				m_skin.gotoAndStop("left");
			}
			else if(m_skinDirection == "right") {
				m_skinDirection = "";
				m_skin.gotoAndStop("right");
			}
		}
		
		
		/**
		 * dispose Guard. 
		 * 
		 */		
		override public function dispose():void {
			super.dispose();
			m_huntObject = null;
			trace("dispose GUARD");
		}
	}
}