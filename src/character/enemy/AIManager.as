package character.enemy
{	
	/**
	 * flash imports 
	 */	
	import flash.display.DisplayObjectContainer;
	
	/**
	 *	 local game files
	 */	
	import interactive.InteractiveObjects;
	import map.Map;
	
	/**
	 *	sdk imports 
	 */	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	import se.lnu.stickossdk.util.MathUtils; 
	import se.lnu.stickossdk.media.SoundObject;
	
	
	/**
	 * This class controls both guards and sensors. This class can also be alot more optimized 
	 * @author alexanderolsson
	 * 
	 */	
	public class AIManager 
	{
		
		/**
		 *	refrence to guard 
		 */		
		private var m_guard:Guard;
		
		/**
		 * refrence to sensor 
		 */		
		private var m_sensor:Sensor;
		
		/**
		 * refrence to map 
		 */		
		private var m_map:Map = Map.sharedInstance();
		
		/**
		 * guard init timer 
		 */		
		private var m_spawnGuardTimer:Timer;
		
		/**
		 * array that control where sensors is placed 
		 */		
		private var m_sensorGrid:Array = [];
		
		/**
		 * time for next guard to enter stage
		 */		
		private var m_addEnemyOntime:int;
		
		/**
		 * guards height 
		 */		
		private const SKIN_GUARD_HEGIHT:int = 26;
		
		/**
		 * guards width 
		 */		
		private const SKIN_GUARD_WIDTH:int = 20;
		
		/**
		 *	if sensors is moving 
		 */		
		private var m_sensorsIsMoving:Boolean = false;
		
		/**
		 * alarm sound  
		 */		
		[Embed(source = "../../../asset/mp3/alarm1.mp3")]
		private static const SOUND_BANK_IS_ROBBED:Class;
		private var m_soundBankIsRobbed:SoundObject;
		
		/**
		 *	used to add sesnors and guard to stage 
		 */		
		protected var m_target:DisplayObjectContainer;
		
		/**
		 *	sensors list 
		 */		
		public var m_sensorList:Vector.<Sensor>;
		
		/**
		 * guard list 
		 */		
		public var m_guardList:Vector.<Guard>;
		
		
		/**
		 * 	Spawnpoints for guards.
		 * 
		 *  Index[] = Up,Down,Right,Left : Index[][] = xStart,xEnd,yStart,yEnd
		 */
		private var guardSpawnPoints:Array = [[180,760,0,180,1],[0,500,450,600,0],[600,800,86,280,3],[0,100,300,600,2]];
		
		
		
		/**
		 *	initSound, sensors and guards	
		 * @param target - Enemy gamelayer
		 * 
		 */		
		public function AIManager(target:DisplayObjectContainer){
			m_target = target;
			m_initSound();
			initSensorGrids();
			m_guardList = new Vector.<Guard>;
			m_addEnemyOnTime();
			//Session.timer.add(new Timer(6000,moveSensors,50));
		}
		
		/**
		 * init sounds
		 * 
		 * Sound 1: alarm for when bank is robbed 
		 * 
		 */		
		private function m_initSound():void {
			Session.sound.soundChannel.sources.add("Robbing_Bank", SOUND_BANK_IS_ROBBED);
			m_soundBankIsRobbed = Session.sound.soundChannel.get("Robbing_Bank");
			m_soundBankIsRobbed.volume = 0.5;
		}
		
		
		
		/**
		 * Adjust how often a guard should enter the map 
		 * 
		 */		
		private function m_addEnemyOnTime():void {
			if(m_guardList.length < 6)m_addEnemyOntime = 100;
			else if(m_guardList.length < 20) m_addEnemyOntime = 5000;
			else if(m_guardList.length < 30) m_addEnemyOntime = 10000;
			else if(m_guardList.length < 100) m_addEnemyOntime = 15000;
			m_spawnGuardTimer = Session.timer.add(new Timer(m_addEnemyOntime,spawnPointsGuard));	
		}
		
		/**
		 * init guards to stage. If sensors is moving a guard wont enter 
		 * @param xPos
		 * @param yPos
		 * @param dir
		 * 
		 */		
		private function addGuardToStage(xPos:int,yPos,dir):void {
			
			if(m_sensorsIsMoving == false) {
				var uglyTimer:Timer = Session.timer.add(new Timer(5000,function():void {m_sensorsIsMoving = false}));
				var range:int = MathUtils.randomRange(50,200) >> 0;
				m_guard = new Guard();
				m_guard.x = xPos;
				m_guard.y = yPos;
				m_guard.collisionCallback = guardCollision;
				m_guard.moveDirection(dir,range);
				m_guardList.push(m_guard);
				m_target.addChild(m_guard);
			}
			m_addEnemyOnTime();	
		}
		
		/**
		 *	 return randomized spawn position
		 * @return 
		 * 
		 */		
		private function spawnPoints():Array {
			return guardSpawnPoints[MathUtils.randomRange(0,3) >> 0];
		}
		
		/**
		 * add sensors in list near guards will spawn. Used later to compare sensors pos with guards pos.
		 * 
		 */		
		private function spawnPointsGuard():void {
			
			var points:Array = spawnPoints();
			var sensorInsidePoints:Array = [];
			for(var i:int = 0; i < m_sensorList.length; i++){
				if(m_sensorList[i].x >= points[0] && m_sensorList[i].x <= points[1] && m_sensorList[i].y >= points[2] &&  m_sensorList[i].y <= points[3]){
					sensorInsidePoints.push(m_sensorList[i]);	
				}
			}
			
			if(points[4] == 1 || points[4] == 0) spawnPointsTopDown(points,sensorInsidePoints);
			else if(points[4] == 2 || points[4] == 3) spawnPointsLeftRight(points,sensorInsidePoints)
		}
		
		
		/**
		 * Spawn points in y axes. 
		 * @param spawnPoint
		 * @return Array  -  index[0] = fixed point x or y,  index[1]&index[2] = randomize against [1] and [2]
		 * 
		 */
		private function spawnPointsTopDown(spawnPoint,sensorInsidePoints):void {
			
			var randomSpawnPoint1:int;
			var control:Boolean;
			var randomSpawnPoint2:int;
			if(spawnPoint[4] == 0) randomSpawnPoint2 = spawnPoint[3];
			if(spawnPoint[4] == 1) randomSpawnPoint2 = spawnPoint[2];
			
			randomSpawnPoint1 = MathUtils.randomRange(spawnPoint[0],spawnPoint[1]) >> 0;
			
			control = spawnOnXdirection(randomSpawnPoint1,sensorInsidePoints)
			if(control == false) {
				do { 
					randomSpawnPoint1 = MathUtils.randomRange(spawnPoint[0],spawnPoint[1]) >> 0;
					control = spawnOnXdirection(randomSpawnPoint1,sensorInsidePoints);
				} while (control == false);	
			} // NY POS FÄRDIG
			addGuardToStage(randomSpawnPoint1,randomSpawnPoint2,spawnPoint[4]);	
		}
		
		/**
		 *	Spawn points in x axes
		 * @param spawnPoint
		 * @param sensorInsidePoints
		 * 
		 */		
		private function spawnPointsLeftRight(spawnPoint,sensorInsidePoints):void {
			
			var randomSpawnPoint1:int;
			var control:Boolean;
			var randomSpawnPoint2:int;
			
			if(spawnPoint[4] == 2) randomSpawnPoint1 = spawnPoint[0];
			if(spawnPoint[4] == 3) randomSpawnPoint1 = spawnPoint[1];
			
			randomSpawnPoint2 = MathUtils.randomRange(spawnPoint[2],spawnPoint[3]) >> 0;
			control = spawnOnYdirection(randomSpawnPoint2,sensorInsidePoints);
			if(control == false) {
				do { 
					randomSpawnPoint2 = MathUtils.randomRange(spawnPoint[2],spawnPoint[3]) >> 0;
					control = spawnOnYdirection(randomSpawnPoint2,sensorInsidePoints);
				} while (control == false);	
			} // NY POS FÄRDIG	
			addGuardToStage(randomSpawnPoint1,randomSpawnPoint2,spawnPoint[4]);
		}
		
		/**
		 * Returns true if the spawnpoints is between sensors 
		 * @param spawnPoint
		 * @param sensorInsidePoints
		 * @return 
		 * 
		 */		
		private function spawnOnXdirection(spawnPoint,sensorInsidePoints):Boolean {
			//trace(sensorInsidePoints[2].m_skin_width);
			var offset:int = 3;
			
			for(var i:int = 0; i < sensorInsidePoints.length; i++){
				if(spawnPoint < sensorInsidePoints[i].x && spawnPoint+ SKIN_GUARD_WIDTH >= sensorInsidePoints[i].x ||
					spawnPoint  >= sensorInsidePoints[i].x && spawnPoint <= sensorInsidePoints[i].x + sensorInsidePoints[i].m_skin_width ||
					spawnPoint >= sensorInsidePoints[i].x && spawnPoint+ SKIN_GUARD_WIDTH <= sensorInsidePoints[i].x + sensorInsidePoints[i].m_skin_width){
					return false
				} 
			}
			return true;
		}
		
		
		/**
		 * Returns true if the spawnpoints is between sensors 
		 * @param spawnPoint
		 * @param sensorInsidePoints
		 * @return 
		 * 
		 */	
		private function spawnOnYdirection(spawnPoint,sensorInsidePoints):Boolean {
			var offset:int = 3;
			for(var i:int = 0; i < sensorInsidePoints.length; i++){
				if(spawnPoint < sensorInsidePoints[i].y && spawnPoint+ SKIN_GUARD_HEGIHT >= sensorInsidePoints[i].y ||
					spawnPoint > sensorInsidePoints[i].y && spawnPoint < sensorInsidePoints[i].y + sensorInsidePoints[i].m_skin_height ||
					spawnPoint >= sensorInsidePoints[i].y && spawnPoint + SKIN_GUARD_HEGIHT <= sensorInsidePoints[i].y + sensorInsidePoints[i].m_skin_height){
					return false
				} 
			}
			return true;
		}

		private function initSensorGrids():void {
			m_sensorList = new Vector.<Sensor>;
			var newPos:Array = shuffleNewPosForSensors();
			var gridtileWidth:int = m_map.MAP_WIDTH / 6 >>0;
			var gridtileHeight:int = m_map.MAP_HEIGHT / 4 >>0;
			var sensorHeight:int = 37;
			for(var i:int = 0; i <4; i++){
				for(var j:int = 0; j < 5; j++){
					if((i != 0 || j != 0) && (i != 1 || j != 0) && (i != 2 || j != 4) && (i != 3 || j != 4)){
						
						m_sensor = new Sensor();
						m_sensor.collisionCallback = sensorCollision;
						var xStart:int = gridtileWidth * j + (m_sensor.m_skin_width * 1.5);
						var xEnd:int = (gridtileWidth * j) + (gridtileWidth - m_sensor.m_skin_width);
						var yStart:int = (gridtileHeight * i) + m_map.MAP_START;
						var yEnd:int = (gridtileHeight * i) + m_map.MAP_START + (gridtileHeight - m_sensor.m_skin_height);
						var gridTile:Array = [xStart,xEnd,yStart,yEnd];
						m_sensor.x = xEnd >> 0;
						m_sensor.y = yStart >> 0;	
						
						m_target.addChild(m_sensor);
						m_sensorList.push(m_sensor);
						m_sensorGrid.push(gridTile);
					}
				}
			}
		}
		
		/**
		 *	 Give sensors a new postion.
		 * 
		 */		
		private function initPosForSensor():void {
			var newPos:Array = shuffleNewPosForSensors();
			for(var i:int = 0; i < m_sensorGrid.length; i++){
				m_sensorList[i].x = newPos[i][0];
				m_sensorList[i].y = newPos[i][1];
			}
		}
		
		/**
		 * Sensors collistion 
		 * If a sensors is collided with players the it will notigy guards to hunt
		 * This collision is not in the Sensors class because it's need access to  notifyGuardsToHunt method.
		 * @param that
		 * 
		 */				
		public function sensorCollision(that):void{
			
			for(var i:int = 0; i < InteractiveObjects.m_robberList.length; i++){
				if(that.hitTestPoint(InteractiveObjects.m_robberList[i].m_testAgainstX, InteractiveObjects.m_robberList[i].m_testAgainstY) ||
					that.hitTestPoint(InteractiveObjects.m_robberList[i].m_testAgainstX, InteractiveObjects.m_robberList[i].m_testAgainstY+ InteractiveObjects.m_robberList[i].m_objectHitBox.height) ||
					that.hitTestPoint(InteractiveObjects.m_robberList[i].m_testAgainstX +InteractiveObjects.m_robberList[i].m_skin_width, InteractiveObjects.m_robberList[i].m_testAgainstY+ InteractiveObjects.m_robberList[i].m_objectHitBox.height) ||
					that.hitTestPoint(InteractiveObjects.m_robberList[i].m_testAgainstX +InteractiveObjects.m_robberList[i].m_skin_width, InteractiveObjects.m_robberList[i].m_testAgainstY)
				){
					if(InteractiveObjects.m_robberList[i].m_captured) return;
					that.onEnemyHitAlarm();
					notifyGuardsToHunt(that.areaEffected(InteractiveObjects.m_robberList[i]),InteractiveObjects.m_robberList[i]);
				}	
			}
		}
		
		/**
		 *	Move the sensors to new postion. When sensors is moving the alarm is playing. 
		 * 
		 */		
		public function moveSensors():void{
			
			m_sensorsIsMoving = true;
			var m_sensorMove:Timer = Session.timer.add(new Timer(8000, function():void {m_sensorsIsMoving = false}));
			var newPos:Array = shuffleNewPosForSensors();
			
			m_sensorList.sort(randomize);
			for(var i:int = 0; i < m_sensorGrid.length; i++){
	
				m_sensorList[i].m_moveToNewPosX = true;
				m_sensorList[i].m_changeDirectionY = true;
				m_sensorList[i].m_moveToNewPosY = true;
				m_sensorList[i].m_changeDirectionX = true;
				m_sensorList[i].m_newPointX = newPos[i][0];
				m_sensorList[i].m_newPointY = newPos[i][1];
				m_sensorList[i].onMoveAlarm();
			}
			m_soundBankIsRobbed.play();
		}
		
		/**
		 * Randomize new position for sensors 
		 * @return 
		 * 
		 */		
		private function shuffleNewPosForSensors():Array {
			var newPos:Array = [];
			for(var i:int = 0; i < m_sensorGrid.length; i++){
				var cords:Array = [];
				cords[0] = MathUtils.randomRange(m_sensorGrid[i][0],m_sensorGrid[i][1]);
				cords[1] = MathUtils.randomRange(m_sensorGrid[i][2],m_sensorGrid[i][3]);	
				newPos.push(cords);
			}
			return newPos;
		}
		
		/**
		 *	return a random number 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function randomize ( a : *, b : * ) : int {
			return ( Math.random() > .5 ) ? 1 : -1;
		}
		
		
		/**
		 * Notify guards to hunt player. Only guard inside the affected area will be notified 
		 * @param inArea
		 * @param huntObject
		 * 
		 */		
		public function notifyGuardsToHunt(inArea:Array,huntObject:Object):void{
			for(var i:int =0; i < this.m_guardList.length; i++ ){
				if(this.m_guardList[i].m_walkingRandom == true){
					if(m_guardList[i].x > inArea[0] && m_guardList[i].y > inArea[1] && m_guardList[i].x < inArea[2] && m_guardList[i].y < inArea[3] ){
						m_guardList[i].startHunting(huntObject);
					}
				}
			}
		}
		
		/**
		 *	Guard collison, can be more optimized.
		 * 	
		 * 	
		 * @param that
		 * 
		 */		
		public function guardCollision(that):void{
			
			for(var i:int = 0; i < m_sensorList.length; i++){
				if(that.m_objectHitBox.hitTestObject(m_sensorList[i])){
					that.colideSolid();
					if(that.m_walkingRandom == false && that.stopCollisionCheck == 0){
						that.stopCollisionCheck = 2;
						that.turnedOn = "right left down up";
						that.huntingWalkDistance = 15;
						if(that.m_lastDirection == "up"|| that.m_lastDirection == "down" ){
							if(that.x < that.m_huntObject.x){
								that.huntDirectionWalk2 = "right";
								that.turnedOn = "right";
							} else {
								that.huntDirectionWalk2 = "left";
								that.turnedOn = "left";
							}
						} 
						else if(that.m_lastDirection == "right" || that.m_lastDirection == "left"){
							if(that.y < that.m_huntObject.y){
								that.huntDirectionWalk2 = "down";
								that.turnedOn = "down";
							} else {
								that.huntDirectionWalk2 = "up";
								that.turnedOn = "up";
							}
						}
						that.huntingWalk = true;
					}  else if(that.m_walkingRandom == true && m_sensorsIsMoving == false){
						that.randomWalk();
					}	
				}
			}
			if(that.hitTestObject(m_map.m_mapSafePlaces[0]))that.colideSolid();
			if(that.hitTestObject(m_map.m_mapSafePlaces[1]))that.colideSolid();
		}
		
		
		
		
		
		
		
		/**
		 * Dipose memory 
		 * 
		 */		
		public function dispose():void {
			clearInstance(m_guardList);
			clearInstance(m_sensorList);
			clearGrid();
			clearProperties();
		}
		
		/**
		 * clear class instances  
		 * @param list
		 * 
		 */		
		private function clearInstance(list):void {
			for (var i:int = 0; i < list.length; i++) {
				list[i].dispose();
				if(list[i].parent){
					list[i].parent.removeChild(list[i]);
				}
				list[i] = null;
				
			}
			list.length = 0;
		}
		
		/**
		 * clear list 
		 * 
		 */		
		private function clearGrid():void {
			for (var i:int = 0; i < m_sensorGrid.length; i++) {
				m_sensorGrid[i] = null;
				m_sensorGrid.splice(0,1);
				
			}
			m_sensorGrid.length = 0;
		}
		
		/**
		 * clear porperties 
		 * 
		 */		
		private function clearProperties():void {
			m_spawnGuardTimer = null;
			m_target = null;
		}
		
		
		
		/*
		END CLEAR MEMORY
		*/
		
		
	}
}
/**
 * 
 */