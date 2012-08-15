package Menu.ComboMenuScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import engine.AssetRegistry;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.events.TouchEvent;
  import starling.text.TextField;
  import starling.utils.Color;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
  import engine.SaveGame;
  import org.josht.starling.foxhole.controls.Scroller;
  import starling.utils.HAlign;
  import starling.utils.VAlign;
  import org.josht.starling.foxhole.controls.ScrollBar;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class ComboSelect extends Screen
  {
    protected var _onMainComboMenu:Signal = new Signal(ComboSelect);
    protected var _sharedData:Object = { };
    protected var _scroller:Scroller;
    protected var _scrollable:Sprite;
	protected var _selComboHeading:TextField;
    
    public function ComboSelect()
    {
      super();
    }
    
    override protected function initialize():void {

      _scrollable = new Sprite();
	  
      var greybox:Quad = new Quad(710, 450, Color.BLACK);
      greybox.alpha = 0.3;
      greybox.x = 65 + 60;
      greybox.y = 40 + 30;
      
      addChild(greybox); 
	  
	  _selComboHeading = new TextField(greybox.width, 60, AssetRegistry.Strings.SELECTABLECOMBO, "kroeger 06_65", 60, Color.WHITE);
      _selComboHeading.x = (Starling.current.stage.stageWidth - _selComboHeading.width) / 2;
      _selComboHeading.y = 10;
      addChild(_selComboHeading);
	  
	  var that:ComboSelect = this;
	  
	  var exit:starling.display.Button = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("x"));
      exit.scaleX = exit.scaleY = 2;
      exit.x = Starling.current.stage.stageWidth - exit.width - 20;
      exit.y = 20;
      
      exit.addEventListener(Event.TRIGGERED, function(event:Event):void {
        onMainComboMenu.dispatch(that);
      });
      addChild(exit);
      
      _scroller = new Scroller();
      _scroller.setSize(greybox.width, greybox.height);
      _scroller.x = greybox.x;
      _scroller.y = greybox.y;
      _scroller.viewPort = _scrollable;
      
      addChild(_scroller);
	  
	  
      
     
            
      var time:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-leveluptime"));
      time.x = 40;
      time.y = 40;
      time.addEventListener(Event.TRIGGERED, function(event:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-leveluptime" } );
        onMainComboMenu.dispatch(that);
      });
      _scrollable.addChild(time);
      
      
      var timeText:TextField = new TextField(greybox.width - 120 - time.width, time.height * 1.5, AssetRegistry.Strings.TIMECOMBODESC, "kroeger 06_65", 30, Color.WHITE);
      timeText.hAlign = HAlign.LEFT;
      timeText.vAlign = VAlign.TOP;
      timeText.x = time.x + time.width + 40;
      timeText.y = time.y;
      _scrollable.addChild(timeText);
      
      var chaintime:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-chaintime"));
      chaintime.x = time.x;
      chaintime.y = timeText.y + timeText.height + 20;
      chaintime.addEventListener(Event.TRIGGERED, function(event:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-chaintime" } );
        onMainComboMenu.dispatch(that);
      });      
      _scrollable.addChild(chaintime);
      
      var chaintimeText:TextField = new TextField(timeText.width, timeText.height, AssetRegistry.Strings.CHAINTIMEDESC, "kroeger 06_65", 30, Color.WHITE);
      chaintimeText.hAlign = HAlign.LEFT;
      chaintimeText.vAlign = VAlign.TOP;
      chaintimeText.x = timeText.x;
      chaintimeText.y = chaintime.y;
      _scrollable.addChild(chaintimeText);
      
      var xtraspawn:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-xtraspawn"));
      xtraspawn.x = time.x;
      xtraspawn.y = chaintimeText.y + chaintimeText.height + 20;
      xtraspawn.addEventListener(Event.TRIGGERED, function(event:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-xtraspawn" } );
        onMainComboMenu.dispatch(that);
      });      
      _scrollable.addChild(xtraspawn);      
      
      var xtraspawnText:TextField = new TextField(timeText.width, timeText.height, AssetRegistry.Strings.XTRASPAWNDESC, "kroeger 06_65", 30, Color.WHITE);
      xtraspawnText.hAlign = HAlign.LEFT;
      xtraspawnText.vAlign = VAlign.TOP;
      xtraspawnText.x = timeText.x;
      xtraspawnText.y = xtraspawn.y;
      _scrollable.addChild(xtraspawnText);
      
      var shuffle:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-shuffle"));
      shuffle.x = time.x;
      shuffle.y = xtraspawnText.y + xtraspawnText.height + 20;
      shuffle.addEventListener(Event.TRIGGERED, function(e:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-shuffle" } );
        onMainComboMenu.dispatch(that);
      });
      _scrollable.addChild(shuffle);
      
      var shuffleText:TextField = new TextField(timeText.width, timeText.height + 20, AssetRegistry.Strings.SHUFFLEDESC, "kroeger 06_65", 30, Color.WHITE);
      shuffleText.hAlign = HAlign.LEFT;
      shuffleText.vAlign = VAlign.TOP;
      shuffleText.x = timeText.x;
      shuffleText.y = shuffle.y;
      _scrollable.addChild(shuffleText);
  
      var gold:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-gold"));
      gold.x = time.x;
      gold.y = shuffleText.y + shuffleText.height + 20;
      gold.addEventListener(Event.TRIGGERED, function(e:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-gold" } );
        onMainComboMenu.dispatch(that);
      });
      _scrollable.addChild(gold);
      
       var goldText:TextField = new TextField(timeText.width, timeText.height, AssetRegistry.Strings.GOLDDESC, "kroeger 06_65", 30, Color.WHITE);
      goldText.hAlign = HAlign.LEFT;
      goldText.vAlign = VAlign.TOP;
      goldText.x = timeText.x;
      goldText.y = gold.y;
      _scrollable.addChild(goldText);     
 
      var xtralife:Button = new Button(AssetRegistry.MenuAtlasOpaque.getTexture("combo-xtralife"));
      xtralife.x = time.x;
      xtralife.y = goldText.y + goldText.height + 20;
      xtralife.addEventListener(Event.TRIGGERED, function(e:Event) {
        SaveGame.saveSpecial(sharedData.selected, { effect: "combo-xtralife" } );
        onMainComboMenu.dispatch(that);
      });
      _scrollable.addChild(xtralife);
      
       var xtralifeText:TextField = new TextField(timeText.width, timeText.height, AssetRegistry.Strings.XTRALIFEDESC, "kroeger 06_65", 30, Color.WHITE);
      xtralifeText.hAlign = HAlign.LEFT;
      xtralifeText.vAlign = VAlign.TOP;
      xtralifeText.x = timeText.x;
      xtralifeText.y = xtralife.y;
      _scrollable.addChild(xtralifeText);     
      
      // TODO: There must be a better way to do this.
      var padding:Quad = new Quad(1, 40);
      padding.alpha = 0;
      _scrollable.addChild(padding);
      
      _scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
      
    }
	

    public function get onMainComboMenu():Signal 
    {
        return _onMainComboMenu;
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
