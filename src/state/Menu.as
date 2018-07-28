package state {
	
	/**
	 * flash imports 
	 */	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * graphic asset 
	 */	
	import asset.MenuAsset;
	
	/**
	 * local imports 
	 */	
	import utils.TextHeading;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	
	
	public class Menu extends DisplayStateLayerSprite {
		
		
		
		/**
		 * menu options 
		 */		
		private var menu_option_singleplayer:Boolean = true;		
		private var menu_option_multiplayer:Boolean = false;		
		
		/**
		 * menu background 
		 */		
		private var m_background:MovieClip;
		
		/**
		 * graphic underline for buttons 
		 */		
		private var m_underline:MovieClip;		
		
		/**
		 *	Background music  
		 */		
		[Embed(source = "../../asset/mp3/bg3_run.mp3")]
		private const SOUND_BACKGROUND_MENU:Class;
		private var m_soundBackgroundMenu:SoundObject;
		
		/**
		 * Menu option sound 
		 */		
		[Embed(source = "../../asset/mp3/menuClick2.mp3")]
		private const SOUND_MENU_CLICK:Class;
		public var m_soundMenuClick:SoundObject;
		
		public function Menu() { 
		} 
		
		/**
		 * init background, buttons and sound.
		 * 
		 */		
		override public function init():void { 
			
		
			
			init_background();				
			init_singleplayer_btn();			
			init_multiplayer_btn();			
			init_underline_btn(); 				
			m_initSounds();
			
		} 
		
		/**
		 * Game loop. Updates controls 
		 * 
		 */		
		override public function update():void { 	
			m_updateControls(); 				
		} 
		
		/**
		 * Init sounds
		 * Sound 1: Menu click sound
		 * Sound 2: background music
		 * 
		 */		
		private function m_initSounds():void {
			Session.sound.soundChannel.sources.add("click", SOUND_MENU_CLICK);
			m_soundMenuClick = Session.sound.soundChannel.get("click");
			Session.sound.musicChannel.sources.add("menuMusic", SOUND_BACKGROUND_MENU);
			m_soundBackgroundMenu = Session.sound.musicChannel.get("menuMusic");
			m_soundBackgroundMenu.play();
			m_soundBackgroundMenu.volume = 1;
			m_soundBackgroundMenu.continuousRestarting = true;
			m_soundBackgroundMenu.continuous = true;
		}
		
		
		/**
		 * init singplayer button 
		 * 
		 */		
		private function init_singleplayer_btn():void{			
			var heading:TextHeading = new TextHeading("Singleplayer","menu",0x000000);
			var field:TextField = heading.getField();
			field.y = 268;
			field.x = 200;
			addChild(field);
		} 
		
		/**
		 * init multiplayer button  
		 * 
		 */		
		private function init_multiplayer_btn():void{
			var heading:TextHeading = new TextHeading("Multiplayer","menu",0x000000);
			var field:TextField = heading.getField();
			field.y = 305;
			field.x = 200;
			addChild(field);
		} 
		
		/**
		 * loads background 
		 * 
		 */		
		private function init_background():void {
			m_background = new MenuAsset();
			m_background.gotoAndStop("MenuBackground");
			this.addChild(this.m_background);
			
		} 
		
		/**
		 * undeline for a button 
		 * 
		 */		
		private function init_underline_btn():void{
			m_underline = new MenuAsset();
			m_underline.gotoAndStop("Underline");
			m_underline.x = 315;
			m_underline.y = 288;
			m_underline.width = 160;
			m_underline.height = 10;
			this.addChild(this.m_underline);
		} 
		
		/**
		 * Update controls for menu options. 
		 * 
		 */		
		private function m_updateControls():void {	
			
			if (menu_option_singleplayer == true && Input.keyboard.justPressed("ONE")) start_singleplayer();
			if (menu_option_multiplayer  == true && Input.keyboard.justPressed("ONE")) start_multiplayer();
			
			if (Input.keyboard.justPressed("W")) { // fixa dubbletter
				if(menu_option_singleplayer == false){
					menu_option_singleplayer = true;
					menu_option_multiplayer = false;
					m_underline.y = 288;
					m_soundMenuClick.play();
					m_soundMenuClick.volume = 1;
				}
			}
			if (Input.keyboard.justPressed("S")) {
				if(menu_option_singleplayer == true){
					menu_option_singleplayer = false;
					menu_option_multiplayer = true;
					m_underline.y = 325;
					m_soundMenuClick.play();
					m_soundMenuClick.volume = 1;
				}
			}
		} 
		
		
		/**
		 *	Singleplayer choose, loads singleplayer instructions 
		 * 
		 */		
		private function start_singleplayer():void{	
			Session.application.displayState = new Instructions(1);
		} 
		
		/**
		 * Multiplayer choosen, loads multiplayer instructions. 
		 * 
		 */		
		private function start_multiplayer():void{
			Session.application.displayState = new Instructions(2);
		} 
		
		/**
		 * Dipose 
		 * 
		 */		
		override public function dispose():void { 
			m_background = null;
			m_underline = null;
		} 
	}
}