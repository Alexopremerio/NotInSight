package map
{
	/**
	 * map assets 
	 */	
	import asset.BankMap;

	public class BuildMap
	{
		
		/**
		 * map width 
		 */		
		public const MAP_WIDTH:int = 800;
		
		/**
		 * map height 
		 */		
		public const MAP_HEIGHT:int = 550;
		
		/**
		 * map start postion in y axes. 
		 */		
		public const MAP_START:int = 50;
		
		/**
		 * map asset bank floor 
		 */		
		public var m_bankFloor:BankMap;
		
		/**
		 * Area outside playerbase and vault where guards is not allowed to walk 
		 */		
		public var m_floorRestrictionOutsideVault:BankMap;

		/**
		 * map assets refrence used for collision etc. 
		 */		
		public var m_collisionObjects:Vector.<Object>;
		public var m_mapSafePlaces:Vector.<Object>;
		public var m_vault_doors:Vector.<Object>;
		public var m_moneyPlaces:Vector.<Object>;
		public var m_guardRestrict:Vector.<Object>;
		
		/**
		 * vault floor 
		 */		
		public var m_skinVault1:BankMap;
		public var m_skinVault2:BankMap;
		
		private var m_gameMode:int;
		
		/**
		 * set game mode. 
		 * @param mode - singleplayer/multiplayer.
		 * 
		 */		
		public function BuildMap(mode){
			m_gameMode = mode;
			prepareBuild();	
		}
		
		/**
		 * init vector list for refrence to assets. 
		 * 
		 */		
		private function prepareBuild():void{
			m_collisionObjects = new Vector.<Object>();
			m_mapSafePlaces = new Vector.<Object>();
			m_moneyPlaces = new Vector.<Object>();
			m_vault_doors = new Vector.<Object>();
			m_guardRestrict = new Vector.<Object>();
			
			buildBankFloor();
			buildPlayerBase();
			if(m_gameMode == 2) buildMultiPlayerAssets();
			buildVault();
		}
		
		/**
		 * built bank floor. 
		 * 
		 */		
		private function buildBankFloor():void {
			m_bankFloor = new BankMap();
			m_bankFloor.gotoAndStop("bank_floor");
			m_bankFloor.x = 0;
			m_bankFloor.y = 0;

			m_floorRestrictionOutsideVault = new BankMap();
			m_floorRestrictionOutsideVault.gotoAndStop("guard_restrict");
			m_floorRestrictionOutsideVault.x = 650;
			m_floorRestrictionOutsideVault.y = 400;
			m_guardRestrict.push(m_floorRestrictionOutsideVault);
			
			var floorRestriction:BankMap = new BankMap();
			floorRestriction.gotoAndStop("guard_restrict");
			floorRestriction.width = 145;
			floorRestriction.height =  80;
			floorRestriction.x = 0;
			floorRestriction.y = 200;
			m_guardRestrict.push(floorRestriction);
		}
		
		/**
		 * Building player base assets 
		 * 
		 */		
		private function buildPlayerBase():void {
			
			var skin_base:BankMap = new BankMap();
			skin_base.x = -4;
			skin_base.y = 47;
			skin_base.height = 120;
			skin_base.width = 180;
			skin_base.gotoAndStop("playerBase3");
			m_mapSafePlaces.push(skin_base);
			
			
			var base_wall_bottom_left:BankMap = new BankMap();
			base_wall_bottom_left.gotoAndStop("base_wall_bottom");
			base_wall_bottom_left.x = -45;
			base_wall_bottom_left.y =  skin_base.height + 30;
			m_collisionObjects.push(base_wall_bottom_left);
			

			var base_wall_bottom_right:BankMap  = new BankMap();
			base_wall_bottom_right.x = 75;
			base_wall_bottom_right.y = skin_base.height + 30;
			base_wall_bottom_right.width = 236;
			base_wall_bottom_right.gotoAndStop("base_wall_bottom");
			m_collisionObjects.push(base_wall_bottom_right);
			
			var base_wall_right:BankMap = new BankMap();
			base_wall_right.x = skin_base.width - 6;
			base_wall_right.y = -9;
			base_wall_right.gotoAndStop("base_wall_right");
			m_collisionObjects.push(base_wall_right);
			
			// drop money = car
			var skin_leaveMoney:BankMap = new BankMap();
			skin_leaveMoney.gotoAndStop("dropZone");
			skin_leaveMoney.x = -17;
			skin_leaveMoney.width = 150;
			skin_leaveMoney.height = 100;
			skin_leaveMoney.y = MAP_START;
			m_moneyPlaces.push(skin_leaveMoney);
		}
		
		
		/**
		 * asset for the map vault 
		 * 
		 */		
		private function buildVault():void {
			
			m_skinVault1 = new BankMap();
			m_skinVault1.gotoAndStop("vault_floor");
			m_skinVault1.x = MAP_WIDTH - m_skinVault1.width;
			m_skinVault1.y = 600 - m_skinVault1.height;
			m_mapSafePlaces.push(m_skinVault1);
			
			var vault_door:VaultPort = new VaultPort();
			vault_door.m_vault_skin.x = MAP_WIDTH - (vault_door.m_vault_skin.width + 37);
			vault_door.m_vault_skin.y = 600 - (m_skinVault1.height * 1.13);
			m_vault_doors.push(vault_door);
			m_collisionObjects.push(vault_door.m_vault_skin);
			
			var vault_wall:BankMap = new BankMap();
			vault_wall.gotoAndStop("vault_wall");
			
			vault_wall.x = MAP_WIDTH - vault_wall.width
			vault_wall.y = 600 - (m_skinVault1.height * 1.15);
			m_collisionObjects.push(vault_wall);
			
			var vault_top_box:BankMap = new BankMap();
			vault_top_box.gotoAndStop("vault_top_box");
			vault_top_box.width = 116;
			vault_top_box.x = MAP_WIDTH - m_skinVault1.width;
			vault_top_box.y = 600 - (m_skinVault1.height * 1.15) ;
			m_collisionObjects.push(vault_top_box);
			
			
			var skin_getMoney:BankMap = new BankMap();
			skin_getMoney.gotoAndStop("vault_gold");
			skin_getMoney.x = MAP_WIDTH - m_skinVault1.width - 7;
			skin_getMoney.y = 600 - m_skinVault1.height;
			m_moneyPlaces.push(skin_getMoney);
			
			var vault_left_box:BankMap = new BankMap();
			vault_left_box.gotoAndStop("vault_left_box");
			vault_left_box.x = 800 - (m_skinVault1.width + vault_left_box.width);
			vault_left_box.y = 600 - (m_skinVault1.height * 1.14);
			m_collisionObjects.push(vault_left_box);
			
		}
		
		/**
		 * building map for multiplayer. 1 extra room before entering the vault.
		 * 
		 */		
		private function buildMultiPlayerAssets():void {
			
			m_floorRestrictionOutsideVault.y = 320;
			var offsetY:int = 200;
			
			m_skinVault2 = new BankMap();
			m_skinVault2.gotoAndStop("vault_floor");
			m_skinVault2.x = MAP_WIDTH - 153;
			m_skinVault2.y = 600 - (offsetY - 5);
			m_mapSafePlaces.push(m_skinVault2);
			
			var vault_door2:VaultPort = new VaultPort();
			vault_door2.m_vault_skin.x = 800 - (vault_door2.m_vault_skin.width + 37);
			vault_door2.m_vault_skin.y = 600 - (offsetY - 2);
			m_vault_doors.push(vault_door2);
			m_collisionObjects.push(vault_door2.m_vault_skin);
			
			var vault_wall_right:BankMap = new BankMap();
			vault_wall_right.gotoAndStop("vault_wall");
			vault_wall_right.x = 800 - vault_wall_right.width;
			vault_wall_right.y = 600 - offsetY;
			m_collisionObjects.push(vault_wall_right);
			

			var vault_wall_left:BankMap = new BankMap();
			vault_wall_left.gotoAndStop("vault_wall");
			vault_wall_left.width = 43;
			vault_wall_left.x = 800 - (vault_wall_left.width + vault_door2.m_vault_skin.width + 32);
			vault_wall_left.y = 600 - offsetY;
			m_collisionObjects.push(vault_wall_left);
			
		
			var vault_left_box2:BankMap = new BankMap();
			vault_left_box2.gotoAndStop("vault_left_box");
			vault_left_box2.height = 100;
			vault_left_box2.x = 800 - (vault_door2.m_vault_skin.width + vault_wall_right.width + 50);
			vault_left_box2.y = 600 - offsetY;
			m_collisionObjects.push(vault_left_box2);
			
		}
		
		/**
		 * dispose map assets 
		 * 
		 */		
		public function dispose():void {
			trace("dispose build map");
			clearList(m_collisionObjects);
			clearList(m_mapSafePlaces);
			clearList(m_moneyPlaces);
			clearList2(m_vault_doors);
			if(m_bankFloor.parent) m_bankFloor.parent.removeChild(m_bankFloor);
			if(m_floorRestrictionOutsideVault.parent) m_floorRestrictionOutsideVault.parent.removeChild(m_floorRestrictionOutsideVault);
			
		}
		
		/**
		 * loop list with assets 
		 * @param list
		 * 
		 */		
		private function clearList(list:Vector.<Object>):void {
			for(var i:int = 0; i < list.length; i++){
				if(list[i].parent){
					trace("REMOVE S FROMS TAGE BUILDMAP");
					list[i].parent.removeChild(list[i]);
				}
				list[i] = null;
			}
		}
		
		private function clearList2(list:Vector.<Object>):void {
			for (var i:int = 0; i < list.length; i++) {
				list[i].dispose();
				list[i] = null;
				list.splice(0,1);
			}
			list.length = 0;
		}
	}
}