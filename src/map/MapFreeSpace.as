package map
{

	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.util.MathUtils;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class MapFreeSpace extends DisplayStateLayerSprite
	{
		/**
		 *  Object that the other object not is allowed to spawn on
		 */		
		private var m_checkObejct:Object;
		
		/**
		 * object that is bein spawned 
		 */		
		private var m_obj:Object;
		
		/**
		 *	in what area the object should be spawn. 
		 */		
		private var m_cordsRange:Array = new Array();
		
		/**
		 * 
		 * @param obj			object that get spawn cords
		 * @param checkAgainst	object that the other object cant spawn on
		 * @param cordsRange	in what area the object can spawn
		 * 
		 */		
		public function MapFreeSpace(obj,checkAgainst,cordsRange = null){
			if(cordsRange == null) initCordsRange();
			else m_cordsRange = cordsRange;
			m_obj = obj;
			m_checkObejct = checkAgainst;
			onBankFloor()
		}
	
		/**
		 * default area for spawning is the whole map 
		 * 
		 */		
		private function initCordsRange():void {
			m_cordsRange[0] = 0;
			m_cordsRange[1] = 800;
			m_cordsRange[2] = 50;
			m_cordsRange[3] = 600;	
		}
		
		/**
		 * Control that the random points is not inside the player base or the vault. If it is it call on itself to get new points etc.
		 * 
		 */		
		protected function onBankFloor():void {
			
			var newPos:Array = randomPos();
			//	Player Base
			if(newPos[0] > 150 || newPos[1] > 210){
				// BANK VAULT
				if(newPos[0] < (550 - m_obj.width) || newPos[1] < (400 - m_obj.height) ){
					notColideWithSensors(newPos);
					return;
				}
			}
			onBankFloor();
		}
		
		
		/**
		 *	Control that the object not is inside the checkObjects position
		 * @param newPos - random position
		 * 
		 */		
		private function notColideWithSensors(newPos:Array):void {
			
			m_obj.x = newPos[0];
			m_obj.y = newPos[1];
			for(var i:int = 0; i < m_checkObejct.length; i++){
				if(notInsideObj(m_obj,m_checkObejct[i]) == false){
					onBankFloor();
					return;
				}	
			}	
		}
		
		
		/**
		 *	generate random numbers for position 
		 * @return 
		 * 
		 */		
		private function randomPos():Array {
			var arr:Array = new Array();
			arr[0] = MathUtils.randomRange( m_cordsRange[0],m_cordsRange[1] - m_obj.width) >> 0;
			arr[1] = MathUtils.randomRange(m_cordsRange[2],m_cordsRange[3] - m_obj.height) >> 0;
			return arr;
		}

		/**
		 *	control that obj not is inside objInside 
		 * @param obj
		 * @param objInside
		 * @return 
		 * 
		 */		
		private function notInsideObj(obj,objInside):Boolean{
			if(obj.x > (objInside.x + objInside.width) ||(obj.x + obj.width) < objInside.x || obj.y > (objInside.y + objInside.height) || obj.y + obj.height < objInside.y){
				return true;
			}else return false;
		}
		
		override public function dispose():void {
			super.dispose();
		}
	}
}