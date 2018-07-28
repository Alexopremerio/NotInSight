package utils
{
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class TextHeading
	{
		
		/**
		 * default font color 
		 */		
		private var FONT_COLOR:uint = 0xFFFFFF;
		
		/**
		 * default text width 
		 */		
		private const TEXT_WIDTH:int = 400;
		
		/**
		 * deafult text height 
		 */		
		private const TEXT_HEIGHT:int = 40;
		
		/**
		 * textfield 
		 */		
		public var textField:TextField = new TextField();
		
		/**
		 * textformat 
		 */		
		public var textFormat:TextFormat = new TextFormat();
		
		
		/**
		 *	init a textField and format it depending on the type argument
		 * @param txt
		 * @param type
		 * @param color
		 * 
		 */		
		public function TextHeading(txt:String,type,color:uint) {
			textField.text = txt;
			textField.width = TEXT_WIDTH;
			textField.height = TEXT_HEIGHT;
			FONT_COLOR = color;
			if(type == "menu") textFormatMenu();
			else if(type == "highscore") textFormatHighscore();
			else if(type == "hud") textFormatHud();
		}
		
		/**
		 *	textFormat for the menu textfield 
		 * 
		 */		
		private function textFormatMenu():void {
			textFormat.size = 20;
			textFormat.font = "DrivingAround";
			textFormat.align = TextFormatAlign.CENTER;
			textField.setTextFormat(textFormat);
		}
		
		/**
		 *	textFormat for the highscore textfield 
		 * 
		 */		
		private function textFormatHighscore():void {
			textFormat.size = 16;
			textFormat.font = "DrivingAround";
			textFormat.align = TextFormatAlign.LEFT;
			//textField.defaultTextFormat = textFormat;	
			textField.setTextFormat(textFormat);
			
		}
		
		/**
		 *	textFormat for the hud textfield 
		 * 
		 */		
		private function textFormatHud():void {
			textFormat.font = "DrivingAround";
			textFormat.size = 25;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color = FONT_COLOR;
			textField.defaultTextFormat = textFormat;
		}
		
		/**
		 *  enable embedded fonts
		 * @return textField
		 * 
		 */		
		public function getField():TextField {
			textField.embedFonts = true;
			return textField;
		}
		
		/**
		 *	Textanimation when score changes, used for the hud
		 * 
		 */		
		public function textAnimation():void{
			var counter:int = 1;
			var increase:int = 0;
			var animationText:Timer = Session.timer.add(new Timer(10, function():void {	
				if(counter < 10){
					increase++;
					textFormat.size = 25 + increase;
					textField.setTextFormat(textFormat);
					
				} else if(counter > 10){
					increase--;
					textFormat.size = 25 + increase;
					textField.setTextFormat(textFormat);
				}
				counter++;	
			},20));
		}
		
		/**
		 *	Textanimation when score changes, used for the hud
		 * 
		 */	
		public function textAnimationNegative():void{
			var counter:int = 1;
			var increase:int = 0;
			var animationText:Timer = Session.timer.add(new Timer(10, function():void {	
				if(counter < 5){
					increase++;
					textFormat.color = 0xe03602;
					textFormat.size = 25 + increase;
					textField.setTextFormat(textFormat);
				} else if(counter > 5){
					increase--;
					textFormat.color = FONT_COLOR;
					textFormat.size = 25 + increase;
					textField.setTextFormat(textFormat);
				}
				counter++;
			},8));
		}
		
	
	}
}