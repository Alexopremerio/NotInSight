package hud
{
	
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;

	
	/**
	 * graphic asset 
	 */	
	import asset.BankMap;
	
	/**
	 * local game files 
	 */	
	import highscore.HighscoreList;
	import hud.Score;
	import state.Game;
	import utils.TextHeading;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	

	public class Hud extends DisplayStateLayerSprite
	{
		/**
		 * Hud width  
		 */		
		public const HUD_WIDTH:int = 800;
		
		/**
		 * Hud height 
		 */		
		public const HUD_HEIGHT:int = 50;
		
		/**
		 * List of textfield containing players coinbag score 
		 */		
		private var inBagCounter:Vector.<TextField>;
		
		/**
		 * Reference to taotal score
		 */		
		private var m_score:Score = Score.sharedInstance();
		
		/**
		 *	Background graphic for hud 
		 */		
		private var m_hudBackground:BankMap;
		
		/**
		 * Refrence to scoreskin 
		 */		
		private var m_scoreSkin:ScoreSkin;
		
		/**
		 * Textfield that display how much points player got to the nearest highscore position 
		 */		
		private var m_scoreleft:TextField;
		
		/**
		 * compare against total score 
		 */		
		private var m_scoreleftCompare:int;
		
		/**
		 * class instance. singleton. 
		 */		
		private static var m_instance:Hud = null;
		
		
		public function Hud(){
		}
		
		/**
		 * Always return same instance if there is no instance then one gets created. 
		 * @return 
		 * 
		 */		
		public static function sharedInstance():Hud {
			if (m_instance == null) {
				m_instance = new Hud();
			}
			return m_instance;
		}
		
		/**
		 * init hud 
		 * 
		 */		
		override public function init():void {
			
			inBagCounter = new Vector.<TextField>;
			m_hudBackground = new BankMap();
			if(Game.m_gameMode == 2) m_hudBackground.gotoAndStop("hud");
			else m_hudBackground.gotoAndStop("hud_singleplayer");
			m_hudBackground.x = 0;
			this.addChild(m_hudBackground);

			m_scoreSkin = ScoreSkin.sharedInstance();
			m_scoreSkin.init();
			this.addChild(m_scoreSkin.m_scoreCounter);
			scoreLeftField();	
		}
		
		/**
		 * Game loop 
		 * compare score to highscore.
		 */		
		override public function update():void {
			highscoreCompare();
		}
		
		/**
		 *	Add players bag score in list
		 * @param field
		 * 
		 */		
		public function addPlayerScore(field:TextField):void {
			inBagCounter.push(field);
			printBagCounter();
		}
		
		/**
		 *	add players bag score to scene 
		 * 
		 */		
		private function printBagCounter():void {
			var xPos:int = 250;
			var yPos:int = 15;
		
			for(var i:int = 0; i < inBagCounter.length; i++){
				inBagCounter[i].x = xPos;
				inBagCounter[i].y = yPos;
				this.addChild(inBagCounter[i]);
				xPos += 140;
			}
		
		}
		
		/**
		 *	Control which highscore to compare against.  
		 * 
		 */		
		public function highscoreCompare():void {
			if(Game.m_gameMode == 1)compareSingleScore();
			else if(Game.m_gameMode == 2) compareMultiScore();
			
		}
		
		/**
		 *	Compare score to singleplayer highscore. 
		 * 
		 */		
		private function compareSingleScore():void {
			
			for(var i:int = HighscoreList.m_singlePlayerRowScore.length -1; i > -1; i--){
				if(m_score.getTotalPoints() < HighscoreList.m_singlePlayerRowScore[i]) {
					var scoreLeft:int = HighscoreList.m_singlePlayerRowScore[i] - m_score.getTotalPoints();
					updateScoreControl(scoreLeft,i);
						return
					} else if (m_score.getTotalPoints() > HighscoreList.m_singlePlayerRowScore[0]) updateScoreControl(0,0);
				}
		}
		
		/**
		 *	Compare score to multiplayer highscore. 
		 * 
		 */	
		private function compareMultiScore():void {
			for(var i:int = HighscoreList.m_multiPlayerRowScore.length -1; i > -1; i--){
				if(m_score.getTotalPoints() < HighscoreList.m_multiPlayerRowScore[i]) {
					var scoreLeft:int = HighscoreList.m_multiPlayerRowScore[i] - m_score.getTotalPoints();
					updateScoreControl(scoreLeft,i);
					return
				} else if (m_score.getTotalPoints() > HighscoreList.m_multiPlayerRowScore[0]) updateScoreControl(0,0);

			}
		}
		
		/**
		 * Update score 
		 * @param score
		 * @param index
		 * 
		 */		
		private function updateScoreControl(score,index):void {
			if( m_scoreleftCompare != score) {
				m_scoreleftCompare = score;
				var pos:String = [index + 1].toString();
				updateScoreLeftField(pos + ": " + score.toString());
				pos = "";
			}
			
		}
		
		
		/**
		 * print score left 
		 * @param scoreLeft
		 * 
		 */		
		private function updateScoreLeftField(scoreLeft:String):void {
			m_scoreleft.text = "Pos " + scoreLeft;
		}
		
		
		
		/**
		 * create textfield for score left
		 * 
		 */		
		private function scoreLeftField():void{
			var textHeading:TextHeading = new TextHeading("","hud",0x000000);
			m_scoreleft = textHeading.getField();
			m_scoreleft.width = 200;
			m_scoreleft.x = 630;
			m_scoreleft.y = 15;
			this.addChild(m_scoreleft);
		}
		
		/**
		 * dispose 
		 * 
		 */		
		override public function dispose():void {
			// Lägga till
			trace("DISPOSE HUD");
			if(m_hudBackground.parent) m_hudBackground.parent.removeChild(m_hudBackground);
			if(m_scoreleft.parent) m_scoreleft.parent.removeChild(m_scoreleft);
			
			
			m_scoreSkin.dispose();
			clearList(inBagCounter)
			m_hudBackground = null;
			m_scoreleft = null;
			
			m_scoreleftCompare = null;
			
		}
		
		private function clearList(list):void {
			for (var i:int = 0; i < list.length; i++) {
				if(list[i].parent){
					list[i].parent.removeChild(list[i]);
				}
				list[i] = null;
				
			}
			list.length = 0;
		}
	}
}