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
  import Eggs.Egg;
  import UI.HUD;
  import engine.SaveGame;
	import Snake.Snake;

  import Combo.NoRottenCombo;
  
  public class Level5 extends LevelState 
  {
		
    public function Level5() 
    {
      AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.LEVEL5, AssetRegistry.SCORING]);
      _levelNr = 5;
	  _rottenEnabled = true;
      super();
			SaveGame.startSpeed += 2;
			_snake.mps = SaveGame.startSpeed;
			_speed = 1 / SaveGame.startSpeed;
	  _comboSet.addCombo(new Combo.NoRottenCombo);
    }
	
		override protected function addSpawnMap():void
		{
      _spawnMap = [45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 677, 678, 679, 680, 681, 682, 683, 684, 685, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 720, 721, 722, 723, 724, 725, 726, 727, 728, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 763, 764, 765, 766, 767, 768, 769, 770, 771, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 806, 807, 808, 809, 810, 811, 812, 813, 814, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 849, 850, 851, 852, 853, 854, 855, 856, 857, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 994, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138, 1139, 1140, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1162, 1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1173, 1174, 1175, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1248, 1249, 1250, 1251, 1252, 1253, 1254, 1255, 1256, 1257, 1258, 1259, 1260, 1261, 1291, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1301, 1302, 1303, 1304];
    }
    
		override protected function addBackground():void
		{
      _bgTexture = AssetRegistry.LevelAtlas.getTexture("level05");
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }
    
		override public function dispose():void
		{
      super.dispose();
    }
	
		override public function spawnRandomEgg():void
		{
      var egg:Egg;
      var type:int;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGC, AssetRegistry.EGGZERO];
      type = types[Math.floor(Math.random() * types.length)];
      
      egg = _eggs.recycleEgg(0, 0, type);
      
      placeEgg(egg);
    }
	
		override protected function checkLost():void
		{
			if (_poisonEggs > 4)
			{
        lose();
      }
      super.checkLost();
    }
	
		override protected function checkWin():void
		{
			if (_overallTimer >= 4 * 60)
			{
        win();
      }
    }
    
    override protected function showObjective():void
    {    
	  var _neededTime:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-time"));
			if (SaveGame.difficulty == 1)
			{
		showObjectiveBox(AssetRegistry.Strings.LEVEL5A, [[_neededTime, "= 3:00"] ] );
			}
			else
			{
	    showObjectiveBox(AssetRegistry.Strings.LEVEL5B, [[_neededTime, "= 3:00"] ] );
	  }
    }      
    
    override protected function addHud():void {
     // _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"], this);
      _hud = new HUD(this);
      var iconsCfg:Object = {
        lives: { type: "lives", pos: 1, watching: "lives" },
        time: { type: "time", pos: 2, watching: "overallTime" },
        poison: { type: "poison", pos: 4, watching: "poisonCount"},
        speed: { type: "speed", pos: 3, watching: "speed"}
      }
      
      _hud.iconsCfg = iconsCfg;
      addChild(_hud);
      
    }
    
		override protected function addObstacles():void
		{
      var pos:Array = [516, 517, 518, 519, 1032, 1033, 1034, 559, 560, 561, 562, 1073, 1074, 602, 603, 604, 605, 1116, 1117, 626, 627, 628, 629, 630, 645, 646, 647, 648, 1159, 1160, 669, 670, 671, 672, 673, 172, 173, 688, 689, 690, 1203, 1202, 1221, 1222, 1223, 712, 713, 714, 715, 716, 717, 718, 1231, 1224, 1225, 1226, 1227, 1228, 1237, 1230, 1239, 216, 1233, 1242, 731, 732, 733, 1246, 215, 1240, 1232, 1234, 1235, 1245, 1238, 1229, 1241, 1243, 1244, 1236, 1264, 1265, 754, 755, 756, 757, 758, 759, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 258, 259, 260, 261, 774, 775, 776, 1289, 1282, 1283, 1284, 1285, 1286, 1287, 1288, 1270, 1271, 760, 1266, 1267, 1306, 1307, 1308, 1309, 798, 799, 800, 801, 802, 803, 1316, 1317, 1310, 1311, 1312, 1313, 1314, 1323, 1324, 301, 302, 303, 1328, 817, 818, 819, 1332, 1325, 1326, 1327, 1319, 1329, 1330, 1331, 1315, 1318, 1269, 1320, 1321, 1349, 1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 344, 345, 346, 1371, 860, 861, 862, 863, 1368, 1369, 1370, 1372, 1373, 1374, 1375, 1322, 1268, 387, 388, 389, 903, 904, 905, 906, 430, 431, 432, 946, 947, 948, 949, 473, 474, 475, 989, 990, 991];
			for (var i:int = 0; i < pos.length; i++)
			{
        _obstacles[pos[i]] = true;
      }
    }
  }

}
