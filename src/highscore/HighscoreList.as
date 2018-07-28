package highscore
{
	
	
	public  class HighscoreList
	{
		/**
		 * public highscore list 
		 */		
		public static  var m_singlePlayerRowScore		:Vector.<int> = new Vector.<int>();
		
		/**
		 * public highscore list 
		 */		
		public static  var m_multiPlayerRowScore		:Vector.<int> = new Vector.<int>();
		
		public function HighscoreList(){
		}
		
		/**
		 * dispose 
		 * 
		 */		
		public static function dispose():void {
			disposeList(m_singlePlayerRowScore);
			disposeList(m_multiPlayerRowScore);
		}
		
		/**
		 * dispose lists 
		 * @param list
		 * 
		 */		
		private static function disposeList(list:Vector.<int>):void {
			for (var i:int = 0; i < list.length; i++) {
				list[i] = null;
				list.splice(0,1);
			}
			list.length = 0;
		}		
	}
}