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
	import starling.events.EnterFrameEvent;
	import starling.core.Starling;
	import Eggs.Egg;
	import UI.HUD;
	import engine.SaveGame;
	
	import Combo.NoRottenCombo;
	
	public class Level6 extends LevelState
	{
		private var _megaChain:Number = 0;
		private var _winCondition:int;
		private var _loseCondition:int;
		private var _timeLimit:Number = 0;
		private var _neededChains:int;
		private var _intensity:Number = 1;
		
		public function Level6()
		{
			AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.LEVEL7, AssetRegistry.SCORING]);
      AssetRegistry.soundmanager.levelMusic();
			_levelNr = 6;
      SaveGame.levelName = AssetRegistry.Strings.LEVEL6NAME;
			_rottenEnabled = true;
			if (SaveGame.difficulty == 1)
			{
				_winCondition = 3;
				_loseCondition = 14;
				_neededChains = 20;
        _lid = "50422f31563d8a45d3002155";
			}
			else
			{
				_winCondition = 3;
				_loseCondition = 8;
				_neededChains = 20;
        _lid = "50422f39563d8a72bd00210c";
			}
			super();
			if (SaveGame.difficulty == 1)
			{
				_chainTime = 3.5;
				adjustBonusBack(38);
			}
			else
			{
				_chainTime = 2.5;
			}
			_comboSet.addCombo(new Combo.NoRottenCombo);
		}
		
		override protected function addBackground():void
		{
			_bgTexture = AssetRegistry.LevelAtlas.getTexture("level07");
			_bg = new Image(_bgTexture);
			_bg.blendMode = BlendMode.NONE;
			_bg.smoothing = TextureSmoothing.NONE;
			_levelStage.addChild(_bg);
		}
		
		override protected function eatEgg(egg:Egg):void
		{
			super.eatEgg(egg);
			if (_bonusTimerPoints == _neededChains)
			{
				_megaChain++;
			}
			_timeLimit = 0;
			_intensity = 1;
		}
		
		override protected function updateTimers(event:EnterFrameEvent):void
		{
			super.updateTimers(event);
			var passedTime:Number = event.passedTime * Starling.juggler.timeFactor;
			_timeLimit += passedTime;
		}
		
		override protected function addSpawnMap():void
		{
			_spawnMap = [88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 991, 992, 993, 994, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138, 1139, 1140, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1173, 1174, 1175, 1176, 1177, 1178, 1179, 1180, 1181, 1182, 1183, 1184, 1185, 1186, 1187, 1188, 1189, 1190, 1191, 1192, 1193, 1194, 1195, 1196, 1197, 1198, 1199, 1200, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223, 1224, 1225, 1226, 1227, 1228, 1229, 1230, 1231, 1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1240, 1241, 1242, 1243, 1249, 1250, 1251, 1252, 1253, 1254, 1255, 1256, 1257, 1258, 1259, 1260, 1261, 1262, 1263, 1264, 1265, 1266, 1267, 1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 1282, 1283, 1284, 1285, 1286];
		}
		
		override protected function showObjective():void
		{
			var _neededChains:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-megachain"));
			if (SaveGame.difficulty == 1)
			{
				showObjectiveBox(AssetRegistry.Strings.LEVEL6A, [[_neededChains, "x 2"]]);
			}
			else
			{
				showObjectiveBox(AssetRegistry.Strings.LEVEL6B, [[_neededChains, "x 3"]]);
			}
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
			if (int(_timeLimit) >= _loseCondition - 3)
			{
				_levelStage.x += Math.random() * _intensity - (_intensity / 2);
				_levelStage.y += Math.random() * _intensity - (_intensity / 2)
				_intensity += 0.1;
			}
			
			if (int(_timeLimit) >= _loseCondition)
			{
				die();
			}
			super.checkLost();
		}
		
		override protected function die():void
		{
			_timeLimit = 0;
			_intensity = 1;
			super.die();
		}
		
		override protected function checkWin():void
		{
			if (_megaChain >= _winCondition)
			{
				win();
			}
		}
		
		override protected function addHud():void
		{
			//_hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"], this);
			_hud = new HUD(this);
			var iconsCfg:Object = {lives: {type: "lives", pos: 1, watching: "lives"}, time: {type: "time", pos: 2, watching: "overallTime"}, poison: {type: "poison", pos: 4, watching: "poisonCount"}, chain: {type: "megachain", pos: 3, watching: "megaChain"}}
			
			_hud.iconsCfg = iconsCfg;
			addChild(_hud);
		
		}
		
		override protected function addObstacles():void
		{
			var pos:Array = [];
			for (var i:int = 0; i < pos.length; i++)
			{
				_obstacles[pos[i]] = true;
			}
		}
		
		public function get megaChain():Number
		{
			return _megaChain;
		}
		
		public function set megaChain(value:Number):void
		{
			_megaChain = value;
		}
	}

}
