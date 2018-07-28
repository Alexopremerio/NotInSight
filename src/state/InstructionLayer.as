package state
{
	
	/**
	 * flash imports 
	 */	
	import flash.display.MovieClip;
	
	/**
	 * instrcutions assets
	 */	
	import asset.GameInstruction;
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class InstructionLayer extends DisplayStateLayerSprite
	{
		/**
		 *	 Instructions graphic
		 */		
		private var m_instruction:MovieClip;
		
		/**
		 * game mode. Singleplayer/Multiplayer 
		 */		
		private  var m_gameMode:int;
		
		/**
		 *	sets game mode 
		 * @param mode
		 * 
		 */		
		public function InstructionLayer(mode:int) {
			m_gameMode = mode;
		}
		
		/**
		 * init instrcution graphic 
		 * 
		 */		
		override public function init():void { 		
			this.init_Instructions();					
		}
		
		/**
		 * init instructions  
		 * 
		 */		
		private function init_Instructions():void {
			this.m_instruction = new GameInstruction();
			if(m_gameMode == 1)this.m_instruction.gotoAndStop("singleplayer_instructions");
			else if (m_gameMode == 2)this.m_instruction.gotoAndStop("multiplayer_instructions");
			this.addChild(this.m_instruction);
			
		} 
		
		/**
		 * Updates controls 
		 * 
		 */		
		override public function update():void { 	
			this.m_updateControls(); 				
		} 
		
		/**
		 *	Controls for continue to game 
		 * 
		 */		
		private function m_updateControls():void {	
			if (Input.keyboard.justPressed("ONE")) Session.application.displayState = new Game(m_gameMode);
			if (Input.keyboard.justPressed("L")) Session.application.displayState = new Game(m_gameMode);
		}
		
		/**
		 *	dispose
		 * 
		 */		
		override public function dispose():void { 
			m_instruction = null;
		} 
	}
}