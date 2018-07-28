package map
{	
	/**
	 * graphic assets 
	 */	
	import assets.vault_openers;
	
	/**
	 * local game files 
	 */	
	import interactive.InteractiveObjects;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;

	public class VaultPlatform extends DisplayStateLayerSprite
	{
		/**
		 * platform asset 
		 */		
		public var m_platform:vault_openers =  new vault_openers();
		
		/**
		 * if a platform is hit 
		 */		
		public var m_hit:Boolean = false;
		
		/**
		 *  if a platforms is activated = green.
		 */		
		private var m_activated:Boolean = false;
		
		public function VaultPlatform()
		{
		}
		
		/**
		 * init platform 
		 * 
		 */		
		override public function init():void {
			super.init();
			this.addChild(m_platform);
			m_platform.gotoAndStop(1);
			
		}
		
		/**
		 * Game loop
		 * check for collision with players 
		 * 
		 */		
		override public function update():void {
			collision()
		}
		
		/**
		 * Dispose clear memory 
		 * 
		 */		
		override public function dispose():void {
			trace("dispose VAult playtform");
			m_platform = null;
			
		}
		
		/**
		 * Collison check against players(robbers). 
		 * if a platform is activated it wont check for collison 
		 * 
		 */		
		private function collision():void {
				if(m_activated) return;
				if(InteractiveObjects.m_robberList[0].hitTestObject(this.m_platform) || InteractiveObjects.m_robberList[1].hitTestObject(this.m_platform)){
					gotHit();
				}
				else notHit();
		}
		
		/**
		 * When a platform is hit, playing animation. Platform wont turn to green only replay from red to green.
		 * 
		 */		
		public function gotHit():void{
			m_hit = true;
			if(m_platform.currentFrame == m_platform.totalFrames) return;
			m_platform.play();
			
		}
		
		/**
		 *  turn platform to green.
		 * 
		 */		
		public function turnPlatformGreen():void{
			m_activated = true;
			m_platform.gotoAndStop(m_platform.totalFrames);
		}
		
		/**
		 * When a platform is not hitted platform remains red.
		 * 
		 */		
		private function notHit():void {
			m_hit = false;
			m_platform.gotoAndStop(1);
		}
		
		/**
		 * reset platforms = Happens when player dropoff money 
		 * 
		 */		
		public function reset():void {
			m_hit = false;
			m_activated = false;
		}
		
		
	}
}