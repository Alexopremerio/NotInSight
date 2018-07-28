package map
{
	/**
	 * flash imports 
	 */	
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * local game imports 
	 */	
	import interactive.InteractiveObjects;
	import map.CoinBag;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;

	public class CoinBagManager
	{
		/**
		 * list with all coinbags 
		 */		
		public var m_coinBags_List:Vector.<CoinBag>;
		
		/**
		 * displayObject for CoinBag class 
		 */		
		private var m_target:DisplayObjectContainer;
		
		/**
		 *  sets displayObject
		 * @param target - displayObject
		 * 
		 */		
		public function CoinBagManager(target:DisplayObjectContainer){
			m_target = target;
			
		}
		
		/**
		 * load coinbags and add them to stage
		 * 
		 */		
		public function initGoldBags():void {
			m_coinBags_List = new Vector.<CoinBag>;
			for(var i:int = 0; i < 5; i++){
				var coinBag:CoinBag = new CoinBag();
				m_coinBags_List.push(coinBag);
				m_target.addChild(coinBag);
			}
			InteractiveObjects.m_coinBagsList = m_coinBags_List;
		}
		
		/**
		 *	Removes all bags from stage and sets a timer when new one should be added.
		 * 	Timer is set to 5 seconds becuase that when the sensors have stopped moving. This allows coinbags to not spawn on a sensor.
		 * 
		 */		
		public function goldBagsTimer():void {
			removeAllMoneyBags();
			var spawnBags:Timer = Session.timer.add(new Timer(5000,initGoldBags));
		}
		
		/**
		 * Remove a Coinbag
		 * @param index
		 * 
		 */		
		public function removeMoneyBag(index):void {

			if(m_coinBags_List[index] && m_coinBags_List[index].parent){
				m_coinBags_List[index].parent.removeChild(m_coinBags_List[index]);
			}
			m_coinBags_List.splice(index,1);
			
		}
		
		/**
		 * Remove all Coinbags 
		 * 
		 */		
		public function removeAllMoneyBags():void {
			for(var i:int = 0; i < m_coinBags_List.length; i++){
				removeMoneyBag(i);
			}
			if(m_coinBags_List.length > 0) removeAllMoneyBags();
		}
		
		/**
		 * Dispose coinbags 
		 * 
		 */		
		public function dispose():void{
			trace("COIN BAG MANAGER ");
			for(var i:int = 0; i < m_coinBags_List.length; i++){
				m_coinBags_List[i].dispose();
				m_coinBags_List.splice(0,1);
				m_coinBags_List[i] = null;
			}
			m_coinBags_List.length = 0;
		}
	}
}