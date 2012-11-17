package engine
{
  import flash.media.Sound;
  import flash.utils.ByteArray;
  import starling.text.BitmapFont;
  import starling.textures.Texture;
  import starling.textures.TextureAtlas;
  import starling.text.TextField;
  import Level.*;
  import engine.SoundManager;
  import flash.system.System;
  import Languages.*;
  
  /**
   * ...
   * @author
   */
  public class AssetRegistry
  {
    
    // UI Graphics
    [Embed(source = "../../assets/UI/UI.png")]
    static private const UIAtlasPNG:Class;
    [Embed(source = "../../assets/UI/UI.xml", mimeType = "application/octet-stream")]
    static private const UIAtlasXML:Class;
    public static var UIAtlas:TextureAtlas;
    
    [Embed(source="../../assets/Font/8bit.fnt",mimeType="application/octet-stream")]
    static private const FontXML:Class;
    [Embed(source="../../assets/Font/8bit_0.png")]
    static private const FontPNG:Class;
    
    
    [Embed(source="../../assets/Loading/loading-screen.png")]
    static public const LoadingPNG:Class;

    [Embed(source="../../assets/Loading/loading-screen.png")]
    static public const LoadingScreenPNG:Class;

    
    [Embed(source="../../assets/Sounds/Biss1.mp3")]
    static public const Bite1:Class;
    [Embed(source="../../assets/Sounds/Biss2.mp3")]
    static public const Bite2:Class;
    [Embed(source="../../assets/Sounds/Biss3.mp3")]
    static public const Bite3:Class;
    
    [Embed(source="../../assets/Music/LevelMusikStufe1.mp3")]
    static private const LevelMusic1:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe2.mp3")]
    static private const LevelMusic2:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe3.mp3")]
    static private const LevelMusic3:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe4.mp3")]
    static private const LevelMusic4:Class;    
    [Embed(source="../../assets/Music/eile_arcade1.mp3")]
    static public const ArcadeMusic:Class;
    [Embed(source = "../../assets/Music/snake_remix.mp3")]
    static public const ArcadeEndlessMusic:Class;
   
    // Sounds
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt1.mp3")]
    static private const ComboSound0:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt2.mp3")]
    static private const ComboSound1:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt3.mp3")]
    static private const ComboSound2:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt4.mp3")]
    static private const ComboSound3:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt5.mp3")]
    static private const ComboSound4:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt6.mp3")]
    static private const ComboSound5:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt7.mp3")]
    static private const ComboSound6:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt8.mp3")]
    static private const ComboSound7:Class;
    
    [Embed(source = "../../assets/Sounds/RottenEgg.mp3")]
    static private const RottenEggSound:Class;
    [Embed(source = "../../assets/Sounds/GoldenEgg.mp3")]
    static private const GoldenEggSound:Class;
    [Embed(source = "../../assets/Sounds/ShuffleEgg_01.mp3")]
    static private const ShuffleEggSound:Class;
    
    [Embed(source = "../../assets/Sounds/Todesgeraeusch.mp3")]
    static private const DieSound:Class;
    [Embed(source = "../../assets/Sounds/GameOver.mp3")]
    static private const GameOverSound:Class;
    [Embed(source = "../../assets/Sounds/CarnageComplete.mp3")]
    static private const WinSound:Class;
    
    [Embed(source = "../../assets/Sounds/MedailleSwoosh1.mp3")]
    static private const MedalSound1:Class;
    [Embed(source = "../../assets/Sounds/MedailleSwoosh2Punch.mp3")]
    static private const MedalSound2:Class;
    
    [Embed(source = "../../assets/Sounds/Eruption.mp3")]
    static private const Eruption:Class;
    [Embed(source = "../../assets/Sounds/Explosion.mp3")]
    static private const Explosion:Class;
    
    [Embed(source = "../../assets/Sounds/PointsPling.mp3")]
    static private const PointsPling:Class;
    [Embed(source = "../../assets/Sounds/PointsPling2.mp3")]
    static private const PointsPling2:Class;
    
    // Particles
    [Embed(source="../../assets/Particles/EggsplosionA.pex",mimeType="application/octet-stream")]
    static public const EggsplosionA:Class;
    [Embed(source="../../assets/Particles/EggsplosionB.pex",mimeType="application/octet-stream")]
    static public const EggsplosionB:Class;
    [Embed(source="../../assets/Particles/EggsplosionC.pex",mimeType="application/octet-stream")]
    static public const EggsplosionC:Class;
    [Embed(source="../../assets/Particles/EggsplosionGoldV2.pex",mimeType="application/octet-stream")]
    static public const EggsplosionGold:Class;
     [Embed(source="../../assets/Particles/EggsplosionGoldLv7.pex",mimeType="application/octet-stream")]
    static public const EggsplosionGoldLv7:Class;
    [Embed(source="../../assets/Particles/EggsplosionRotten.pex",mimeType="application/octet-stream")]
    static public const EggsplosionRotten:Class;
    [Embed(source="../../assets/Particles/EggsplosionShuffle.pex",mimeType="application/octet-stream")]
    static public const EggsplosionShuffle:Class;
    [Embed(source="../../assets/Particles/EggsplosionGreen.pex",mimeType="application/octet-stream")]
    static public const EggsplosionGreen:Class;
    [Embed(source="../../assets/Particles/EggsplosionRottenLV1and2.pex",mimeType="application/octet-stream")]
    static public const EggsplosionRottenLV1:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion1.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion0:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion2.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion1:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion3.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion2:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion4.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion3:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion5.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion4:Class;
     [Embed(source="../../assets/Particles/ExtraLife.pex",mimeType="application/octet-stream")]
    static public const ExtraLife:Class;
    [Embed(source="../../assets/Particles/BonusTime.pex",mimeType="application/octet-stream")]
    static public const BonusTime:Class;
    [Embed(source="../../assets/Particles/ChainTimePlus.pex",mimeType="application/octet-stream")]
    static public const ChainTimePlus:Class;
    [Embed(source="../../assets/Particles/ExtraEggs.pex",mimeType="application/octet-stream")]
    static public const ExtraEggs:Class;

    
    public static var WinMusicSound:Sound;
    public static var BiteSound:Sound;
    
    public static var LevelMusic1Sound:Sound;
    public static var LevelMusic2Sound:Sound;
    public static var LevelMusic3Sound:Sound;
    public static var LevelMusic4Sound:Sound;
   
    public static const TILESIZE:int = 15;
    
    public static const DOWN:int = 0;
    public static const UP:int = 1;
    public static const LEFT:int = 2;
    public static const RIGHT:int = 3;
    
    public static const EGGNONE:int = -1;
    public static const EGGZERO:int = 0;
    public static const EGGA:int = 1;
    public static const EGGB:int = 2;
    public static const EGGC:int = 3;
    public static const EGGROTTEN:int = 4;
    public static const EGGSHUFFLE:int = 5;
    public static const EGGGOLDEN:int = 6;
    
    public static var HQ:Boolean = false;
    public static var LEVELS:Array;
    
    public static const STAGE_WIDTH:int = 960;
    public static const STAGE_HEIGHT:int = 640;
    
    public static const ASPECT_RATIO:Number = STAGE_WIDTH / STAGE_HEIGHT;
    public static var SCALE:Number = 0;
    
    public static var soundmanager:SoundManager;
    
    public static var loaded:Array = [];

    public static const MENU:String = "Menu";
    public static const SNAKE:String = "Snake";
    public static const ARCADE:String = "Arcade";
    public static const SCORING:String = "Scoring";
    public static const LEVELSELECT:String = "LevelSelect";
    
    public static const LEVEL1:String = "Level 1";
    public static const LEVEL2:String = "Level 2";
    public static const LEVEL3:String = "Level 3";
    public static const LEVEL4:String = "Level 4";
    public static const LEVEL5:String = "Level 5";
    public static const LEVEL6:String = "Level 6";
    public static const LEVEL7:String = "Level 7";
    public static const LEVEL8:String = "Level 8";
    
    public static const COMBO_TRIGGERS:Array = ["acba", "ccbba", "bcaac", "abbca", "abcb", "bccb"];
    
    public static const MEDALS:Array = ["bronze_small", "silver_small", "gold_small", "saphire_small"];
    
    
    public static var Strings:Class;
    
    // Stuff for Scoreoid.
    
    public static const GAME_ID:String = "atZTbG24V";
    public static const API_KEY:String = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
    
    // Stuff for Mogade
    public static const MOGADE_GAME_ID:String = "5041f4f8563d8a570c002491";
    public static const MOGADE_SECRET:String = "JZvZT^d=?_0yR2flZMo?ft9l3^<J5Jg";
    public static var mogade:Mogade;
    
    // Consolidated Textures.
    // Alpha
    [Embed(source = "../../assets/Textures/Alpha/1/Alpha_1.png")]
    private static const Alpha_1_PNG:Class;  
    [Embed(source = "../../assets/Textures/Alpha/1/Alpha_1.xml", mimeType = "application/octet-stream")]
    private static const Alpha_1_XML:Class;
    public static var Alpha_1_Atlas:TextureAtlas;
    [Embed(source = "../../assets/Textures/Alpha/0.25/Alpha_0.25.png")]
    private static const Alpha_025_PNG:Class;
    [Embed(source = "../../assets/Textures/Alpha/0.25/Alpha_0.25.xml", mimeType = "application/octet-stream")]
    private static const Alpha_025_XML:Class;
    public static var Alpha_025_Atlas:TextureAtlas;
    
    // Opaque
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part1.atf", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part1_ATF:Class;
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part1.xml", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part1_XML:Class;
    public static var Opaque_1_Part1_Atlas:TextureAtlas;
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part2.atf", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part2_ATF:Class;
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part2.xml", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part2_XML:Class;
    public static var Opaque_1_Part2_Atlas:TextureAtlas;    
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part3.atf", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part3_ATF:Class;
    [Embed(source = "../../assets/Textures/Opaque/1/Opaque_1_Part3.xml", mimeType = "application/octet-stream")]
    private static const Opaque_1_Part3_XML:Class;
    public static var Opaque_1_Part3_Atlas:TextureAtlas;
    
    
    public static function init():void
    {
      LEVELS = [Level1, Level2, Level3, Level4, Level5, Level6, Level7, null, ArcadeState];
      TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new FontPNG), XML(new FontXML)));
      
      LevelMusic1Sound = new LevelMusic1;
      LevelMusic2Sound = new LevelMusic2;
      LevelMusic3Sound = new LevelMusic3;
      LevelMusic4Sound = new LevelMusic4;
      
      soundmanager = new SoundManager();
      soundmanager.musicMuted = SaveGame.musicMuted;
      soundmanager.SFXMuted = SaveGame.SFXMuted;
      
      mogade = new Mogade(MOGADE_GAME_ID, MOGADE_SECRET);
      
	    if (SaveGame.language == 2){
	      Strings = Deutsch;
      } else {
        Strings = English;
      }
      
      registerSounds();
      registerMusic();
      
      Alpha_1_Atlas = new TextureAtlas(Texture.fromBitmap(new Alpha_1_PNG), XML(new Alpha_1_XML));
      Alpha_025_Atlas = new TextureAtlas(Texture.fromBitmap(new Alpha_025_PNG, true, false, 0.25), XML(new Alpha_025_XML));
      
      Opaque_1_Part1_Atlas = new TextureAtlas(Texture.fromAtfData(new Opaque_1_Part1_ATF), XML(new Opaque_1_Part1_XML));
      Opaque_1_Part2_Atlas = new TextureAtlas(Texture.fromAtfData(new Opaque_1_Part2_ATF), XML(new Opaque_1_Part2_XML));
      Opaque_1_Part3_Atlas = new TextureAtlas(Texture.fromAtfData(new Opaque_1_Part3_ATF), XML(new Opaque_1_Part3_XML));
      
      UIAtlas = new TextureAtlas(Texture.fromBitmap(new UIAtlasPNG, true, false, 0.4), XML(new UIAtlasXML));      
    }
    
    public static function loadGraphics(needed:Array, keep:Boolean = false):void {
      return;
    }
    
    public static function registerSounds():void {
      soundmanager.registerSound("comboSound0", new ComboSound0);
      soundmanager.registerSound("comboSound1", new ComboSound1);
      soundmanager.registerSound("comboSound2", new ComboSound2);
      soundmanager.registerSound("comboSound3", new ComboSound3);
      soundmanager.registerSound("comboSound4", new ComboSound4);
      soundmanager.registerSound("comboSound5", new ComboSound5);
      soundmanager.registerSound("comboSound6", new ComboSound6);
      soundmanager.registerSound("comboSound7", new ComboSound7);
      soundmanager.registerSound("bite1", new Bite1());
      soundmanager.registerSound("bite2", new Bite2());
      soundmanager.registerSound("bite3", new Bite3());
      soundmanager.registerSound("rottenEggSound", new RottenEggSound);
      soundmanager.registerSound("goldenEggSound", new GoldenEggSound);
      soundmanager.registerSound("shuffleEggSound", new ShuffleEggSound);
      soundmanager.registerSound("gameOverSound", new GameOverSound);
      soundmanager.registerSound("dieSound", new DieSound);
      soundmanager.registerSound("winSound", new WinSound);
      soundmanager.registerSound("medalSound1", new MedalSound1);
      soundmanager.registerSound("medalSound2", new MedalSound2);
      soundmanager.registerSound("eruption", new Eruption);
      soundmanager.registerSound("explosion", new Explosion);
      soundmanager.registerSound("pling", new PointsPling);
      soundmanager.registerSound("endPling", new PointsPling2);
    }
    
    public static function registerMusic():void {
      soundmanager.registerSound("arcadeMusic", new ArcadeMusic);
      soundmanager.registerSound("arcadeEndlessMusic", new ArcadeEndlessMusic);
    }
    
  }

}
