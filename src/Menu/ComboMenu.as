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
	import engine.SaveGame;
	
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
		private var _sharedData:Object = {};
		
		public function ComboMenu()
		{
			super();
			SaveGame.isArcade = true;
			AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE]);
			
			var bg:Image = new Image(AssetRegistry.Opaque_1_Part2_Atlas.getTexture("arcade-background_iphone4"));
			addChild(bg);
			
			_navigator = new ScreenNavigator();
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			addChild(_navigator);
			
			_navigator.addScreen(BASEMENU, new ScreenNavigatorItem(MainComboMenu, {onComboSelect: SELECTCOMBO, onLeaderboards: LEADERBOARDS, onInfoText: INFOTEXT, onNormalCombos: NORMALCOMBOS}, {sharedData: this._sharedData}));
			var lid:String;
			if (SaveGame.endless)
			{
				lid = "5041f5ac563d8a632f001f73";
			}
			else
			{
				lid = "5041f594563d8a570c0024a4";
			}
			var _leaderboardScreen:Leaderboards = new Leaderboards( { lid: lid } );
      _sharedData["leaderBoardScreen"] = _leaderboardScreen;
			_navigator.addScreen(LEADERBOARDS, new ScreenNavigatorItem(_leaderboardScreen, {onLeaderboards: BASEMENU}, {sharedData: this._sharedData}));
			
			_navigator.addScreen(SELECTCOMBO, new ScreenNavigatorItem(ComboSelect, {onMainComboMenu: BASEMENU}, {sharedData: this._sharedData}));
			
			_navigator.addScreen(INFOTEXT, new ScreenNavigatorItem(InfoText, {onInfoText: BASEMENU}, {sharedData: this._sharedData}));
			
			_navigator.addScreen(NORMALCOMBOS, new ScreenNavigatorItem(NormalCombos, {onNormalCombos: BASEMENU}, {sharedData: this._sharedData}));
			
			_navigator.showScreen(BASEMENU);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	
	}

}