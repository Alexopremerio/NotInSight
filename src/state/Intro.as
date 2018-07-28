package state
{	
	/**
	 * intro asset 
	 */	
	import asset.IntroAsset;
	
	
	
	
	/**
	 * sdk imports 
	 */		 
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;

	
	public class Intro extends DisplayStateLayerSprite{
		
		
		/**
		 * intro assets
		 */		
		private var m_IntroClip:IntroAsset;	
		
		
		
		public function Intro():void {
			
		} 
		
		/**
		 * init the intro 
		 * 
		 */		
		override public function init():void { 
			this.video();
		} 
		
		
		
		/**
		 * loads and start the intro
		 * 
		 */		
		private function video():void{
			this.m_IntroClip = new IntroAsset();
			this.m_IntroClip.gotoAndStop("Intro");
			this.addChild(this.m_IntroClip);
		} 
		
	}
}