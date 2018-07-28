package state
{
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Instructions extends DisplayState
	{	
		/**
		 * gameMode - singeplayer or multiplayer 
		 */		
		private  var m_gameMode:int;
		
		/**
		 * instructions layer 
		 */		
		private var m_instructionScreen:DisplayStateLayer;
		
		/**
		 *	sets game mode
		 * @param mode - game mode
		 * 
		 */		
		public function Instructions(mode:int){
			m_gameMode = mode;
		}
		
		/**
		 * init layer 
		 * 
		 */		
		override public function init():void {
			initLayer();
		} 
		
		/**
		 * creates new layer. 
		 * 
		 */		
		private function initLayer():void {
			m_instructionScreen = this.layers.add("instruction");
			var instrcutionLayer:InstructionLayer = new InstructionLayer(m_gameMode);
			m_instructionScreen.addChild(instrcutionLayer);
		}
	}
}