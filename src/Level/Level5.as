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
  
  public class Level5 extends LevelState 
  {
    public function Level5() 
    {
      AssetRegistry.loadLevel5Graphics();
      _levelNr = 5;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level5Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel5Graphics();
      super.dispose();
    }
     
    override protected function checkWin():void {
      if (_snake.eatenEggs == 50) {
        win();
      }
    }
    
    override protected function addObstacles():void {
      var pos:Array = [516, 517, 518, 519, 1032, 1033, 1034, 559, 560, 561, 562, 1073, 1074, 602, 603, 604, 605, 1116, 1117, 626, 627, 628, 629, 630, 645, 646, 647, 648, 1159, 1160, 669, 670, 671, 672, 673, 172, 173, 688, 689, 690, 1203, 1202, 1221, 1222, 1223, 712, 713, 714, 715, 716, 717, 718, 1231, 1224, 1225, 1226, 1227, 1228, 1237, 1230, 1239, 216, 1233, 1242, 731, 732, 733, 1246, 215, 1240, 1232, 1234, 1235, 1245, 1238, 1229, 1241, 1243, 1244, 1236, 1264, 1265, 754, 755, 756, 757, 758, 759, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 258, 259, 260, 261, 774, 775, 776, 1289, 1282, 1283, 1284, 1285, 1286, 1287, 1288, 1270, 1271, 760, 1266, 1267, 1306, 1307, 1308, 1309, 798, 799, 800, 801, 802, 803, 1316, 1317, 1310, 1311, 1312, 1313, 1314, 1323, 1324, 301, 302, 303, 1328, 817, 818, 819, 1332, 1325, 1326, 1327, 1319, 1329, 1330, 1331, 1315, 1318, 1269, 1320, 1321, 1349, 1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 344, 345, 346, 1371, 860, 861, 862, 863, 1368, 1369, 1370, 1372, 1373, 1374, 1375, 1322, 1268, 387, 388, 389, 903, 904, 905, 906, 430, 431, 432, 946, 947, 948, 949, 473, 474, 475, 989, 990, 991];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }
  }

}