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
    private static const LEADERBOARDS:String = "Leaderboards";
    private static const SELECTCOMBOTWO:String = "SelectComboTwo";
    private static const INFOTEXT:String = "InfoText";
    private static const NORMALCOMBOS:String = "NormalCombos";
    
    private var _navigator:ScreenNavigator;
    private var _transitionManager:ScreenSlidingStackTransitionManager;
    private var _sharedData:Object = { };
    
    public function ComboMenu()
    {
      super();

      AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE]);
         
      var bg:Image = new Image(AssetRegistry.MenuAtlasOpaque.getTexture("arcade-background_iphone4"));
      addChild(bg);
      
      _navigator = new ScreenNavigator();
      _transitionManager = new ScreenSlidingStackTransitionManager(_navigator);      
      addChild(_navigator);
      
      _navigator.addScreen(BASEMENU, new ScreenNavigatorItem(MainComboMenu, {
        onComboSelect:SELECTCOMBO,
        onLeaderboards:LEADERBOARDS,
        onInfoText:INFOTEXT,
        onNormalCombos:NORMALCOMBOS
      }, {
        sharedData: this._sharedData
      }));
      
      var _leaderboardScreen:Leaderboards = new Leaderboards({lid:"5041f594563d8a570c0024a4"});
      _navigator.addScreen(LEADERBOARDS, new ScreenNavigatorItem(_leaderboardScreen, {
        onLeaderboards:BASEMENU 
      }, {
        sharedData: this._sharedData
      }));
      
      _navigator.addScreen(SELECTCOMBO, new ScreenNavigatorItem(ComboSelect, {
        onMainComboMenu:BASEMENU
      }, {
        sharedData: this._sharedData
      }));
      
      _navigator.addScreen(INFOTEXT, new ScreenNavigatorItem(InfoText, {
        onInfoText:BASEMENU
      }, {
        sharedData: this._sharedData
      }));
      
      _navigator.addScreen(NORMALCOMBOS, new ScreenNavigatorItem(NormalCombos, {
        onNormalCombos:BASEMENU
      }, {
        sharedData: this._sharedData
      }));
            
      _navigator.showScreen(BASEMENU);
      
      /*_navigator.addScreen(LEADERBOARDS, new ScreenNavigatorItem(Leaderboards, {
        onMainComboMenu:BASEMENU
      }, {
        sharedData: {navigator: this._navigator, screen: LEADERBOARDS}
      }));*/
            
      _leaderboardScreen.dispatchEventWith(Leaderboards.REFRESH_LEADERBOARD);
    }
    
    override public function dispose():void {
      super.dispose();
    }
  
  }

}