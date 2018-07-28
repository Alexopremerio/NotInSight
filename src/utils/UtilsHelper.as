package utils
{
	public class UtilsHelper
	{
		public function UtilsHelper()
		{
		}
		
		
		/**
		 *  Check if a object is inside another object cordinates
		 * 
		 * @param obj
		 * @param objInside
		 * @return 
		 * 
		 */		
		public static function insideObj(obj,objInside):Boolean{
			if(obj.x > objInside.x && obj.x < (objInside.x + objInside.width) && obj.y > objInside.y && obj.y < objInside.y + objInside.height) return true;
			else return false;
		}
		
	
		
	}
}