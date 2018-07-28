package map
{
	/**
	 * graphic imports 
	 */	
	 import assets.vault_openers2;
	 
	 /**
	  * local game imports 
	  */	 
	 import interactive.InteractiveObjects;
	 import map.MapFreeSpace;
	 
	 /**
	  * sdk imports 
	  */	 
	 import se.lnu.stickossdk.media.SoundObject;
	 import se.lnu.stickossdk.system.Session;
	 
	public class MapPlatforms extends MapFreeSpace
	{
		/**
		 * platfrom graphic asset 
		 */		
		public var m_platform:vault_openers2 =  new vault_openers2();
		
		/**
		 * if player collided with platfrom
		 */		
		public var m_hit:Boolean = false;
		
		/**
		 * platform sound 
		 */		
		[Embed(source = "../../asset/mp3/platform.mp3")]
		private  const SOUND_PLATFORM:Class;
		private static var m_soundPlatform:SoundObject;
		
		/**
		 * sending platfrom and sensors to parent. This make sure a platfrom wont spawn on a sensor.
		 *  
		 * 
		 */		
		public function MapPlatforms()	{
			super(m_platform,InteractiveObjects.m_sensorList);
			
		}
		
		/**
		 *	init sound and platform 
		 * 
		 */		
		override public function init():void{
			super.init();
			m_initSound();
			this.addChild(m_platform);
			m_platform.gotoAndStop(1);
		}
		
		/**
		 * Game loop
		 * 
		 * 
		 */		
		override public function update():void{
			super.update();
			stopOnLastFrame();
		}
		
		/**
		 *	init sound for when platform got hit
		 * 
		 * 
		 */		
		private function m_initSound():void {
			Session.sound.soundChannel.sources.add("Platform", SOUND_PLATFORM);
			m_soundPlatform = Session.sound.soundChannel.get("Platform");
		}
		 
		/**
		 *  Platfrom got hit by player. Turn platform from red to green and play sound.
		 * 
		 */		
		public function gotHit():void{
			if(m_platform.currentFrame == m_platform.totalFrames) return;
			m_platform.play();
			m_soundPlatform.play();
			m_hit = true;
		}
	
		/**
		 * prevent moveclip from replaying
		 * 
		 */		
		private function stopOnLastFrame(): void {
			if(m_platform.currentFrame == m_platform.totalFrames) m_platform.stop();
		}
		
		/**
		 * Reset platforms and sets new position 
		 * 
		 */		
		public function getnewPosition():void {
			reset();
			onBankFloor();
		}
		
		/**
		 * reset platfrom = red again. 
		 * 
		 */		
		private function reset():void {
			m_hit = false;
			m_platform.gotoAndStop(1);
		}
		
		override public function dispose():void{
			trace("dispose Map platform");
			
			m_platform = null;
		}
		
		
	}
}