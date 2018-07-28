package interactive
{
	/**
	 * local game files 
	 */	
	import character.enemy.Guard;
	import character.enemy.Sensor;
	import character.player.Player;
	import map.CoinBag;
	import map.MapPlatforms;
	import map.VaultPlatform;
	
	/**
	 * Public static class that have reference to all interactive objects. 
	 * @author alexanderolsson
	 * 
	 */	
	public class InteractiveObjects	{
		
		/**
		 * Sensors 
		 */		
		public static var m_sensorList:Vector.<Sensor>;
		
		/**
		 * Guards 
		 */		
		public static var m_guardList:Vector.<Guard>;
		
		/**
		 * Robbers (players) 
		 */		
		public static var m_robberList:Vector.<Player>;
	
		/**
		 * Coinbags 
		 */		
		public static var m_coinBagsList:Vector.<CoinBag>;
		
		/**
		 *  Map platforms
		 */		
		public static var m_mapPlatformList:Vector.<MapPlatforms>
		
		
		/**
		 * Vault platforms. Multiplayer only
		 */	
		public static var m_vaultPlatformList:Vector.<VaultPlatform>
		
		
		public function InteractiveObjects(){
		}
	}
}