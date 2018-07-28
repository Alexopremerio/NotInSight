package map
{
	/**
	 * grahpic import 
	 */	
	import asset.BankMap;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;

	public class CoinDrop extends DisplayStateLayerSprite
	{	
		/**
		 * Coin grahpic 
		 */		
		public var m_skin_coin:BankMap;
		
		/**
		 * Timer that removes coin 
		 */		
		private var m_removeTimer:Timer;
		
		/**
		 * create new coin and sets it's x and y position and removes it after some time.
		 *  
		 * @param xPos - players xPos
		 * @param yPos - players yPos
		 * @param label - coinlabel,  diffrent label for diffrent coins
		 * 
		 */		
		public function CoinDrop(xPos,yPos,label)
		{
		
			m_skin_coin = new BankMap();
			m_skin_coin.gotoAndStop(label);
			m_skin_coin.x = xPos;
			m_skin_coin.y = yPos;
			m_removeTimer =  Session.timer.add(new Timer(200,fadeAwayCoin,10));
		}
		
		/**
		 * fade coin slowly away. When alpha is 0 call for dispose. 
		 * 
		 */		
		private function fadeAwayCoin():void {
			if(m_skin_coin.alpha < 0) dispose(); 
			m_skin_coin.alpha -= 0.1;
		
		}
		
		
		/**
		 * dispose coins  
		 * 
		 */		
		private function dispose():void {
			m_skin_coin.parent.removeChild(m_skin_coin);
			m_removeTimer = null;
		}
	}
}