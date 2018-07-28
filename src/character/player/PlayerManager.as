package character.player
{
	/**
	 * flash imports 
	 */	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * local game files 
	 */	
	import character.player.RobberOne;
	import character.player.RobberTwo;
	import map.Map;
	
	

	public class PlayerManager
	{
		/**
		 * list of players 
		 */		
		public var m_robberList:Vector.<Player>;
	
		/**
		 * player 1 
		 */		
		private var m_robberOne:RobberOne;
		
		/**
		 * player 2 
		 */		
		private var m_robberTwo:RobberTwo;
		
		/**
		 * game mode. Singleplayer/Multiplayer
		 */		
		private var m_mode:int;
		
		/**
		 * displayObject used to add players to stage 
		 */		
		private var m_target:DisplayObjectContainer;
		
		/**
		 * refrence to map 
		 */		
		private var m_map:Map =  Map.sharedInstance();

		
		/**
		 *	 set mode and taget.
		 * @param mode	-	game mode
		 * @param target-	used to add players to stage
		 * 
		 */		
		public function PlayerManager(mode:int,target:DisplayObjectContainer){
			m_mode = mode;
			m_target = target;
			initPlayer();
		}
		
		/**
		 *	init player one 
		 * 
		 */		
		private function initPlayer():void {
			
			m_robberList = new Vector.<Player>;
			m_robberOne = new RobberOne();
			m_robberOne.collisionCallback = playerCollision;
			m_robberList.push(m_robberOne);
			m_target.addChild(m_robberOne);
			if(m_mode == 2) initPlayerTwo();		
		}
		
		/**
		 * init player two 
		 * 
		 */		
		private function initPlayerTwo():void {
			m_robberTwo = new RobberTwo();
			m_robberTwo.collisionCallback = playerCollision;
			m_robberList.push(m_robberTwo);
			m_target.addChild(m_robberTwo);
		}
		
		/**
		 * dipose guards 
		 * 
		 */		
		public function dispose():void {
			for(var i:int = 0; i < m_robberList.length; i++){
				m_robberList[i].dispose();
				m_robberList.splice(0,1);
				m_robberList[i] = null;
			}
			m_robberList.length = 0;
			m_robberOne = null;
			m_robberTwo = null;
			m_target = null;
		}
		
		
		public function playerCollision(that):void {
		}
		
		
	
	}
}