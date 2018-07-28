
package retry
{
	
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;
	
	/**
	 * Graphic assets 
	 */	
	import asset.MenuAsset;
	
	/**
	 * local game imports
	 */	
	import state.Game;
	import state.Init;
	import utils.TextHeading;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class RetryScreen extends DisplayStateLayerSprite
	{
		
		/**
		 * retry background graphic
		 */		
		private var m_background:MenuAsset;
		
		/**
		 * textfields for retry options 
		 */		
		private var m_fieldRetry:TextField;
		private var m_fieldMenu:TextField;
		
		/**
		 *  underline for active option
		 */		
		private var m_underline:MenuAsset;
		private const RETRY_UNDERLINE:int = 300;
		private const MENU_UNDERLINE:int = 365;
		
		/**
		 * evetron controls 
		 */		
		private var m_controls:EvertronControls = new EvertronControls();
		
		/**
		 * control which option is active 
		 */		
		private var m_optionRetry:Boolean = true;
		
		
		
		
		/**
		 * menu click sound 
		 */		
		[Embed(source = "../../asset/mp3/menuClick2.mp3")]
		private const SOUND_MENU_CLICK:Class;
		public var m_soundMenuClick:SoundObject;
		
		/**
		 * retry type. 2 diffrent 1 for when player dies and one when a player got locked in. 
		 */		
		private var m_type:String;
		
		/**
		 * sets retry type 
		 * @param type
		 * 
		 */		
		public function RetryScreen(type:String)	{
			m_type = type;
		}
		
		/**
		 *	init retry 
		 * 
		 */		
		override public function init():void {
			m_controls.player = 0;
			initbackground();
			retryOptions();
			underlineBtn();
			m_initSounds();
		}
		
		/**
		 *  Game loop
		 *	update control 
		 * 
		 */		
		override public function update():void {
			updateControls()
		}
		
		/**
		 * init sounds.
		 * Sound 1: Menu click sound 
		 * 
		 */		
		private function m_initSounds():void {
			Session.sound.soundChannel.sources.add("click", SOUND_MENU_CLICK);
			m_soundMenuClick = Session.sound.soundChannel.get("click");	
		}
		
		/**
		 * check of active option 
		 * 
		 */		
		private function updateControls():void {
			activeOption();
			
			if (Input.keyboard.justPressed(m_controls.PLAYER_UP)) {
				m_optionRetry = true;
				m_underline.y = RETRY_UNDERLINE;
				m_soundMenuClick.play();	
			}
			if (Input.keyboard.justPressed(m_controls.PLAYER_DOWN)) {
				m_optionRetry = false;
				m_underline.y = MENU_UNDERLINE;
				m_soundMenuClick.play();
			}	
		} 
		
		/**
		 * choosen option, loads new game or go back to menu. 
		 * 
		 */		
		private function activeOption():void {
			if (m_optionRetry == true && Input.keyboard.justPressed("ONE")) Session.application.displayState = new Game(Game.m_gameMode);
			if (m_optionRetry  == false && Input.keyboard.justPressed("ONE")) Session.application.displayState = new Init("menu");
		}
		
		
		
		private function initbackground():void {
			m_background = new MenuAsset;
			m_background.gotoAndStop(m_type);
			m_background.x = 280;
			m_background.y = 140;
			this.addChild(m_background);
		}
		
		/**
		 * load retry options field and add to stage 
		 * 
		 */		
		private function retryOptions():void {
			
			var opt1:TextHeading = new TextHeading("Retry","menu",0x000000);
			var opt2:TextHeading = new TextHeading("Main menu","menu",0x000000);
			
			m_fieldRetry = opt1.getField();
			m_fieldMenu = opt2.getField();
			
			m_fieldRetry.y = 275;
			m_fieldRetry.x = 200;
			m_fieldMenu.y = 340;
			m_fieldMenu.x = 200;
			
			this.addChild(m_fieldRetry);
			this.addChild(m_fieldMenu);
			
		}
		
		/**
		 * underline button for choosen option 
		 * 
		 */		
		private function underlineBtn():void{
			m_underline = new MenuAsset();
			m_underline.gotoAndStop("Underline");
			m_underline.width = 160;
			m_underline.height = 10;
			m_underline.x = 400 - (m_underline.width /2);
			m_underline.y = RETRY_UNDERLINE;
			this.addChild(this.m_underline);
		} 
		
		/**
		 * dispose 
		 * 
		 */		
		override public function dispose():void {
			if(m_background.parent) m_background.parent.removeChild(m_background);
			
			
			clearProperties();	
		}
		
		/**
		 * clear properties 
		 * 
		 */		
		private function clearProperties():void {
			m_background = null;
			m_fieldRetry = null;
			m_fieldMenu = null;
			m_underline = null;
		}
	}
}