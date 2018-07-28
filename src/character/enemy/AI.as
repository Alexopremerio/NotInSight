package character.enemy
{	
	/**
	 * local game imports 
	 */	
	import character.Character;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class AI extends Character
	{
		/**
		 * updatePosition timer. 
		 */		
		private var m_posTimer:Timer = null;
		
		
		/**
		 * Updatespeed lower numer = faster movement. 
		 */		
		protected var m_UpdatePosSpeed:int = 30;
		
		
		/**
		 * 
		 * @param playerAI	-	skin
		 * @param width		-	skin width
		 * @param height	-	skin height
		 * 
		 */		
		public function AI(playerAI:Class,width,height) {
			super(playerAI,width,height);
		}
		
		/**
		 * Game loop 
		 * 
		 */		
		override public function update():void {
			super.update();	
		}
		
		/**
		 * Update the objects posistion. 
		 * @param callback	-	in which direction object will move
		 * @param range		-	how faar in that direction it will move
		 * 
		 */		
		protected function updatePosition(callback, range):void {
			if (m_posTimer != null) return;
			var counter:int = 0;
			m_posTimer = Session.timer.add(new Timer(m_UpdatePosSpeed, function():void {
				callback();
				counter++;
				if(counter == range) {
					Session.timer.remove(m_posTimer);
					m_posTimer = null;	
				}
			},range));	
		}
		
		/**
		 * Dispose 
		 * 
		 */		
		override public function dispose():void{
			super.dispose();
			m_posTimer = null;
		}
	}
}