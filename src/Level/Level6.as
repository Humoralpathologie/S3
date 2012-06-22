package Level 
{
	/**
     * ...
     * @author 
     */
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  import starling.textures.TextureSmoothing;
  import UI.HUD;
  import UI.Radar;
  
  public class Level6 extends LevelState 
  {
    public function Level6() 
    {
      AssetRegistry.loadLevel6Graphics();
      _levelNr = 6;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level6Atlas.getTexture("level06");
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }
 
    override protected function showObjective():void
    {     
      showObjectiveBox("Terror Triceratops has hidden 4 eggs especially well. Maybe they contain his heirs. Little Snake cannot afford to pass on these eggs.\n\nObjective:\nEat the 4 special eggs. If you have a problem getting into the tight spots, perform () to slow down time.", 40);
    }        
    
    override public function dispose():void {
      AssetRegistry.disposeLevel6Graphics();
      super.dispose();
    }
    
    override protected function addAboveSnake():void {
      var flowers:Image = new Image(AssetRegistry.Level6Atlas.getTexture("level06_flowers"));
      flowers.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(flowers);
    }
    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"]);
      addChild(_hud);
      
    }
    override protected function updateHud():void {
      super.updateHud();
      _hud.speedText = String(_snake.mps);
      _hud.poisonText = String(_poisonEggs);   
    }
     
    override protected function addObstacles():void {
      var pos:Array = [0, 1, 2, 3, 4, 1030, 519, 520, 513, 514, 515, 1031, 512, 19, 20, 21, 552, 553, 43, 44, 45, 46, 47, 1073, 562, 563, 1074, 62, 63, 64, 595, 596, 86, 87, 88, 89, 90, 1116, 605, 606, 1117, 105, 106, 107, 113, 114, 115, 1140, 1141, 636, 637, 638, 639, 129, 130, 131, 132, 133, 1159, 648, 649, 643, 644, 1160, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 1183, 1184, 1179, 1180, 679, 680, 681, 682, 171, 172, 173, 174, 175, 176, 1202, 691, 692, 686, 687, 1203, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 1226, 1227, 1222, 1223, 722, 214, 215, 216, 217, 218, 219, 1245, 734, 735, 729, 730, 1246, 1265, 1266, 1269, 1270, 257, 258, 259, 260, 261, 262, 1288, 777, 778, 772, 773, 1289, 1308, 1309, 1312, 1313, 1314, 1315, 1316, 1317, 1318, 1319, 1320, 1321, 1322, 1323, 1324, 301, 302, 303, 304, 305, 1330, 1331, 820, 821, 1326, 1327, 1328, 1329, 1332, 812, 1325, 814, 815, 816, 811, 1351, 1352, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 344, 345, 346, 347, 348, 1373, 1374, 863, 864, 1369, 1370, 1371, 1372, 341, 1375, 343, 1368, 858, 813, 342, 859, 300, 384, 385, 386, 387, 388, 389, 390, 391, 906, 907, 901, 902, 427, 428, 429, 430, 431, 432, 433, 434, 949, 950, 944, 945, 466, 467, 468, 469, 470, 471, 472, 987, 476, 477, 992, 993, 988, 509, 510, 511];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }
  }

}
