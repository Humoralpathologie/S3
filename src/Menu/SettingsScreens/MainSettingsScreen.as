package Menu.SettingsScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.Slider;
  import org.josht.starling.foxhole.controls.TextInput;
  import org.josht.starling.foxhole.controls.Scroller;
  import org.josht.starling.foxhole.controls.ScrollBar;
  import org.osflash.signals.Signal;
  import starling.display.Button;
  import starling.display.Sprite;  
  import engine.AssetRegistry;
  import org.osflash.signals.ISignal;
  import starling.display.Quad;
  import starling.events.Event;
  import starling.utils.Color;
  import starling.core.Starling;
  import engine.StageManager;
  import Level.ArcadeState;
  import engine.SaveGame;
  import org.josht.starling.foxhole.controls.Radio;
  import org.josht.starling.foxhole.core.ToggleGroup;
  import starling.text.TextField;
  
  /**
   * ...
   * @author
   */
  public class MainSettingsScreen extends Screen
  {
    
    protected var _onBetaSelect:Signal = new Signal(MainSettingsScreen);
    protected var _sharedData:Object = { };
    protected var _betaButton:Button;
    private var _greyBox:Quad;
    private var _heading:TextField;
    private var _controlsHeading:TextField;
    private var _nameHeading:TextField;
	private var _langHeading:TextField;
    private var _nameInput:TextInput;
	private var _diffHeading:TextField;
	private var _scroller:Scroller;
	private var _scrollable:Sprite;
    
    public function MainSettingsScreen()
    {
      super();
	  _scrollable = new Sprite();
	  
      _greyBox = new Quad(710, 500, Color.BLACK);
      _greyBox.alpha = 0.7;
      _greyBox.x = 65 + 60;
      _greyBox.y = 40 + 30;
      
      addChild(_greyBox);      
      
	  _scroller = new Scroller();
      _scroller.setSize(_greyBox.width, _greyBox.height - 100);
      _scroller.x = _greyBox.x;
      _scroller.y = _greyBox.y;
      _scroller.viewPort = _scrollable;
	  addChild(_scroller);
	  
      _heading = new TextField(_greyBox.width, 50, "Main Settings", "kroeger 06_65", 50, Color.WHITE);
      _heading.x = (_greyBox.width - _heading.width) / 2;
      _scrollable.addChild(_heading);
	  
      /*
      _betaButton = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
      _betaButton.scaleX = -1;
      _betaButton.x = _greyBox.x + _greyBox.width + _betaButton.width;
      _betaButton.y = _greyBox.y;
      
      var that = this;
      
      _betaButton.addEventListener(Event.TRIGGERED, function(event:Event) {
        _onBetaSelect.dispatch(that);
      });
      
      addChild(_betaButton);
      */
      addControlSwitches();
	  addDifficultySwitches();
	  addLanguageSwitches();
      addUserName();      
    }
    
    override protected function initialize():void
    {
      

      
      //addSwitchers();
      //addButtons();
      //addNormalCombos();
      //addInfo();
    }
    
    private function addUserName():void {
      _nameHeading = new TextField(_greyBox.width / 2, 50, "User Name", "kroeger 06_65", 40, Color.WHITE);
      _nameHeading.x = (_greyBox.width - _nameHeading.width) / 2;
      _nameHeading.y = _langHeading.y + _langHeading.height + 50;
      
      _scrollable.addChild(_nameHeading);
     
      _nameInput = new TextInput();
      _nameInput.text = SaveGame.userName;
      
      _nameInput.x = _nameHeading.x;
      _nameInput.y = _nameHeading.y + _nameHeading.height;
      _nameInput.width = _nameHeading.width - 30;
      
      _nameInput.onChange.add(function(input:TextInput):void {
        SaveGame.userName = input.text;
      });
      
      _scrollable.addChild(_nameInput);
      
    }
    
    private function addControlSwitches():void {
      
      _controlsHeading = new TextField(_greyBox.width / 2, 50, "Control Type", "kroeger 06_65", 40, Color.WHITE);
      _controlsHeading.x = (_greyBox.width - _controlsHeading.width) / 2;
      _controlsHeading.y = _heading.y + _heading.height + 20;
      _scrollable.addChild(_controlsHeading);
      
      var controlGroup:ToggleGroup = new ToggleGroup;
      var boyStyle:Radio = new Radio();
      boyStyle.label = "Snake View";
      boyStyle.toggleGroup = controlGroup;
      boyStyle.onPress.add(function(radio:Radio):void {
        SaveGame.controlType = 1;
      });
      
      var fourway:Radio = new Radio;
      fourway.label = "4-Way";
      fourway.toggleGroup = controlGroup;
      fourway.onPress.add(function(radio:Radio):void {
        SaveGame.controlType = 2;
      });
      
      controlGroup.selectedIndex = SaveGame.controlType - 1;
      
      boyStyle.x = _greyBox.x;
	  fourway.x = _greyBox.x + (_greyBox.width / 2);
      
      boyStyle.y = _controlsHeading.y + _controlsHeading.height;
      fourway.y = boyStyle.y;

      
      _scrollable.addChild(boyStyle);
      _scrollable.addChild(fourway);
    }
    private function addDifficultySwitches():void {
      
      _diffHeading = new TextField(_greyBox.width / 2, 50, "Level Difficulty", "kroeger 06_65", 40, Color.WHITE);
      _diffHeading.x = (_greyBox.width - _diffHeading.width) / 2;
      _diffHeading.y = _controlsHeading.y + _controlsHeading.height + 50;
      _scrollable.addChild(_diffHeading);
      
      var diffGroup:ToggleGroup = new ToggleGroup;
      var casual:Radio = new Radio();
      casual.label = "Casual";
      casual.toggleGroup = diffGroup;
      casual.onPress.add(function(radio:Radio):void {
        SaveGame.difficulty = 1;
      });
      
      var competetive:Radio = new Radio;
      competetive.label = "Competetive";
      competetive.toggleGroup = diffGroup;
      competetive.onPress.add(function(radio:Radio):void {
        SaveGame.difficulty = 2;
      });
      
      diffGroup.selectedIndex = SaveGame.difficulty - 1;
      
      casual.x = _greyBox.x;
	  competetive.x = _greyBox.x + (_greyBox.width / 2);
      
      casual.y = _diffHeading.y + _diffHeading.height;
      competetive.y = casual.y;

      
      _scrollable.addChild(casual);
      _scrollable.addChild(competetive);
    }
	
	private function addLanguageSwitches():void {
      
      _langHeading = new TextField(_greyBox.width / 2, 50, "Language", "kroeger 06_65", 40, Color.WHITE);
      _langHeading.x = (_greyBox.width - _langHeading.width) / 2;
      _langHeading.y = _diffHeading.y + _diffHeading.height + 50;
      _scrollable.addChild(_langHeading);
      
      var langGroup:ToggleGroup = new ToggleGroup;
      var eng:Radio = new Radio();
      eng.label = "English";
      eng.toggleGroup = langGroup;
      eng.onPress.add(function(radio:Radio):void {
        SaveGame.language = 1;
      });
      
      var ger:Radio = new Radio;
      ger.label = "Deutsch";
      ger.toggleGroup = langGroup;
      ger.onPress.add(function(radio:Radio):void {
        SaveGame.language = 2;
      });
      
      langGroup.selectedIndex = SaveGame.language - 1;
      
      eng.x = _greyBox.x;
	  ger.x = _greyBox.x + (_greyBox.width / 2);
      
      eng.y = _langHeading.y + _langHeading.height;
      ger.y = eng.y;

      
      _scrollable.addChild(eng);
      _scrollable.addChild(ger);
    }
	
    public function get onBetaSelect():Signal 
    {
        return _onBetaSelect;
    }
    
  }

}