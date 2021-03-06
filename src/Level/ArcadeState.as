package Level
{
  import com.gskinner.motion.GTween;
  import com.gskinner.motion.plugins.SoundTransformPlugin;
  import Eggs.Egg;
  import Eggs.Eggs;
  import flash.geom.Rectangle;
  import flash.media.Sound;
  import Snake.Snake;
  import starling.animation.Tween;
  import starling.core.Starling;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.extensions.ParticleDesignerPS;
  import starling.extensions.PDParticleSystem;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  import starling.events.EnterFrameEvent;
  import starling.events.TouchEvent;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import engine.AssetRegistry;
  import UI.HUD;
  import flash.system.Capabilities;
  import starling.display.BlendMode;
  import starling.text.TextField;
  import starling.utils.Color;
  import starling.utils.HAlign;
  import Combo.*;
  import flash.utils.*;
  import com.gskinner.motion.easing.Exponential
  import engine.SaveGame;
  import engine.StageManager;
  import Menu.LevelScore;
  import UI.Shake;
  
  /**
   * ...
   * @author
   */
  public class ArcadeState extends LevelState
  {
    //shake intensity
    private var _intensity:Number = 10;
    private var _volcanoSoundPlayed:Boolean = false;
    
    public function ArcadeState()
    {
      //AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.SCORING]);
      _rottenEnabled = true;
      
      var combos:Array = AssetRegistry.COMBO_TRIGGERS;
      
      SaveGame.difficulty = 2;
      SaveGame.isArcade = true;
      
      super();
      
      _comboSet.addCombo(new Combo.NoRottenCombo);
      //_comboSet.addCombo(new Combo.ExtraTimeCombo);
      //trace("ArcadeMode: " + String(SaveGame.arcadeModi));
      
      if (!SaveGame.endless)
      {
        _comboSet.addCombo(new Combo.SlowerCombo);
        _lid = "5041f594563d8a570c0024a4";
      }
      else
      {
        _comboSet.addCombo(new Combo.ExtraTimeCombo);
        _lid = "5041f5ac563d8a632f001f73";
      }
      
      for (var i:int = 0; i < 4; i++)
      {
        if (SaveGame.specials[i])
        {
          switch (SaveGame.specials[i].effect)
          {
            case "combo-xtraspawn":
              _comboSet.addCombo(new Combo.ExtraEggCombo(combos[i]));
              break;
            case "combo-leveluptime":
              _comboSet.addCombo(new Combo.ExtendExtraTimeCombo(combos[i]));
              break;
            case "combo-chaintime":
              _comboSet.addCombo(new Combo.ExtendChainTimeCombo(combos[i]));
              break;
            case "combo-shuffle":
              _comboSet.addCombo(new Combo.ShuffleCombo(combos[i]));
              break;
            case "combo-xtralife":
              _comboSet.addCombo(new Combo.ExtraLifeCombo(combos[i]));
              break;
            case "combo-gold":
              _comboSet.addCombo(new Combo.GoldenCombo(combos[i]));
              break;
          }
        }
      }
      
      _startPos.x = 20;
      _startPos.y = 20;
      startAt(_startPos.x, _startPos.y);
      AssetRegistry.soundmanager.playMusic("arcadeEndlessMusic", true);
      
      _levelNr = 9;
      unpause();
    
    }
    
    override protected function setBoundaries():void
    {
      _levelBoundaries = new Rectangle(13, 12, 43, 38);
    }
    
    override public function spawnRandomEgg():void
    {
      var egg:Eggs.Egg;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGB, AssetRegistry.EGGC, AssetRegistry.EGGA, AssetRegistry.EGGB, AssetRegistry.EGGC];
      
      var type:int = types[Math.floor(Math.random() * types.length)];
      
      egg = _eggs.recycleEgg(0, 0, type);
      
      placeEgg(egg);
    }
    
    override public function dispose():void
    {
      super.dispose();
      AssetRegistry.soundmanager.fadeOutSound();
    }
    
    override public function addFrame():void
    {
      // Not needed here.
    }
    
    override protected function addObstacles():void
    {
      var pos:Array = [1506, 1507, 3055, 3056, 3057, 1771, 3090, 3091, 1044, 1045, 3049, 1309, 3052, 3053, 3283, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 821, 822, 823, 824, 825, 3122, 3123, 820, 1333, 1334, 1335, 1071, 3120, 1308, 1770, 1836, 1069, 1070, 1572, 1573, 2892, 2893, 846, 847, 3115, 3116, 1837, 3156, 3157, 1110, 1111, 3054, 1374, 1375, 3118, 3119, 3121, 871, 872, 873, 874, 875, 876, 877, 878, 879, 1136, 881, 3186, 3187, 3188, 3181, 1135, 880, 1137, 3051, 3189, 3182, 3183, 1638, 1639, 3117, 3184, 3050, 2958, 2959, 912, 913, 3222, 3223, 1176, 1177, 1440, 1441, 3185, 937, 938, 939, 3247, 1202, 1203, 3252, 3253, 3254, 3255, 3248, 1201, 1705, 3251, 3249, 1704, 3277, 3278, 3279, 3024, 3025, 978, 979, 3284, 3285, 3286, 3287, 3288, 3289, 1242, 1243, 3280, 1003, 1004, 1005, 1267, 1268, 1269, 3281, 3282, 3250];
      for (var i:int = 0; i < pos.length; i++)
      {
        _obstacles[pos[i]] = true;
      }
    }
    
    override protected function addSpawnMap():void
    {
      _spawnMap = [2060, 2061, 2062, 2063, 2064, 2065, 2066, 2067, 2068, 2069, 2070, 2071, 2072, 2073, 2074, 2075, 2076, 2077, 2078, 2079, 2080, 2081, 2082, 2083, 2084, 2085, 2086, 2087, 2088, 2089, 2090, 2091, 2092, 2093, 2094, 2095, 2096, 2097, 2098, 2099, 2100, 2126, 2127, 2128, 2129, 2130, 2131, 2132, 2133, 2134, 2135, 2136, 2137, 2138, 2139, 2140, 2141, 2142, 2143, 2144, 2145, 2146, 2147, 2148, 2149, 2150, 2151, 2152, 2153, 2154, 2155, 2156, 2157, 2158, 2159, 2160, 2161, 2162, 2163, 2164, 2165, 2166, 2192, 2193, 2194, 2195, 2196, 2197, 2198, 2199, 2200, 2201, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2216, 2217, 2218, 2219, 2220, 2221, 2222, 2223, 2224, 2225, 2226, 2227, 2228, 2229, 2230, 2231, 2232, 2258, 2259, 2260, 2261, 2262, 2263, 2264, 2265, 2266, 2267, 2268, 2269, 2270, 2271, 2272, 2273, 2274, 2275, 2276, 2277, 2278, 2279, 2280, 2281, 2282, 2283, 2284, 2285, 2286, 2287, 2288, 2289, 2290, 2291, 2292, 2293, 2294, 2295, 2296, 2297, 2298, 2324, 2325, 2326, 2327, 2328, 2329, 2330, 2331, 2332, 2333, 2334, 2335, 2336, 2337, 2338, 2339, 2340, 2341, 2342, 2343, 2344, 2345, 2346, 2347, 2348, 2349, 2350, 2351, 2352, 2353, 2354, 2355, 2356, 2357, 2358, 2359, 2360, 2361, 2362, 2363, 2364, 2390, 2391, 2392, 2393, 2394, 2395, 2396, 2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406, 2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2416, 2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426, 2427, 2428, 2429, 2430, 2456, 2457, 2458, 2459, 2460, 2461, 2462, 2463, 2464, 2465, 2466, 2467, 2468, 2469, 2470, 2471, 2472, 2473, 2474, 2475, 2476, 2477, 2478, 2479, 2480, 2481, 2482, 2483, 2484, 2485, 2486, 2487, 2488, 2489, 2490, 2491, 2492, 2493, 2494, 2495, 2496, 2522, 2523, 2524, 2525, 2526, 2527, 2528, 2529, 2530, 2531, 2532, 2533, 2534, 2535, 2536, 2537, 2538, 2539, 2540, 2541, 2542, 2543, 2544, 2545, 2546, 2547, 2548, 2549, 2550, 2551, 2552, 2553, 2554, 2555, 2556, 2557, 2558, 2559, 2560, 2561, 2562, 2588, 2589, 2590, 2591, 2592, 2593, 2594, 2595, 2596, 2597, 2598, 2599, 2600, 2601, 2602, 2603, 2604, 2605, 2606, 2607, 2608, 2609, 2610, 2611, 2612, 2613, 2614, 2615, 2616, 2617, 2618, 2619, 2620, 2621, 2622, 2623, 2624, 2625, 2626, 2627, 2628, 2654, 2655, 2656, 2657, 2658, 2659, 2660, 2661, 2662, 2663, 2664, 2665, 2666, 2667, 2668, 2669, 2670, 2671, 2672, 2673, 2674, 2675, 2676, 2677, 2678, 2679, 2680, 2681, 2682, 2683, 2684, 2685, 2686, 2687, 2688, 2689, 2690, 2691, 2692, 2693, 2694, 2720, 2721, 2722, 2723, 2724, 2725, 2726, 2727, 2728, 2729, 2730, 2731, 2732, 2733, 2734, 2735, 2736, 2737, 2738, 2739, 2740, 2741, 2742, 2743, 2744, 2745, 2746, 2747, 2748, 2749, 2750, 2751, 2752, 2753, 2754, 2755, 2756, 2757, 2758, 2759, 2760, 2786, 2787, 2788, 2789, 2790, 2791, 2792, 2793, 2794, 2795, 2796, 2797, 2798, 2799, 2800, 2801, 2802, 2803, 2804, 2805, 2806, 2807, 2808, 2809, 2810, 2811, 2812, 2813, 2814, 2815, 2816, 2817, 2818, 2819, 2820, 2821, 2822, 2823, 2824, 2852, 2853, 2854, 2855, 2856, 2857, 2858, 2859, 2860, 2861, 2862, 2863, 2864, 2865, 2866, 2867, 2868, 2869, 2870, 2871, 2872, 2873, 2874, 2875, 2876, 2877, 2878, 2879, 2880, 2881, 2882, 2883, 2884, 2885, 2886, 2887, 2888, 2889, 2890, 2918, 2919, 2920, 2921, 2922, 2923, 2924, 2925, 2926, 2927, 2928, 2929, 2930, 2931, 2932, 2933, 2934, 2935, 2936, 2937, 2938, 2939, 893, 2942, 2943, 2944, 2945, 2946, 2947, 2948, 2949, 2950, 2951, 2952, 2953, 2954, 2955, 2956, 2940, 2941, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 2993, 2994, 2995, 2996, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 3019, 972, 973, 974, 975, 976, 2998, 3018, 971, 3020, 3021, 3022, 3014, 3015, 3016, 3017, 3008, 3009, 2999, 3000, 3001, 3002, 3003, 3004, 3005, 3006, 3007, 2997, 3010, 3011, 3012, 3013, 1007, 1008, 1009, 1010, 3059, 3060, 3061, 3062, 3063, 1016, 1017, 1018, 1011, 1012, 3069, 3070, 3071, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 3074, 3075, 3076, 3077, 3087, 3088, 3080, 3081, 3072, 3083, 3084, 3085, 3086, 3066, 3078, 3079, 1021, 1022, 3082, 1013, 1014, 1015, 3064, 3065, 1019, 1020, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 3149, 3150, 3151, 3152, 3153, 3154, 3146, 3147, 3148, 3139, 3140, 3141, 3142, 3143, 3144, 3145, 3135, 3136, 3125, 3126, 3127, 3128, 3129, 3130, 3131, 3132, 3133, 3134, 1139, 1140, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1158, 1159, 1160, 1161, 1162, 1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1173, 1174, 3206, 3207, 3202, 3203, 3204, 3205, 3195, 3196, 3208, 3209, 3200, 3201, 3191, 3192, 3193, 3194, 3137, 3138, 3197, 3198, 3199, 3068, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223, 1224, 1225, 1226, 1227, 1228, 1229, 1230, 1231, 1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1240, 3067, 1023, 3073, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 1282, 1283, 1284, 1285, 1286, 1287, 1288, 1289, 1290, 1291, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1301, 1302, 1303, 1304, 1305, 1306, 1337, 1338, 1339, 1340, 1341, 1342, 1343, 1344, 1345, 1346, 1347, 1348, 1349, 1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 1368, 1369, 1370, 1371, 1372, 1403, 1404, 1405, 1406, 1407, 1408, 1409, 1410, 1411, 1412, 1413, 1414, 1415, 1416, 1417, 1418, 1419, 1420, 1421, 1422, 1423, 1424, 1425, 1426, 1427, 1428, 1429, 1430, 1431, 1432, 1433, 1434, 1435, 1436, 1437, 1438, 1466, 1467, 1468, 1469, 1470, 1471, 1472, 1473, 1474, 1475, 1476, 1477, 1478, 1479, 1480, 1481, 1482, 1483, 1484, 1485, 1486, 1487, 1488, 1489, 1490, 1491, 1492, 1493, 1494, 1495, 1496, 1497, 1498, 1499, 1500, 1501, 1502, 1503, 1504, 1532, 1533, 1534, 1535, 1536, 1537, 1538, 1539, 1540, 1541, 1542, 1543, 1544, 1545, 1546, 1547, 1548, 1549, 1550, 1551, 1552, 1553, 1554, 1555, 1556, 1557, 1558, 1559, 1560, 1561, 1562, 1563, 1564, 1565, 1566, 1567, 1568, 1569, 1570, 1598, 1599, 1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1609, 1610, 1611, 1612, 1613, 1614, 1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623, 1624, 1625, 1626, 1627, 1628, 1629, 1630, 1631, 1632, 1633, 1634, 1635, 1636, 1664, 1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1674, 1675, 1676, 1677, 1678, 1679, 1680, 1681, 1682, 1683, 1684, 1685, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 1693, 1694, 1695, 1696, 1697, 1698, 1699, 1700, 1701, 1702, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1742, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 1753, 1754, 1755, 1756, 1757, 1758, 1759, 1760, 1761, 1762, 1763, 1764, 1765, 1766, 1767, 1768, 1796, 1797, 1798, 1799, 1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1810, 1811, 1812, 1813, 1814, 1815, 1816, 1817, 1818, 1819, 1820, 1821, 1822, 1823, 1824, 1825, 1826, 1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834, 1862, 1863, 1864, 1865, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 1885, 1886, 1887, 1888, 1889, 1890, 1891, 1892, 1893, 1894, 1895, 1896, 1897, 1898, 1899, 1900, 1928, 1929, 1930, 1931, 1932, 1933, 1934, 1935, 1936, 1937, 1938, 1939, 1940, 1941, 1942, 1943, 1944, 1945, 1946, 1947, 1948, 1949, 1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959, 1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034];
    }
    
    override protected function checkWin():void
    {
      if (_timeLeft <= 7 && SaveGame.endless)
      {
        if (!_volcanoSoundPlayed)
        {
          AssetRegistry.soundmanager.playSound("eruption");
          _volcanoSoundPlayed = true;
        }
        _levelStage.x += Math.random() * _intensity - (_intensity / 2);
        _levelStage.y += Math.random() * _intensity - (_intensity / 2)
        _intensity += 0.2;
      }
      if (_timeLeft <= 0 && SaveGame.endless)
      {
        win();
      }
    }
    
    override protected function lose():void
    {
      if (SaveGame.endless)
      {
        super.lose();
      }
      else
      {
        _lost = true;
        super.win();
      }
    }
    
    override protected function addHud():void
    {
      _hud = new HUD(this);
      
      var iconsCfg:Object = {lives: {type: "lives", pos: 1, watching: "lives"}, poison: {type: "poison", pos: 3, watching: "poisonCount"}};
      
      if (SaveGame.endless)
      {
        iconsCfg["time"] = {type: "time", pos: 2, watching: "timeLeftFormatted"};
      }
      else
      {
        iconsCfg["speed"] = {type: "speed", pos: 2, watching: "speed"};
      }
      
      _hud.iconsCfg = iconsCfg;
      addChild(_hud);
    
    }
    
    public function get timeLeftFormatted():String
    {
      return String(Math.max(0, _timeLeft).toFixed(2));
    }
    
    override protected function checkLost():void
    {
      if (_poisonEggs > 4)
      {
        lose();
      }
      super.checkLost();
    }
    
    override protected function addBackground():void
    {
      _bgTexture = AssetRegistry.Opaque_1_Part3_Atlas.getTexture("arcade");
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
    }
  
  }

}
