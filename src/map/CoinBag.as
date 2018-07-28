package map
{
	
		
		
	/**
	 * Graphic assets 
	 */	
	import asset.BankMap;
	
	/**
	 * local game files 
	 */	
	import interactive.InteractiveObjects;
	
	
	public class CoinBag extends MapFreeSpace
	{
		/**
		 *	Coinbag graphic  
		 */		
		public var m_bag:BankMap = new BankMap();
		
		/**
		 *	sends coinbag and sensors to parent. This make sure a coinbags wont spawn on a sensor
		 * 
		 */		
		public function CoinBag()	{
			
			super(m_bag,InteractiveObjects.m_sensorList);
		}
		
		/**
		 * init graphic for moneyBag and randomize position 
		 * 
		 */		
		override public function init():void{
			m_bag.gotoAndStop("goldbags");
			this.addChild(m_bag);
			onBankFloor();
		}
		
		/**
		 * update loop 
		 * 
		 */		
		override public function update():void{
			super.update();
		}
		
		/**
		 * remove itself 
		 * 
		 */		
		public function removeBag():void {
			this.parent.removeChild(this);
		}
		
		override public function dispose():void {
			trace("dispose coinbag");
			m_bag = null;
		}
		
	}
}