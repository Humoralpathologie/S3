package Menu.ComboMenuScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.ToggleSwitch;
  import org.osflash.signals.Signal;
  import starling.display.Button;
  import engine.AssetRegistry;
  import org.osflash.signals.ISignal;
  import starling.display.Quad;
  import starling.events.Event;
  import starling.utils.Color;
  import starling.core.Starling;
  import engine.StageManager;
  import Level.ArcadeState;
  import engine.SaveGame;
  import starling.text.TextField;
  
  /**
   * ...
   * @author
   */
  public class MainComboMenu extends Screen
  {
    
    protected var _onComboSelect:Signal = new Signal(MainComboMenu);
    protected var _sharedData:Object = { };
    protected var _greybox:Quad;
	protected var _arcadeModiHeading:TextField;
	protected var _arcadeModiToggleSwitch:ToggleSwitch;
    
    public function MainComboMenu()
    {
      super();
    }
    
    override protected function initialize():void
    {
      
      //var greybox:Image = new Image(AssetRegistry.MenuAtlas.getTexture("arcade-box-710"));
      _greybox = new Quad(710, 450, Color.BLACK);
      _greybox.alpha = 0.3;
      _greybox.x = 65 + 60;
      _greybox.y = 40 + 30;
      
      addChild(_greybox);
      
      addSwitchers();
      addButtons();
      addNormalCombos();
      addInfo();
	  addToggle();
    }
    
    private function addInfo():void {
      var question:Button = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("info-button"));
      question.x = 860;
      question.y = 30;
      addChild(question);
      
      /*var infoDisplay:Button = new Button(AssetRegistry.MenuAtlas.getTexture("info-arcade"));
      infoDisplay.x = (Starling.current.stage.stageWidth - infoDisplay.width) / 2;
      infoDisplay.y = (Starling.current.stage.stageHeight - infoDisplay.height) / 2;
      
      question.addEventListener(Event.TRIGGERED, function(event:Event) {
        addChild(infoDisplay);
      });
      
      infoDisplay.addEventListener(Event.TRIGGERED, function(event:Event) {
        removeChild(infoDisplay);
      });
      */
    }
	
    private function addToggle():void {
      _arcadeModiHeading = new TextField(_greybox.width, 50, "4 Mins / Endless", "kroeger 06_65", 40, Color.WHITE);
      _arcadeModiHeading.x = (Starling.current.stage.stageWidth - _arcadeModiHeading.width) / 2;
      _arcadeModiHeading.y = _greybox.y + 20;
      addChild(_arcadeModiHeading);
      
      _arcadeModiToggleSwitch = new ToggleSwitch();
      _arcadeModiToggleSwitch.isSelected = SaveGame.arcadeModi;
      _arcadeModiToggleSwitch.x = Starling.current.stage.stageWidth / 2;
      _arcadeModiToggleSwitch.y = _arcadeModiHeading.y + _arcadeModiHeading.height;
      
      _arcadeModiToggleSwitch.onChange.add(function(tswitch:ToggleSwitch):void {
        SaveGame.arcadeModi = tswitch.isSelected;
      });
      
      addChild(_arcadeModiToggleSwitch);
    }
	
    private function addSwitchers():void
    {
      //var play:Button = new Button(AssetRegistry.MenuAtlas.getTexture("text_play"));
      var play:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      play.label = AssetRegistry.Strings.PLAY;
      play.height = 80;
      play.width = 300;
      play.x = 65 + 60;
      play.y = 540;
      addChild(play);
      play.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void {
        StageManager.switchStage(ArcadeState);
      });
    }
    
    private function addNormalCombos():void
    {
      
      var buttons:Array = [[AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed"), AssetRegistry.MenuAtlasOpaque.getTexture("info-speed")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-time"), AssetRegistry.MenuAtlasOpaque.getTexture("info-time")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-rotteneggs"), AssetRegistry.MenuAtlasOpaque.getTexture("info-rotteneggs")]]//, [AssetRegistry.MenuAtlasOpaque.getTexture("combo-shuffle"), AssetRegistry.MenuAtlasOpaque.getTexture("info-shuffle")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-gold"), AssetRegistry.MenuAtlasOpaque.getTexture("info-gold")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-xtralife"), AssetRegistry.MenuAtlasOpaque.getTexture("info-xtralife")]];
      
      var space:int = 80;
      for (var i:int = 0; i < buttons.length; i++)
      {
        var button:Button = new Button(buttons[i][0]);
        button.x = (_greybox.x + (_greybox.width - (buttons.length * button.width + (buttons.length - 1) * space)) / 2) + i * (button.width + space);        
        button.y = 382;
        addChild(button);
        /*
        var desc:Button = new Button(buttons[i][1]);
        desc.x = (Starling.current.stage.stageWidth - desc.width) / 2;
        desc.y = (Starling.current.stage.stageHeight - desc.height) / 2;
        desc.scaleWhenDown = 1;
        */
        
        var that:MainComboMenu = this;
        /*
        var f:Function = function(desc:Button):void
        {
          button.addEventListener(Event.TRIGGERED, function(event:Event):void
            {
              that.addChild(desc);
            });
          
          desc.addEventListener(Event.TRIGGERED, function(event:Event):void
            {
              that.removeChild(desc);
            });
        };
        f(desc);
        */
      }
    /*
       var comboSpeed:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-speed"));
       buttons.push(comboSpeed);
    
       var comboTime:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-time"));
       buttons.push(comboTime);
    
       var comboRotteneggs:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-rotteneggs"));
     buttons.push(comboRotteneggs);*/
    
    }
    
    private function addButtons():void
    {
      var buttonCount:int = 3;
      var space:int = 80;
      
      var combos:Array = AssetRegistry.COMBO_TRIGGERS;
      
      for (var i:int = 0; i < buttonCount; i++)
      {
        var slot:Button;
        //SaveGame.specials = { };
        if (SaveGame.specials[i])
        {
          slot = new Button(AssetRegistry.MenuAtlasOpaque.getTexture(SaveGame.specials[i].effect));
        }
        else
        {
          slot = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-special"));         
        }
        addChild(slot);
        
        var combo:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture(combos[i]));
        combo.x = 0;
        combo.y = 0;
        slot.addChild(combo);
        
        slot.x = (_greybox.x + (_greybox.width - (buttonCount * slot.width + (buttonCount - 1) * space)) / 2) + i * (slot.width + space);
        slot.y = 112 + 30;
        slot.addEventListener(Event.TRIGGERED, buttonSelector(i));
      }
    }
    
    protected function buttonSelector(slot:int):Function
    {
      var that:MainComboMenu = this;
      
      return function(event:Event):void
      {
        sharedData.selected = slot;
        onComboSelect.dispatch(that);
      }
    }
    
    public function get onComboSelect():ISignal
    {
      return _onComboSelect;
    }
    
    public function get sharedData():Object
    {
      return _sharedData;
    }
    
    public function set sharedData(value:Object):void
    {
      _sharedData = value;
    }
  }

}
