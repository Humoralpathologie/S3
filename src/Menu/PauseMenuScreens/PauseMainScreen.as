package Menu.PauseMenuScreens
{
  import Level.LevelState;
  import org.josht.starling.foxhole.controls.Button;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.Slider;
  import org.josht.starling.foxhole.controls.ToggleSwitch;
  import starling.display.Quad;
  import org.osflash.signals.ISignal;
  import Menu.MainMenu;
  import flash.utils.*;
  import engine.ManagedStage;
  import starling.events.TouchEvent;
  import starling.text.TextField;
  import starling.core.Starling;
  import engine.AssetRegistry;
  import starling.utils.Color;
  import org.josht.starling.foxhole.controls.Radio;
  import org.josht.starling.foxhole.core.ToggleGroup;
  import engine.SaveGame;
  import UI.HUD;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  /**
   * ...
   * @author
   */
  public class PauseMainScreen extends Screen
  {
    private var _levelstate:LevelState;
    private var _greyBox:Quad;
    //private var _zoomSlider:Slider;
    private var _backButton:Button;
    private var _restartButton:Button;
    private var _pauseHeading:TextField;
    private var _musicToggle:ToggleSwitch;
    private var _sfxToggle:ToggleSwitch;
    private var _sfxHeading:TextField;
    private var _musicHeading:TextField;
    private var _controlsHeading:TextField;
      
    
    public function PauseMainScreen(levelstate:LevelState)
    
    {
      super();
      _levelstate = levelstate;
      
      _greyBox = new Quad(710, 480, 0);
      _greyBox.x = 125;
      _greyBox.y = 95;
      _greyBox.alpha = 0.3;
      addChild(_greyBox);
      
      var onTouch:Function = function (e:TouchEvent) :void {
        var touch:Touch;
        touch = e.getTouch(_pauseHeading, TouchPhase.ENDED);
        if (touch)
        {       
          _levelstate.hidePauseMenu(); 
          _levelstate.unpause(); 
        }
      }

      
      _pauseHeading = new TextField(_greyBox.width, 80, AssetRegistry.Strings.PAUSE, "kroeger 06_65", 60, Color.WHITE);
      _pauseHeading.x = (Starling.current.stage.stageWidth - _pauseHeading.width) / 2;
      _pauseHeading.y = 100;
      addChild(_pauseHeading);
      _pauseHeading.addEventListener(TouchEvent.TOUCH,  onTouch);
      
      _restartButton = new Button();
      _restartButton.label = AssetRegistry.Strings.RESTART;
      _restartButton.width = 300;
      _restartButton.height = 80;
      _restartButton.x = _greyBox.x + 30;
      _restartButton.y = _pauseHeading.y + 100;
      _restartButton.onRelease.add(function(button:Button):void
        {
          dispatchEventWith(ManagedStage.SWITCHING, true, {stage: Class(getDefinitionByName(getQualifiedClassName(levelstate)))});
        });
      _backButton = new Button();
      _backButton.label = AssetRegistry.Strings.BACK;
      _backButton.width = 300;
      _backButton.height = 80;
      _backButton.x = _restartButton.x + _restartButton.width + 50;
      _backButton.y = _pauseHeading.y + 100;
      _backButton.onRelease.add(function(button:Button):void
        {
          dispatchEventWith(ManagedStage.SWITCHING, true, {stage: MainMenu});
        });
      
      addChild(_backButton);
      addChild(_restartButton);
      
      addToggles();
      addControlSwitches();
      
      this.validate();
    }
    
    private function addToggles():void
    {
      _musicHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.MUSIC, "kroeger 06_65", 40, Color.WHITE);
      _musicHeading.x = _restartButton.x + ((_restartButton.width - _musicHeading.width) / 2);
      _musicHeading.y = _restartButton.y + 100;
      _musicToggle = new ToggleSwitch();
      _musicToggle.width = 200;
      
      //_arcadeModiToggleSwitch.isSelected = SaveGame.arcadeModi;
      _musicToggle.x = _restartButton.x + ((_restartButton.width - _musicToggle.width) / 2);
      _musicToggle.y = _musicHeading.y + 50;
      
      _musicToggle.onChange.add(function(tswitch:ToggleSwitch):void
        {
        //SaveGame.arcadeModi = tswitch.isSelected;
        });
      _sfxHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.SFX, "kroeger 06_65", 40, Color.WHITE);
      _sfxHeading.x = _backButton.x + ((_backButton.width - _sfxHeading.width) / 2);
      _sfxHeading.y = _backButton.y + 100;
      
      _sfxToggle = new ToggleSwitch();
      _sfxToggle.width = 200;
      
      //_arcadeModiToggleSwitch.isSelected = SaveGame.arcadeModi;
      _sfxToggle.x = _backButton.x + ((_backButton.width - _musicToggle.width) / 2);
      _sfxToggle.y = _sfxHeading.y + 50;
      
      _sfxToggle.onChange.add(function(tswitch:ToggleSwitch):void
        {
        //SaveGame.arcadeModi = tswitch.isSelected;
        });
      addChild(_sfxHeading);
      addChild(_musicHeading);
      addChild(_musicToggle);
      addChild(_sfxToggle);
    }
    
    private function addControlSwitches():void
    {
      
      _controlsHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.CONTROLTYPE, "kroeger 06_65", 40, Color.WHITE);
      _controlsHeading.x = _greyBox.x + (_greyBox.width - _controlsHeading.width) / 2;
      _controlsHeading.y = _sfxToggle.y + 100;
      addChild(_controlsHeading);
      
      var controlGroup:ToggleGroup = new ToggleGroup;
      var boyStyle:Radio = new Radio();
      boyStyle.label = AssetRegistry.Strings.SNAKEVIEW;
      boyStyle.toggleGroup = controlGroup;
      boyStyle.onPress.add(function(radio:Radio):void
        {
          SaveGame.controlType = 1;
          dispatchEventWith(HUD.CONTROLS_CHANGED, true);
        });
      
      var fourway:Radio = new Radio;
      fourway.label = AssetRegistry.Strings.FOURWAY;
      fourway.toggleGroup = controlGroup;
      fourway.onPress.add(function(radio:Radio):void
        {
          SaveGame.controlType = 2;
          dispatchEventWith(HUD.CONTROLS_CHANGED, true);         
        });
      
      controlGroup.selectedIndex = SaveGame.controlType - 1;
      
      boyStyle.x = _restartButton.x + 60;
      fourway.x = _backButton.x + 60;
      
      boyStyle.y = _controlsHeading.y + _controlsHeading.height;
      fourway.y = boyStyle.y;
      
      addChild(boyStyle);
      addChild(fourway);
    }
  }

}