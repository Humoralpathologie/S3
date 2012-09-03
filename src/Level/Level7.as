package Level
{
	/**
	 * ...
	 * @author
	 */
  import Eggs.Eggs;
	import engine.AssetRegistry
	import starling.display.Image;
	import starling.display.BlendMode;
	import starling.textures.TextureSmoothing;
	import starling.events.EnterFrameEvent;
	import starling.core.Starling;
	import Eggs.Egg;
	import UI.HUD;
	import engine.SaveGame;
  import starling.utils.Color;
  import starling.extensions.PDParticleSystem;
  import engine.VideoPlayer;
  import Menu.LevelScore;
  import starling.events.TouchEvent;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import engine.ManagedStage;
	
	import Combo.NoRottenCombo;
	
	public class Level7 extends LevelState
	{
    private var _goldenEggsRest:int = 4;
    private var _goldenEggs:Eggs = new Eggs();
    private var _goldenEggPos:Array = [];
		
		public function Level7()
		{
			AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.LEVEL7, AssetRegistry.SCORING]);
      AssetRegistry.soundmanager.levelMusic();
			_levelNr = 7;
      SaveGame.levelName = AssetRegistry.Strings.LEVEL7NAME;
			_rottenEnabled = true;
      /*
			if (SaveGame.difficulty == 1)
			{
				_winCondition = 2;
				_loseCondition = 14;
				_neededChains = 12;
			}
			else
			{
				_winCondition = 3;
				_loseCondition = 8;
				_neededChains = 20;
			} */
			super();
      if (SaveGame.difficulty == 1){
        _snake.lives = 2;
        _lid = "50422f41563d8a570c00263c";
      } else {
        _snake.lives = 1;
        _lid = "50422f4a563d8a45d300215a";
      }
      gameJuggler.add(_goldenEggs);
      _levelStage.addChild(_goldenEggs);
			_comboSet.addCombo(new Combo.NoRottenCombo);
      spawnGolden();
		}
		
		override protected function addBackground():void
		{
			_bgTexture = AssetRegistry.LevelAtlas.getTexture("level08");
			_bg = new Image(_bgTexture);
			_bg.blendMode = BlendMode.NONE;
			_bg.smoothing = TextureSmoothing.NONE;
			_levelStage.addChild(_bg);
		}
		
		override protected function eatEgg(egg:Egg):void
		{
      if (egg.type == AssetRegistry.EGGGOLDEN) {
        var particle:PDParticleSystem;
        AssetRegistry.soundmanager.playSound("bite1");
        particle = _particles[egg.type];
        if (particle)
        {
          particle.x = egg.x + 10;
          particle.y = egg.y + 13;
          particle.start(0.5);
        }
        _goldenEggs.removeEgg(egg);
        var points:int = 2;
        showPoints(egg, String(points));
        if (_bonusTimer > 0)
        {
          var randColor:uint = Color.argb(255, Math.floor(Math.random() * 100) + 155, Math.floor(Math.random() * 255), Math.floor(Math.random() * 256));
          _bonusTimerPoints += 2;
          showPoints(egg, "+" + String(_bonusTimerPoints), 20, randColor);
          _score += _bonusTimerPoints;
        }
        _score += points;
        _bonusTimer = _chainTime;
        AssetRegistry.soundmanager.level = Math.floor(_snake.eatenEggs / 10);

      } else {
			  super.eatEgg(egg);
      }
			
		}
		
		override protected function updateTimers(event:EnterFrameEvent):void
		{
			super.updateTimers(event);
      updateGolden(event);
		}
		
		override protected function addSpawnMap():void
		{
			_spawnMap = [86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 170, 171, 172, 173, 174, 175, 176, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 212, 213, 214, 215, 216, 217, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 254, 255, 256, 257, 258, 259, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 296, 297, 298, 299, 300, 301, 302, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 408, 409, 410, 411, 412, 413, 414, 415, 416, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 451, 452, 453, 454, 455, 456, 457, 458, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 493, 494, 495, 496, 497, 498, 499, 500, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 535, 536, 537, 538, 539, 540, 541, 542, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 578, 579, 580, 581, 582, 583, 584, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 920, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 962, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 1004, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1046, 1052, 1053, 1054, 1055, 1056, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1088, 1094, 1095, 1096, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1130, 1136, 1137, 1138, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1158, 1159, 1160, 1161, 1162, 1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1178, 1179, 1180, 1190, 1191, 1192, 1193, 1194, 1195, 1196, 1197, 1198, 1199, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213, 1214];
		}
		
		override protected function showObjective():void
		{
			var _golden:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-golden"));
			if (SaveGame.difficulty == 1)
			{
				showObjectiveBox(AssetRegistry.Strings.LEVEL7A, [[_golden, "= 0"]]);
			}
			else
			{
				showObjectiveBox(AssetRegistry.Strings.LEVEL7B, [[_golden, "= 0"]]);
			}
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
		
		override protected function die():void
		{
			super.die();
		}
		
		override protected function checkWin():void
		{
      if (_goldenEggsRest == 0) {
        SaveGame.hasFinishedGame = true;
        win();
      }
		}
		
		override protected function addHud():void
		{
			//_hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"], this);
			_hud = new HUD(this);
			var iconsCfg:Object = {lives: {type: "lives", pos: 1, watching: "lives"}, time: {type: "time", pos: 2, watching: "overallTime"}, speed: {type: "speed", pos: 3, watching: "speed"}, poison: {type: "poison", pos: 4, watching: "poisonCount"}}
			
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
		
    private function spawnGolden():void
    {
      var goldenEggPos:Array = [[12, 5], [27, 11], [10, 26], [35, 23]];
      for (var i:int = 0; i < goldenEggPos.length; i++ ) {
        var goldenEgg:Eggs.Egg = _goldenEggs.recycleEgg(0, 0, AssetRegistry.EGGGOLDEN);
        goldenEgg.tileX = goldenEggPos[i][0];
        goldenEgg.tileY = goldenEggPos[i][1];
      }
    }
    override protected function eggCollide():void
    {
      super.eggCollide();
      var egg:Eggs.Egg;
      egg = _goldenEggs.overlapEgg(_snake.head);
      if (egg) {
        _goldenEggsRest--;
        eatEgg(egg);
        _goldenEggPos.push([3, egg.tileX, egg.tileY]);
      }
    }
    
    override protected function winScreenTouch(event:TouchEvent):void
    {
      var touch:Touch;
      touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch)
      {
        var score:Object = {score: _score, lives: _snake.lives, time: _overallTimer, level: _levelNr, snake: _snake, lid: _lid}
        AssetRegistry.soundmanager.fadeOutMusic();
        dispatchEventWith(ManagedStage.SWITCHING, true, { stage: VideoPlayer, args: {stage:LevelScore, videoURI:"Outro.mp4", args:score} } );
        SaveGame.hasFinishedGame = true;
      }
    }
    
    private function updateGolden(event:EnterFrameEvent):void
    {
      var passedTime:Number = event.passedTime * gameJuggler.timeFactor;
      for (var i:int; i < _goldenEggPos.length; i++) {
        _goldenEggPos[i][0] -= passedTime;
        if (_goldenEggPos[i][0] <= 0 && !(_snake.hit(_goldenEggPos[i][1], _goldenEggPos[i][2]))) {
           var golden:Eggs.Egg = _goldenEggs.recycleEgg(0, 0, AssetRegistry.EGGGOLDEN);
           golden.tileX = _goldenEggPos[i][1];
           golden.tileY = _goldenEggPos[i][2];
           _goldenEggPos.splice(i, 1);
           _goldenEggsRest++;
        }
      }
    }
    
    override public function dispose():void
    {
      super.dispose();
      _goldenEggs.dispose();
    }
    
	}

}
