package highscore
{
	/**
	 * flash imports 
	 */	
	import flash.text.TextField;
	
	/**
	 *  local game files
	 */	
	import utils.TextHeading;
	
	/**
	 * sdk imports 
	 */	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.util.URLUtils;
	
	
	/**
	 * This class load and print highscore for the menu
	 * @author Alexander Olsson
	 * 
	 */	
	public class HighscoreMenu extends DisplayStateLayerSprite
	{
		
		
		/**
		 *	List of highsore names in singleplayer 
		 */		
		private  var m_singlePlayerRowName		:Vector.<TextField> = new Vector.<TextField>();
		
		/**
		 * List of highscore in singleplayer 
		 */		
		private  var m_singlePlayerRowScore	:Vector.<TextField> = new Vector.<TextField>();
		
		/**
		 *	List of highscore names in multiplayer 
		 */		
		private  var m_multiPlayerRowName		:Vector.<TextField> = new Vector.<TextField>();
		
		/**
		 * List of highscore in multiplayer 
		 */		
		private  var m_multiPlayerRowScore		:Vector.<TextField> = new Vector.<TextField>();
		
		/**
		 * Position for highscore table in singleplayer
		 */		
		private const SINGLETABLE_X:int = 20;
		
		/**
		 * Max length of a name 
		 */		
		private const MAXIMUM_NAME_LENGTH:int = 15;
		
		/**
		 * Position for highscore table in multiplayer 
		 */		
		private const MULTITABLE_X:int = 550;
		
		
		
		
		public function HighscoreMenu()	{
			
		}
		
		/**
		 * init load highscore data 
		 * 
		 */		
		override public function init():void{
			loadData();
		} 
		
		/**
		 * get highscore data for multiplayer and singeplayer 
		 * 
		 */		
		public  function loadData():void {
			Session.highscore.receive(1,10,loadMultiPlayer);
			Session.highscore.receive(0,10,loadSinglePlayer);
		}
		
		/**
		 * Loop mutiplayer highscore data and push them in list
		 * @param data	-	highscore data
		 * 
		 */		
		private  function loadMultiPlayer(data:XML):void {
			
			for(var i:int = 0; i < data.items.item.position.length(); i++){
				var name:String = URLUtils.decode(data.items.item[i].name);
				if(name.length > MAXIMUM_NAME_LENGTH) name = name.substr(0,MAXIMUM_NAME_LENGTH) + "...";
				var rowName:TextHeading = new TextHeading(data.items.item[i].position+ ". " +name,"highscore",0x000000);
				var rowScore:TextHeading = new TextHeading(data.items.item[i].score,"highscore",0x000000);
				
				m_multiPlayerRowName.push(rowName.getField());
				m_multiPlayerRowScore.push(rowScore.getField());
				loadMultiPlayerRawScore(data.items.item[i].score)
			}
			printMultiTable();
		}
		
		/**
		 * Loop singleplayer highscore data and push them in list 
		 * @param data
		 * 
		 */		
		private function loadSinglePlayer(data:XML):void {
			
			for(var i:int = 0; i < data.items.item.position.length(); i++){
				var name:String = URLUtils.decode(data.items.item[i].name);
				if(name.length > MAXIMUM_NAME_LENGTH) name = name.substr(0,MAXIMUM_NAME_LENGTH) + "...";
				var rowName :TextHeading = new TextHeading(data.items.item[i].position+ ". " +name,"highscore",0x000000);
				var rowScore:TextHeading = new TextHeading(data.items.item[i].score,"highscore",0x000000);
				
				m_singlePlayerRowName.push(rowName.getField());
				m_singlePlayerRowScore.push(rowScore.getField());	
				loadSinglePlayerRawScore(data.items.item[i].score);
			}
			printSingleTable();	
		}
		
		/**
		 *	 push highscore data in global list
		 * @param score
		 * 
		 */		
		private function loadMultiPlayerRawScore(score):void {
			if(HighscoreList.m_multiPlayerRowScore.length > 9) return;
			HighscoreList.m_multiPlayerRowScore.push(score);
		}
		
		/**
		 *	 push highscore data in global list
		 * @param score
		 * 
		 */
		private function loadSinglePlayerRawScore(score):void {
			if(HighscoreList.m_singlePlayerRowScore.length > 9) return;
			HighscoreList.m_singlePlayerRowScore.push(score);
		}
		
		/**
		 * print singleplayer table to scene 
		 * 
		 */		
		private function printSingleTable():void {
			
			var rowStartY:int = 175;
			for (var i:int = 0; i < m_singlePlayerRowName.length; i ++){
				
				m_singlePlayerRowName[i].x = SINGLETABLE_X;
				m_singlePlayerRowName[i].y = rowStartY;
				
				m_singlePlayerRowScore[i].x = SINGLETABLE_X + 180;
				m_singlePlayerRowScore[i].y = rowStartY;
				rowStartY += 35;
				
				this.addChild(m_singlePlayerRowName[i]);
				this.addChild(m_singlePlayerRowScore[i]);
			}
		}
		
		/**
		 * print multiplayer table to scene 
		 * 
		 */		
		private function printMultiTable():void {
			
			var rowStartY:int = 175;
			for (var i:int = 0; i < m_multiPlayerRowName.length; i ++){
				
				m_multiPlayerRowName[i].x = MULTITABLE_X;
				m_multiPlayerRowName[i].y = rowStartY;
				
				m_multiPlayerRowScore[i].x = MULTITABLE_X + 180;
				m_multiPlayerRowScore[i].y = rowStartY;
				rowStartY += 35;
				
				this.addChild(m_multiPlayerRowName[i]);
				this.addChild(m_multiPlayerRowScore[i]);
			}
		}
		
		
		/**
		 * dispose data 
		 * 
		 */		
		override public function dispose():void {
			disposeList(m_singlePlayerRowName);
			disposeList(m_singlePlayerRowScore);
			disposeList(m_multiPlayerRowName);
			disposeList(m_multiPlayerRowScore);	
			
		}
		
		/**
		 * clear lists 
		 * @param list
		 * 
		 */		
		private function disposeList(list:Vector.<TextField>):void {
			for (var i:int = 0; i < list.length; i++) {
				list[i] = null;
				list.splice(0,1);
			}
			list.length = 0;
		}	
	}
}