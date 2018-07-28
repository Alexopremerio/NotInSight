package character.player
{
	/**
	 *  player asset skin 
	 */	
	import asset.player;
	
	/**
	 * local game files 
	 */	
	import hud.PlayerBagScore;
	import interactive.InteractiveObjects;
	import state.Game;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	

	public class RobberOne extends Player
	{
		
		/**
		 * 	Constructor Player one 
		 *  passing playerskin, coinskin and controls to parent. Setting players start position.	
		 * 
		 */			
		public function RobberOne()
		{	
			super(player,"coin", EvertronControls.PLAYER_ONE);
			this.x = 20;
			this.y = 150;
		}
		
		/**
		 * Creates new money bag for player.
		 * 
		 */		
		override public function init():void{
			super.init();
			m_playerBagScore = new PlayerBagScore("P1:",0xD64728);
			capturedControl();
			
		}
		
		/**
		 * Game loop
		 * 
		 */		
		override public function update():void{
			super.update();
			capturedControl();
		}
		
		/**
		 * control if a players can be rescued multiplayer only! 
		 * 
		 */		
		private function capturedControl():void {
			
			if(Game.m_gameMode == 2){
				if(this.m_captured == true && this.m_canBeRescued == true && this.m_immortal == false) rescueCollison();	
			}
			
		}
		
		/**
		 * When guard have arrested player. sets visiblity to true and check if other player rescue this player
		 *  
		 */		
		private function rescueCollison():void {
			this.alpha = 1;
			if(InteractiveObjects.m_robberList[1].m_immortal == true)return;
			
			if(this.hitTestObject(InteractiveObjects.m_robberList[1])){
				// if other rubber is captured = game over
				if(InteractiveObjects.m_robberList[1].m_captured == true) return;
				
				m_immortal = true;
				m_captured = false;
				releaseDown();
				Session.effects.add(new Flicker(this,3000));
				var immortalTimer:Timer = Session.timer.add(new Timer(3000,backToNormal));
			}
		}
		
		/**
		 * reset player when a player have been rescued and is no longer immortal.  
		 * 
		 */		
		private function backToNormal():void {
			m_immortal = false;
			this.alpha = 0;
		}
		
		
		
		

	}
}