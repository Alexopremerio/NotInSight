package
{
	import state.Init;
	
	import se.lnu.stickossdk.system.Engine;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	public class NotInSight extends Engine
	{
		public function NotInSight()
		{  
			
		}
		
		override public function setup():void
		{
			this.initId = 39;
			this.initDebugger = true;
			this.initDisplayState = Init;
		//	this.initExternalDatabaseLocation = "http://catuar.lnu.se/lab/stickos";
		}
		
	}
}