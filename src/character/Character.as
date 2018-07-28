package character
{
	/**
	 * flash imports 
	 */	
	import flash.display.MovieClip;
	
	/**
	 * graphic assets 
	 */	
	import asset.hitbox;
	

	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;


	public class Character extends DisplayStateLayerSprite
	{
		/**
		 * skin for object 
		 */		
		public var m_skin:MovieClip;
		
		/**
		 * skin class 
		 */		
		private var m_skinClass:Class;
		
		/**
		 *	skin width for object 
		 */		
		public var m_skin_width:int;
		
		/**
		 *	skin height for object 
		 */	
		public var m_skin_height:int;
		
		/**
		 *	the default movement speed 
		 */		
		public var m_movementSpeed:int = 2;
		
		
		/**
		 * last diretion the object was moving on, dont get reseted
		 */		
		public var m_lastDirection:String = "";
		
		/**
		 * object hitbox, used by guards and robbers 
		 */		
		public var m_objectHitBox:hitbox;
		
		/**
		 * Ghost points for x axes. Used for checking collision before player have moved 
		 */		
		public var m_testAgainstX:int;
		
		/**
		 * Ghost points for y axes. Used for checking collision before player have moved 
		 */
		public var m_testAgainstY:int;
		
		/**
		 * last direction the object was moving, get reseted for change skin
		 */		
		protected var m_skinDirection:String = "";
		
		/**
		 * callback, used by children for update the last position 
		 */		
		protected var m_callbackMovement:Function;
		
		/**
		 *	used for collision against outer walls
		 */		
		private var m_wallWidth:int = 800;
		private var m_wallHeight:int = 600;
		
		/**
		 * if object is allowed to move 
		 */		
		public var m_allowedToMove:Boolean = false;
		
		/**
		 * callback used by children for collison 
		 */		
		public var collisionCallback:Function;
		
		/**
		 * Sets skin, width and height
		 * @param skin	-	object skin
		 * @param width	-	object width
		 * @param height-	object hegiht
		 * 
		 */		
		public function Character(skin:Class = null,width = null,height = null)	{
		
			this.m_skinClass = skin;
			if(width != null && height != null)
			{
				this.m_skin_width = width;
				this.m_skin_height = height;
			}
			
			
		}
		
		/**
		 * init skin and hitbox
		 * 
		 */		
		override public function init():void {
			// Lägga till
			initSkin();
			initplayerHitBoxAsset();
		}
		
		/**
		 * Game loop
		 *  
		 * 
		 */		
		override public function update():void {
			wallCollision();
			collisionCallback(this);
			
		}
		
		/**
		 *	 object hitbox, smaller than skin. Used by players and guards
		 * 
		 */		
		private function initplayerHitBoxAsset():void {
			m_objectHitBox = new hitbox();
			m_objectHitBox.gotoAndStop("hitbox");
			m_objectHitBox.x += this.m_skin.width / 4.5;
			m_objectHitBox.y += this.m_skin.height / 2.5;
			this.addChild(m_objectHitBox);
		}
		
		
		/**
		 *	make sure guards and players cant go outisde of map 
		 * 
		 */		
		private function wallCollision():void{
			
			if(this.x > this.m_wallWidth - this.width) this.x = this.m_wallWidth - this.width;
			if(this.x < 0) this.x = 0;
			if(this.y > this.m_wallHeight - this.height) this.y = this.m_wallHeight - this.height;
			if(this.y < 51) this.y = 51;
		}
		
		/**
		 *	init skin of object and add it to stage
		 * 
		 */		
		protected function initSkin():void {
			this.m_skin =  new m_skinClass();
			addChild(this.m_skin);
		}
		
		/**
		 * move left direction 
		 * 
		 */		
		protected function moveLeft():void {
			m_allowedToMove = true;
			this.m_lastDirection = "left";
			this.m_skinDirection = "left";
			m_callbackMovement();
		}
		
		/**
		 * move right direction 
		 * 
		 */
		protected function moveRight():void {
			m_allowedToMove = true;
			this.m_lastDirection = "right";
			this.m_skinDirection = "right";
			m_callbackMovement();
		}
		
		
		/**
		 * move down direction 
		 * 
		 */
		protected function moveDown():void {
			m_allowedToMove = true;
			this.m_lastDirection = "down";
			this.m_skinDirection = "down";
			m_callbackMovement();
		}
		
		
		/**
		 * move up direction 
		 * 
		 */
		protected function moveUp():void {
			m_allowedToMove =true;
			this.m_lastDirection = "up";
			this.m_skinDirection = "up";
			m_callbackMovement();
		}
		
		
		/**
		 * if object hit a solidobject then it bein sent backwards in same direction
		 * 
		 */
		public function colideSolid():void{
			
			if(this.m_lastDirection == "left")	this.x+= m_movementSpeed;
			if(this.m_lastDirection == "up")  	this.y+= m_movementSpeed;
			if(this.m_lastDirection == "down")  this.y-= m_movementSpeed;
			if(this.m_lastDirection == "right") this.x-= m_movementSpeed;
		}
	
		/**
		 * move object
		 * 
		 */		
		protected function canMove():void {
			
			if(this.m_lastDirection == "left")  this.x-= m_movementSpeed;
			else if(m_lastDirection == "up") 	this.y-= m_movementSpeed;
			else if(m_lastDirection == "down")  this.y+= m_movementSpeed;
			else if(m_lastDirection == "right") this.x+= m_movementSpeed;
		}
		
		
		/**
		 *	Check if obect can move in left direction 
		 * @param list - test aginast
		 * @return 
		 * 
		 */		
		protected function testLeft(list):Boolean {
			
			for(var k:int =0; k < list.length; k++ ){
				if(list[k].hitTestPoint(m_testAgainstX,m_testAgainstY) ||
					list[k].hitTestPoint(m_testAgainstX,m_testAgainstY+ m_objectHitBox.height)) return false;
			}
			return true;
		}
		
		/**
		 *	Check if obect can move in up direction 
		 * @param list - test aginast
		 * @return 
		 * 
		 */
		protected function testUp(list):Boolean {
			for(var k:int =0; k < list.length; k++ ){
				if(list[k].hitTestPoint(m_testAgainstX,m_testAgainstY) ||
					list[k].hitTestPoint(m_testAgainstX+m_objectHitBox.width,m_testAgainstY)) return false; 
			}
			return true;
		}
		
		/**
		 *	Check if obect can move in down direction 
		 * @param list - test aginast
		 * @return 
		 * 
		 */
		protected function testDown(list):Boolean {
			for(var k:int =0; k < list.length; k++ ){
				if(list[k].hitTestPoint(m_testAgainstX,m_testAgainstY+m_objectHitBox.height) ||
					list[k].hitTestPoint(m_testAgainstX+m_objectHitBox.width,m_testAgainstY+ m_objectHitBox.height)) return false;
			}
			return true
		}
		
		/**
		 *	Check if obect can move in right direction 
		 * @param list - test aginast
		 * @return 
		 * 
		 */
		protected function testRight(list):Boolean {
			for(var k:int =0; k < list.length; k++ ){
				if(list[k].hitTestPoint(m_testAgainstX+m_objectHitBox.width + 5,m_testAgainstY) ||
					list[k].hitTestPoint(m_testAgainstX+m_objectHitBox.width + 5,m_testAgainstY+ m_objectHitBox.height)) return false; 
			}
			return true;
		}
		
		/**
		 * dispose 
		 * 
		 */		
		override public function dispose():void {
			trace("dispose CHARACTER");
			m_skin = null;
			m_skinClass = null;
			
			
		}
	
	}
}