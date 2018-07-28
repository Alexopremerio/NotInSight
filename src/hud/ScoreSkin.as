package hud
{	
	
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;
	
	/**
	 * local game files 
	 */	
	import utils.TextHeading;
	
	
	/**
	 * Skin for player score
	 * 
	 * @author Alexander Olsson
	 * 
	 */	
	public class ScoreSkin
	{
		
		public var m_scoreCounter:TextField;
		private var m_color:uint = 0xababab;
		private const TEXT_SIZE:int = 25;
		private const FIELD_HEIGHT:int = 600;
		private const FIELD_WIDTH:int = 200;
		private var m_lastScore:int;
		
		/**
		 * Textfield calss 
		 */		
		public var m_textHeading:TextHeading;
		
		/**
		 * The singleton instance 
		 */		
		private static var m_instance:ScoreSkin = null;
		
		/**
		 * Should not be instantiated 
		 * 
		 */		
		public function ScoreSkin() 
		{
			
		}
		
		/**
		 *  Singleton return same instance
		 * @return - instance
		 * 
		 */		
		public static function sharedInstance():ScoreSkin {
			if (m_instance == null) {
				m_instance = new ScoreSkin();
			}
			return m_instance;
		}
		
		/**
		 * init new Textfield and sets it's position 
		 * 
		 */		
		public function init():void {
			m_textHeading = new TextHeading("","hud",0x000000)
			m_scoreCounter = m_textHeading.getField();
			formatField();
			m_scoreCounter.x = 35;
			m_scoreCounter.y = 15;
			update("1000");
		}
		
		
		/**
		 * Update textField 
		 * @param value - Score value
		 * 
		 */		
		public function update(value:String):void {
			m_scoreCounter.text = "Score:" + value
		}
		

		/**
		 * Set textfield width and height
		 * 
		 */		
		private function formatField():void {
			m_scoreCounter.width = FIELD_WIDTH; 
			m_scoreCounter.height = FIELD_HEIGHT;
		}
		
		/**
		 * Dispose
		 * 
		 */		
		public function dispose():void {
			if(m_scoreCounter.parent) m_scoreCounter.parent.removeChild(m_scoreCounter);
			
			m_scoreCounter = null;
			
		}

	}
}