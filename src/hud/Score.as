package hud
{


	public class Score
	{
		
		/**
		 *  Cost of dropping coin
		 */		
		private static const COIN_SPEND:int = 40;
		
		/**
		 * Start points 
		 */		
		private static var m_totalPoints:int = 1000;
		
		/**
		 * Class instance 
		 */		
		private static var m_instance:Score = null;
		
		/**
		 * Refrence to the textfield class
		 */		
		public var m_scoreSkin:ScoreSkin;
		
		
		public function Score() {
		
			m_scoreSkin = ScoreSkin.sharedInstance();
		}
		
		/**
		 * Always return the same instance. If there is no instance then one gets created. 
		 * @return - instance
		 * 
		 */		
		public static function sharedInstance():Score {
			if (m_instance == null) {
				m_instance = new Score();
				m_totalPoints = 1000;
			}
			return m_instance;
		}
		
		/**
		 * add points to total points. This is used when player turn in his coinbag. 
		 * @param points
		 * 
		 */		
		public  function addPoints(points):void {
			m_totalPoints += points;
			m_scoreSkin.update(getTotalPoints().toString());
			m_scoreSkin.m_textHeading.textAnimation();
		}
		
		/**
		 * reduce points from score. This is used when the player is dropping coins 
		 * 
		 */		
		public  function reducePoints():void {
			m_totalPoints -= COIN_SPEND;
			m_scoreSkin.update(getTotalPoints().toString());
			m_scoreSkin.m_textHeading.textAnimationNegative();
			
		}
		
		/**
		 * control if player can spend coins. 
		 * @return 
		 * 
		 */		
		public  function canSpend():Boolean {
			if(m_totalPoints >= COIN_SPEND) return true;
			else return false
		}
		
		/**
		 *	return total points 
		 * @return - total points
		 * 
		 */		
		public function getTotalPoints():int {
			return m_totalPoints;
		}
		
		/**
		 * dispose 
		 * 
		 */		
		public function dispose():void {
			trace("DIPOSE SCORE ");
			m_instance = null;
		}
		
		
	}
}