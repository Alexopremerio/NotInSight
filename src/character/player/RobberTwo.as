package character.player
{	
	/**
	 * player2 graphic 
	 */	
	import asset.player2;
	
	/**
	 * local game  
	 */	
	import hud.PlayerBagScore;
	import interactive.InteractiveObjects;
	import state.Game;
	
	/**
	 *	sdk imports 
	 */	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	

	public class RobberTwo extends Player
	{
		
		/**
		 * Constructor Player one 
		 *  passing playerskin, coinskin and controls to parent. Setting players start position
		 */		
		public function RobberTwo()
		{	super(player2,"mp_p2_coin", EvertronControls.PLAYER_TWO);
			
			this.x = 20;
			this.y = 80;
			
		}
		
		/**
		 * Creates new money bag for player.
		 * 
		 */	
		override public function init():void{
			super.init();
			m_playerBagScore = new PlayerBagScore("P2:",0x029542);
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
		 * MultiplayerMode if player is captured
		 * 
		 */
		private function capturedControl():void {
			if(Game.m_gameMode == 2){
				if(this.m_captured == true && this.m_canBeRescued == true && this.m_immortal == false) rescueCollison();	
			}
		}
		
		/**
		 * If other player is immortal you cant be rescued
		 * 
		 */
		private function rescueCollison():void {
			if(InteractiveObjects.m_robberList[0].m_immortal == true) return;
			
			this.alpha = 1;
			if(this.hitTestObject(InteractiveObjects.m_robberList[0])){
				if(InteractiveObjects.m_robberList[0].m_captured == true) return;
				m_immortal = true;
				m_captured = false;
				releaseDown();
				Session.effects.add(new Flicker(this,3000));
				var immortalTimer:Timer = Session.timer.add(new Timer(3000,backToNormal));
			}
		}
		
		/**
		 * 
		 * 
		 */
		private function backToNormal():void {
			m_immortal = false;
			this.alpha = 0;
		}
	}
}