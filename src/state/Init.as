	package state {

	/**
	 * flash imports 
	 */	
	import flash.utils.setTimeout;
	
	/**
	 * local game imports 
	 */	
	import highscore.HighscoreMenu;
	import state.Menu;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Init extends DisplayState {
		
		
		/**
		 *  layers 
		 */		
		private var m_introLayer:DisplayStateLayer;
		private var m_menuLayer:DisplayStateLayer;
		private var m_highscoreLayer:DisplayStateLayer;
		
		/**
		 * time for how long intro is playing 
		 */		
		private var m_introTime:int = 3300;
		
		/**
		 * intro reference
		 */		
		private var m_menu_intro:Intro; 
		
		/**
		 *  menu refrence
		 */		
		private var m_menu_graphic:Menu;
		
		/**
		 *  highscore reference
		 */		
		private var m_highScore:HighscoreMenu;
		
		/**
		 * view controllers
		 */		
		private var m_viewLayer:String;
		
		
		/**
		 * sets view 
		 * @param view
		 * 
		 */		
		public function Init(view:String = "") {
			super();
			m_viewLayer = view;
		}
		
		/**
		 * call view 
		 * 
		 */		
		override public function init():void {
			initView();	
		} 
	
		/**
		 * loads view 
		 * 
		 */		
		private function initView():void {
			if(m_viewLayer == "") init_intro();
			else if(m_viewLayer == "menu") init_menu();
		}
	
		/**
		 * load intro, removes intro after short time and loads menu.
		 * 
		 */		
		private function init_intro():void{	
			m_introLayer = this.layers.add("Intro");
			m_menu_intro = new Intro();
			m_introLayer.addChild(this.m_menu_intro);
			setTimeout(this.remove_intro,this.m_introTime);	
			setTimeout(this.init_menu,this.m_introTime);		
		} 
		
		
		/**
		 * Remove inro 
		 * 
		 */		
		private function remove_intro():void{	
			this.m_introLayer.removeChild(this.m_menu_intro);
		}
		
		/**
		 * load menu and highscore
		 * 
		 */		
		private function init_menu():void{
			trace("!!! menuGraphic !!!");
			m_menuLayer = this.layers.add("MenuGraphic");
			m_menu_graphic = new Menu();
			m_menuLayer.addChild(this.m_menu_graphic);
			m_highscoreLayer = this.layers.add("Highscore");
			m_highScore = new HighscoreMenu();
			m_highscoreLayer.addChild(m_highScore);
		} 
		
		/**
		 * Dispose 
		 * 
		 */		
		override public function dispose():void { 
			m_menu_intro = null;
			m_highScore = null;
			m_menu_graphic = null;
		} 
	}
}