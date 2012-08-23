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
  import engine.ManagedStage;
  import Level.ArcadeState;
  import engine.SaveGame;
  import starling.text.TextField;
  import Menu.MainMenu;
  import Menu.LevelScore;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import starling.events.Touch;
  import org.josht.starling.foxhole.controls.Scroller;
  import org.josht.starling.foxhole.controls.ScrollBar;
  import starling.display.Sprite;
	import starling.utils.HAlign;
  
  /**
   * ...
   * @author
   */
  public class MainComboMenu extends Screen
  {
    
    protected var _onComboSelect:Signal = new Signal(MainComboMenu);
    protected var _sharedData:Object = {};
    protected var _greybox:Quad;
    
    protected var _arcadeModiHeading:TextField;
    protected var _arcadeModiToggleSwitch:ToggleSwitch;
    protected var question:Image;
    protected var xButton:Image;
    protected var _buttons:Array = [];
    protected var _infoButtonX:Quad;
    protected var _infoButtonQ:Quad;
    protected var infoDisplay:Quad;
    protected var _text:TextField;
    private var _scroller:Scroller;
    private var _scrollable:Sprite;
    
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
      
      xButton = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));
      xButton.x = 860;
      xButton.y = 30;
      
      infoDisplay = new Quad(710, 450, Color.BLACK);
      infoDisplay.x = 65 + 60;
      infoDisplay.y = 40 + 30;
      infoDisplay.alpha = 0.8;
      
			_text = new TextField(_greybox.width - 40, infoDisplay.height + 340, "", "kroeger 06_65", 40, Color.WHITE);
			_text.x = 20;
			//_text.hAlign = HAlign.LEFT;
      
      //_text.y = infoDisplay.y;
      
      _scrollable = new Sprite();
      
      _scroller = new Scroller();
      _scroller.setSize(_greybox.width, _greybox.height - 10);
      _scroller.x = _greybox.x;
      _scroller.y = _greybox.y;
      _scroller.viewPort = _scrollable;
      
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
    
    private function addInfo():void
    {
      _infoButtonQ = new Quad(200, 200, Color.BLACK);
      _infoButtonQ.x = 760;
      _infoButtonQ.y = 0;
      _infoButtonQ.alpha = 0;
      
      question = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("info-button"));
      question.x = 860;
      question.y = 30;
      addChild(question);
      addChild(_infoButtonQ);
      
      _infoButtonX = new Quad(200, 200, Color.BLACK);
      _infoButtonX.x = _infoButtonQ.x;
      _infoButtonX.y = 0;
      _infoButtonX.alpha = 0;
      
      if (!SaveGame.secondArcade)
      {
				_text.height = infoDisplay.height + 340;
        _text.text = AssetRegistry.Strings.ARCADEINFO;
        addChild(infoDisplay);
        //addChild(_scrollable);
        addChild(_scroller);
        _scrollable.addChild(_text);
        removeChild(question);
        removeChild(_infoButtonQ);
        addChild(xButton);
        addChild(_infoButtonX);
        SaveGame.secondArcade = true;
      }
      
      var that:MainComboMenu = this;
      
      _infoButtonQ.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
        {
          var touch:Touch = event.getTouch(that, TouchPhase.ENDED);
          if (touch)
          {

						_text.height = infoDisplay.height + 340;
            _text.text = AssetRegistry.Strings.ARCADEINFO;
            addChild(infoDisplay);
            //addChild(_scrollable);
            addChild(_scroller);
            _scrollable.addChild(_text);
            addChild(xButton);
            addChild(_infoButtonX);
            removeChild(_infoButtonQ);
            removeChild(question);
          }
        });
      
      _infoButtonX.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
        {
          var touch:Touch = event.getTouch(that, TouchPhase.ENDED);
          if (touch)
          {
            removeChild(infoDisplay);
            //removeChild(_scrollable);
            removeChild(_scroller);
            addChild(question);
            addChild(_infoButtonQ);
            removeChild(xButton);
            removeChild(_infoButtonX);
          }
        });
	
    }
    
    private function addComboInfo(i:int, button:Button):void
    {
			
			_buttons.push([button, _text]);
			
			button.addEventListener(Event.TRIGGERED, function(event:Event):void
				{
					_text.height = _greybox.height;
          switch (i)
          {
            case 0:
              _text.text = AssetRegistry.Strings.SPEEDDESC;
              break;
            case 1:
              if (SaveGame.endless)
              {
                _text.text = AssetRegistry.Strings.TIMEDESC;
              }
              else
              {
                _text.text = AssetRegistry.Strings.SLOWERDESC;
              }
              break;
            case 2:
              _text.text = AssetRegistry.Strings.NOROTTENDESC;
              break;
          }
          removeChild(question);
          removeChild(_infoButtonQ)
          addChild(infoDisplay);
          //addChild(_scrollable);
          addChild(_scroller);
          _scrollable.addChild(_text);
          addChild(xButton);
          addChild(_infoButtonX);
        
        });
    
    }
    
    private function addToggle():void
    {
      
      _arcadeModiToggleSwitch = new ToggleSwitch();
      _arcadeModiToggleSwitch.width = 400;
      
      _arcadeModiToggleSwitch.offText = AssetRegistry.Strings.OFFLABEL;
      _arcadeModiToggleSwitch.onText = AssetRegistry.Strings.ONLABEL;
      //_arcadeModiToggleSwitch.offLabelProperties = 
      _arcadeModiToggleSwitch.isSelected = SaveGame.endless;
      _arcadeModiToggleSwitch.x = (Starling.current.stage.stageWidth - _arcadeModiToggleSwitch.width) / 2;
      _arcadeModiToggleSwitch.y = _greybox.y + 350;
      
      _arcadeModiToggleSwitch.onChange.add(function(tswitch:ToggleSwitch):void
        {
          SaveGame.endless = tswitch.isSelected;
          unflatten();
          if (SaveGame.endless)
          {
            _buttons[4][0].upState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-time");
            _buttons[4][0].downState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-time");
            _buttons[4][1].text = AssetRegistry.Strings.TIMEDESC;
          }
          else
          {
            _buttons[4][0].upState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-slower");
            _buttons[4][0].downState = AssetRegistry.MenuAtlasOpaque.getTexture("combo-slower");
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
      play.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void
        {
          dispatchEventWith(ManagedStage.SWITCHING, true, {stage: ArcadeState});
        });
      
      var leaderboards:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      leaderboards.label = AssetRegistry.Strings.LEADERBOARDS;
      leaderboards.height = 80;
      leaderboards.width = 250;
      leaderboards.x = play.x + play.width + 10;
      leaderboards.y = 540;
      addChild(leaderboards);
      leaderboards.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void
        {
          dispatchEventWith(ManagedStage.SWITCHING, true, {stage: LevelScore});
        });
      
      var back:org.josht.starling.foxhole.controls.Button = new org.josht.starling.foxhole.controls.Button();
      back.label = AssetRegistry.Strings.BACKBUTTON;
      back.height = 80;
      back.width = 220;
      back.x = leaderboards.x + leaderboards.width + 10;
      back.y = 540;
      addChild(back);
      back.onRelease.add(function(button:org.josht.starling.foxhole.controls.Button):void
        {
          dispatchEventWith(ManagedStage.SWITCHING, true, {stage: MainMenu});
        });
    
    }
    
    private function addNormalCombos():void
    {
      var buttons:Array;
      if (SaveGame.endless)
      {
        buttons = [AssetRegistry.MenuAtlasOpaque.getTexture("combo-speed"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-time"), AssetRegistry.MenuAtlasOpaque.getTexture("combo-rotteneggs")] //, [AssetRegistry.MenuAtlasOpaque.getTexture("combo-shuffle"), AssetRegistry.MenuAtlasOpaque.getTexture("info-shuffle")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-gold"), AssetRegistry.MenuAtlasOpaque.getTexture("info-gold")], [AssetRegistry.MenuAtlasOpaque.getTexture("combo-xtralife"), AssetRegistry.MenuAtlasOpaque.getTexture("info-xtralife")]];
      }
      else
      {
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
