package Menu
{
  import engine.ManagedStage;
  import Menu.ComboMenuScreens.MainComboMenu;
  import org.josht.starling.foxhole.controls.ScreenNavigator;
  import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
  import Menu.ComboMenuScreens.*;
  import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
  import starling.display.Image;
  import engine.AssetRegistry;
  
  /**
   * ...
   * @author
   */
  public class ComboMenu extends ManagedStage
  {
    
    private static const BASEMENU:String = "Base";
    private static const SELECTCOMBO:String = "SelectCombo";
    private static const SELECTCOMBOTWO:String = "SelectComboTwo";
    
    private var _navigator:ScreenNavigator;
    private var _transitionManager:ScreenSlidingStackTransitionManager;
    private var _sharedData:Object = { };
    
    public function ComboMenu()
    {
      super();

      AssetRegistry.loadGraphics([AssetRegistry.MENU]);
         
      var bg:Image = new Image(AssetRegistry.MenuAtlas.getTexture("arcade-background_iphone4"));
      addChild(bg);
      
      _navigator = new ScreenNavigator();
      _transitionManager = new ScreenSlidingStackTransitionManager(_navigator);      
      addChild(_navigator);
      
      _navigator.addScreen(BASEMENU, new ScreenNavigatorItem(MainComboMenu, {
        onComboSelect:SELECTCOMBO
      }, {
        sharedData: this._sharedData
      }));
      
      _navigator.addScreen(SELECTCOMBO, new ScreenNavigatorItem(ComboSelect, {
        onComboSelectTwo:SELECTCOMBOTWO,
        onMainComboMenu:BASEMENU
      }, {
        sharedData: this._sharedData
      }));
      
      _navigator.addScreen(SELECTCOMBOTWO, new ScreenNavigatorItem(ComboSelectTwo, {
        onComboSelect:SELECTCOMBO,
        onMainComboMenu:BASEMENU
      }, {
        sharedData: this._sharedData       
      }));
      
      _navigator.showScreen(BASEMENU);
      
    }
    
    override public function dispose():void {
      super.dispose();
    }
  
  }

}