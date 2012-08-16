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
  import Menu.MainMenu;
  import Menu.LevelScore;
  
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
	protected var question:Button;
	protected var _buttons:Array = [];
    
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
	  
      _arcadeModiHeading = new TextField(_greybox.width, 60, AssetRegistry.Strings.ARCADEHEADING, "kroeger 06_65", 60, Color.WHITE);
      _arcadeModiHeading.x = (Starling.current.stage.stageWidth - _arcadeModiHeading.width) / 2;
      _arcadeModiHeading.y = 10;
      addChild(_arcadeModiHeading);
      
      
      addSwitchers();
      addButtons();
      addNormalCombos();
	  addToggle();
      addInfo();
    }
	
    private function addInfo():void {
      question = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("info-button"));
      question.x = 860;
      question.y = 30;
      addChild(question);
      var xButton:Button = new Button( AssetRegistry.MenuAtlasAlpha.getTexture("x"));
	  xButton.x = 860;
	  xButton.y = 30;
	  
      var infoDisplay:Quad = new Quad(710, 450, 0x545454);
      infoDisplay.x = 65 + 60;
      infoDisplay.y = 40 + 30;
	  infoDisplay.alpha = 1;

	  var text:TextField = new TextField(infoDisplay.width, infoDisplay.height, AssetRegistry.Strings.ARCADEINFO, "kroeger 06_65", 40, Color.WHITE);
      text.x = infoDisplay.x;
	  text.y = infoDisplay.y;
	  
	  if (!SaveGame.secondArcade) {
		  addChild(infoDisplay);
		  addChild(text);
		  removeChild(question);
		  addChild(xButton);
		  SaveGame.secondArcade = true;
	  }
	  
	  question.addEventListener(Event.TRIGGERED, function(event:Event) {
        addChild(infoDisplay);
		addChild(text);
		addChild(xButton);
		removeChild(question);
      });
      
      xButton.addEventListener(Event.TRIGGERED, function(event:Event) {
        removeChild(infoDisplay);
		addChild(question);
		removeChild(text);
		removeChild(xButton);
      });
      
    }
	
	private function addComboInfo(i:int, button:Button):void {
	  var xButton:Button = new Button( AssetRegistry.MenuAtlasAlpha.getTexture("x"));
	  xButton.x = 860;
	  xButton.y = 30;
	  
      var infoDisplay:Quad = new Quad(710, 450, 0x545454);
      infoDisplay.x = 65 + 60;
      infoDisplay.y = 40 + 30;
	  infoDisplay.alpha = 1;

	  var text:TextField = new TextField(infoDisplay.width - 40, infoDisplay.height, " ", "kroeger 06_65", 40, Color.WHITE);
      text.x = infoDisplay.x + 20;
	  text.y = infoDisplay.y;
	  
	  
	  
	  switch (i) {
		case 0:
			text.text = AssetRegistry.Strings.SPEEDDESC;
		break;
		case 1:
			if (SaveGame.arcadeModi){
				text.text = AssetRegistry.Strings.TIMEDESC;
			} else {
				text.text = AssetRegistry.Strings.SLOWERDESC;
			}
		break;
		case 2:
			text.text = AssetRegistry.Strings.NOROTTENDESC;
		break;
	  }
	  
	  _buttons.push([button, text]);
	  
	  button.addEventListener(Event.TRIGGERED, function(event:Event) {
        removeChild(question);
		addChild(infoDisplay);
		addChild(text);
		addChild(xButton);
		
      });
      
      xButton.addEventListener(Event.TRIGGERED, function(event:Event) {
        removeChild(infoDisplay);
		addChild(question);
		removeChild(text);
		removeChild(xButton);
      });
	}
	
    private function addToggle():void {
	 
      _arcadeModiToggleSwitch = new ToggleSwitch();
	  _arcadeModiToggleSwitch.width = 400;
	  
	  _arcadeModiToggleSwitch.offText = AssetRegistry.Strings.OFFLABEL;
	  _arcadeModiToggleSwitch.onText = AssetRegistry.Strings.ONLABEL;
	  //_arcadeModiToggleSwitch.offLabelProperties = 
      _arcadeModiToggleSwitch.isSelected = SaveGame.arcadeModi;
      _arcadeModiToggleSwitch.x = (Starling.current.stage.stageWidth - _arcadeModiToggleSwitch.width) / 2;
      _arcadeModiToggleSwitch.y = _greybox.y + 350;
      
      _arcadeModiToggleSwitch.onChange.add(function(tswitch:ToggleSwitch):void {
        SaveGame.arcadeModi = tswitch.isSelected;
		unflatten();
		if (SaveGame.arcadeModi) {
			_buttons[4][0].upState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-time");
			_buttons[4][1].text = AssetRegistry.Strings.TIMEDESC;
		} else {
			_buttons[4][0].upState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed");
			_buttons[4][1].text = AssetRegistry.Strings.SLOWERDESC;	
		}
      });
      
      addChild(_arcadeModiToggleSwitch);
    }
	
    private function addSwitchers():void
    {
      //var play:Button = new Button(AssetRegistry.MenuAtlas.getTexture("text_play"));
      var play:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      play.label = AssetRegistry.Strings.PLAY;
      play.height = 80;
      play.width = 220;
      play.x = 65 + 60;
      play.y = 540;
      addChild(play);
      play.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void {
        StageManager.switchStage(ArcadeState);
      });
	  
	   var leaderboards:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      leaderboards.label = AssetRegistry.Strings.LEADERBOARDS;
      leaderboards.height = 80;
      leaderboards.width = 250;
      leaderboards.x = play.x + play.width + 10;
      leaderboards.y = 540;
      addChild(leaderboards);
      leaderboards.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void {
        StageManager.switchStage(LevelScore);
      });
	  
	  var back:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      back.label = AssetRegistry.Strings.BACKBUTTON;
      back.height = 80;
      back.width = 220;
      back.x = leaderboards.x + leaderboards.width + 10;
      back.y = 540;
      addChild(back);
      back.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void {
        StageManager.switchStage(MainMenu);
      });
	
    }
    
    private function addNormalCombos():void
    {
	  var buttons:Array;
      if (SaveGame.arcadeModi) {
		buttons = [AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-time"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-rotteneggs")]//, [AssetRegistry.MenuAtlasOpaque.getTexture("combo-shuffle"), AssetRegistry.MenuAtlasOpaque.getTexture("info-shuffle")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-gold"), AssetRegistry.MenuAtlasOpaque.getTexture("info-gold")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-xtralife"), AssetRegistry.MenuAtlasOpaque.getTexture("info-xtralife")]];
      } else {
		buttons = [AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-rotteneggs")];
	  }
	  
      var space:int = 80;
      for (var i:int = 0; i < buttons.length; i++)
      {
        var button:Button = new Button(buttons[i]);
        button.x = (_greybox.x + (_greybox.width - (buttons.length * button.width + (buttons.length - 1) * space)) / 2) + i * (button.width + space);        
        button.y = 270;
        addChild(button);
		addComboInfo(i, button);
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
		_buttons.push(slot);
        
        slot.x = (_greybox.x + (_greybox.width - (buttonCount * slot.width + (buttonCount - 1) * space)) / 2) + i * (slot.width + space);
        slot.y = 112;
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
