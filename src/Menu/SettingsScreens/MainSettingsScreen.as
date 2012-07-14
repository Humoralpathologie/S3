package Menu.SettingsScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.Slider;
  import org.josht.starling.foxhole.controls.TextInput;
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
    private var _nameInput:TextInput;
    
    public function MainSettingsScreen()
    {
      super();
      _greyBox = new Quad(710, 450, Color.BLACK);
      _greyBox.alpha = 0.7;
      _greyBox.x = 65 + 60;
      _greyBox.y = 40 + 30;
      
      addChild(_greyBox);      
      
      _heading = new TextField(_greyBox.width, 50, "Main Settings", "kroeger 06_65", 50, Color.WHITE);
      _heading.x = _greyBox.x;
      _heading.y = _greyBox.y;
      addChild(_heading);
      
      _betaButton = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
      _betaButton.scaleX = -1;
      _betaButton.x = _greyBox.x + _greyBox.width + _betaButton.width;
      _betaButton.y = _greyBox.y;
      
      var that = this;
      
      _betaButton.addEventListener(Event.TRIGGERED, function(event:Event) {
        _onBetaSelect.dispatch(that);
      });
      
      addChild(_betaButton);
      
      addControlSwitches();
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
      _nameHeading.x = _greyBox.x + _nameHeading.width;
      _nameHeading.y = _greyBox.y + _nameHeading.height;
      
      addChild(_nameHeading);
     
      _nameInput = new TextInput();
      _nameInput.text = SaveGame.userName;
      
      _nameInput.x = _nameHeading.x;
      _nameInput.y = _nameHeading.y + _nameHeading.height;
      _nameInput.width = _nameHeading.width - 30;
      
      _nameInput.onChange.add(function(input:TextInput):void {
        SaveGame.userName = input.text;
      });
      
      addChild(_nameInput);
      
    }
    
    private function addControlSwitches():void {
      
      _controlsHeading = new TextField(_greyBox.width / 2, 50, "Control Type", "kroeger 06_65", 40, Color.WHITE);
      _controlsHeading.x = _greyBox.x;
      _controlsHeading.y = _heading.y + _heading.height;
      addChild(_controlsHeading);
      
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
      
      boyStyle.x = fourway.x = 160;
      
      boyStyle.y = _controlsHeading.y + _controlsHeading.height;
      fourway.y = boyStyle.y + 70;

      
      addChild(boyStyle);
      addChild(fourway);
    }
    
    public function get onBetaSelect():Signal 
    {
        return _onBetaSelect;
    }
    
  }

}