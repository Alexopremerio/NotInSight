package hud
{
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;

	/**
	 * local game files 
	 */	
	import hud.Score;
	import utils.TextHeading;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	
	/**
	 * This class controls the player bag with money. All money player pick up saves in this bag.
	 *  This bag clears when player leave the money in the car.
	 * @author Alexander Olsson
	 * 
	 */	
	public class PlayerBagScore
	{
		/**
		 * Refrence to the totalscore 
		 */		
		private var m_score:Score = Score.sharedInstance();
		
		/**
		 * Hud reference 
		 */		
		private var m_hud:Hud = Hud.sharedInstance();
		
		/**
		 * bag score 
		 */		
		private var m_playerScore:int = 0;
		
		/**
		 * value of a gold bag 
		 */		
		private const GOLD_BAG_VALUE:int = 75;
		
		/**
		 * textfield that display points in bag 
		 */		
		private var m_field:TextField;
		
		/**
		 * name for the player. Player one or two. 
		 */		
		private var m_playerName:String = "";
		
		/**
		 * default text color 
		 */		
		private var m_textColor:uint;
		
		/**
		 * Refrence to textHeading 
		 */		
		private var m_textHeading:TextHeading;
		
		/**
		 *	value when robbing the bank 
		 */		
		private static const ROBBING_BANK_VALUE:int = 500;
		
		/**
		 * Sound when player dropoff money 
		 */		
		[Embed(source = "../../asset/mp3/leaving_money.mp3")]
		private  const SOUND_LEAVE_MONEY:Class;
		private var m_leaveMoney:SoundObject;
		
		/**
		 * font for textfield
		 */		
		[Embed(source = "../../asset/ttf/DrivingAround.ttf", fontFamily = "DrivingAround", mimeType = "application/x-font", embedAsCFF="false")] 
		public static const HUD_FONT:Class;
		
		/**
		 *  sets name and color. Init score and sound.
		 * @param player - playerName
		 * @param color  - color of the textfield
		 * 
		 */		
		public function PlayerBagScore(player:String,color:uint)	{
			m_playerName = player;
			m_textColor = color;
			textScore();
			m_initSound();
		}
		
		/**
		 * init sound. 
		 * 
		 */		
		private function m_initSound():void {
			Session.sound.soundChannel.sources.add("LeaveMoney", SOUND_LEAVE_MONEY);
			m_leaveMoney = Session.sound.soundChannel.get("LeaveMoney");
		}
		
		/**
		 * add value when player picks up a gold bag
		 * updates score 
		 * 
		 */		
		public function addGoldBag():void {
			m_playerScore += GOLD_BAG_VALUE;
			update();
		}
		
		/**
		 * reset the score
		 * updates score 
		 * 
		 */		
		private function resetScore():void {
			m_playerScore = 0;
			update();
		}
		
		/**
		 * add value when player have robbed the bank
		 * updates score 
		 * 
		 */		
		public function addGoldBank():void {
			m_playerScore += ROBBING_BANK_VALUE;
			update();
		}
		
		/**
		 * called from player class when player dropoff money 
		 * add the bag value to the totalscore
		 * 
		 */		
		public function addToTotal():void {
			if(m_playerScore <= 0) return;
			m_leaveMoney.volume = 0.5;
			m_leaveMoney.play();
			m_score.addPoints(m_playerScore);
			resetScore();
		}
		
		 /**
		  * update the textfield
		  * does a animation for feedback 
		  * 
		  */		
		 public function update():void {
			 m_field.text = m_playerName  +m_playerScore.toString();
			 m_textHeading.textAnimation();
		}
		
		/**
		 *	creates textfield and sends it to the Hud class that adds it to the scene. 
		 * 
		 */		 
		private function textScore():void {
			m_textHeading = new TextHeading("","hud",m_textColor);
			m_field = m_textHeading.getField();
			m_field.text = m_playerName + m_playerScore;
			m_hud.addPlayerScore(m_field);	
		}
	
	}
}