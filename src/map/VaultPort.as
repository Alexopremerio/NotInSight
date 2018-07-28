package map
{
	/**
	 * vault asset 
	 */	
	import asset.VaultDoor;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;

	public class VaultPort
	{
		/**
		 *  vaultdoor skin 
		 */		
		public var m_vault_skin:VaultDoor = new VaultDoor();
		
		/**
		 *	check if the vault is open 
		 */		
		public var m_isOpen:Boolean = false;
		
		/**
		 * how faar the vault should move 
		 */		
		private var m_vaultDoorMoveLength:int = 65;
		
		/**
		 * vault speed to open and close 
		 */		
		private var m_vaultDoorSpeed:int = 10;
		
		/**
		 *  vault door timer
		 */		
		private var m_vaulDoorOpenTimer:Timer;
		

		
		/**
		 * vault door sound 
		 */		
		[Embed(source = "../../asset/mp3/vaultdoor.mp3")]
		private  const SOUND_DOOR:Class;
		private static var m_soundDoor:SoundObject;
		
		/**
		 * init sound and sets vault skin 
		 * 
		 */		
		public function VaultPort()
		{
			m_vault_skin.gotoAndStop(1);
			initSound();
		}
		
		/**
		 * vault sound 
		 * 
		 */		
		private function initSound():void {
			Session.sound.soundChannel.sources.add("Door", SOUND_DOOR);
			m_soundDoor = Session.sound.soundChannel.get("Door");
		}
		
		/**
		 * open vault, used by map class  
		 * 
		 */	
		public function openVault():void {
			if(m_isOpen == false){
				m_isOpen = true;
				moveVaultDoor("open");
			}	
		}
		
		/**
		 * close vault, used by map class  
		 * 
		 */		
		public function closeVault():void {
			if(m_isOpen == true){
				m_isOpen = false;
				moveVaultDoor("close");
			} 
		}
		
		/**
		 *	Animate the vaultdoor to open or close.
		 * @param direction - open or close.
		 * 
		 */	
		private function moveVaultDoor(direction):void {
			m_vault_skin.gotoAndPlay(2);
			var counter:int = 0;
			m_soundDoor.play();
			m_vaulDoorOpenTimer = Session.timer.add(new Timer(m_vaultDoorSpeed, function():void {
				counter++;
				if(direction == "open")			m_vault_skin.x++;
				else if(direction == "close")	m_vault_skin.x--;
				if(counter == m_vaultDoorMoveLength)m_vault_skin.gotoAndStop(1);
			},m_vaultDoorMoveLength));
		}
		
		public function dispose():void {
			m_vaulDoorOpenTimer = null;
			m_vault_skin = null;
		}
	}
}