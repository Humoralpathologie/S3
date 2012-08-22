package org.josht.starling.foxhole.themes
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import org.josht.starling.display.Image;
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.Callout;
	import org.josht.starling.foxhole.controls.Check;
	import org.josht.starling.foxhole.controls.GroupedList;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.PickerList;
	import org.josht.starling.foxhole.controls.ProgressBar;
	import org.josht.starling.foxhole.controls.Radio;
	import org.josht.starling.foxhole.controls.ScreenHeader;
	import org.josht.starling.foxhole.controls.Slider;
	import org.josht.starling.foxhole.controls.TextInput;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import org.josht.starling.foxhole.controls.popups.CalloutPopUpContentManager;
	import org.josht.starling.foxhole.controls.popups.VerticalCenteredPopUpContentManager;
	import org.josht.starling.foxhole.controls.renderers.BaseDefaultItemRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListItemRenderer;
	import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
	import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
	import org.josht.starling.foxhole.core.AddedWatcher;
	import org.josht.starling.foxhole.layout.VerticalLayout;
	import org.josht.starling.foxhole.skins.ImageStateValueSelector;
	import org.josht.starling.foxhole.skins.Scale9ImageStateValueSelector;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.textures.Scale9Textures;
	import org.josht.system.PhysicalCapabilities;
	import org.josht.utils.math.roundToNearest;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.BitmapFont;
  import starling.text.TextField;  
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	public class MinimalTheme extends AddedWatcher implements IFoxholeTheme
	{
		[Embed(source="/../assets/images/minimal.png")]
		protected static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/minimal.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

		protected static const ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ATLAS_IMAGE(), false), XML(new ATLAS_XML()));

		protected static const SCALE_9_GRID:Rectangle = new Rectangle(9, 9, 2, 2);
		protected static const SCROLLBAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 1, 2, 2);
		protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(25, 25, 2, 2);
		protected static const CHECK_SCALE_9_GRID:Rectangle = new Rectangle(13, 13, 2, 2);

		protected static const BACKGROUND_COLOR:uint = 0xf3f3f3;
		protected static const PRIMARY_TEXT_COLOR:uint = 0xbbbbbb;
		protected static const SELECTED_TEXT_COLOR:uint = 0xffffff;
		protected static const INSET_TEXT_COLOR:uint = 0xbbbbbb;

		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;

		protected static const TOOLBAR_BUTTON_UP_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("toolbar-button-up-skin"), SCALE_9_GRID);
		protected static const TOOLBAR_BUTTON_DOWN_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("toolbar-button-down-skin"), SCALE_9_GRID);
		protected static const TOOLBAR_BUTTON_SELECTED_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("toolbar-button-selected-skin"), SCALE_9_GRID);

		protected static const BUTTON_UP_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("button-up-skin"), SCALE_9_GRID);
		protected static const BUTTON_DOWN_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("button-down-skin"), SCALE_9_GRID);
		protected static const BUTTON_DISABLED_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("button-disabled-skin"), SCALE_9_GRID);
		protected static const BUTTON_SELECTED_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("button-selected-skin"), SCALE_9_GRID);

		protected static const TAB_UP_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("tab-up-skin"), SCALE_9_GRID);
		protected static const TAB_DOWN_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("tab-down-skin"), TAB_SCALE_9_GRID);
		protected static const TAB_SELECTED_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("tab-selected-skin"), TAB_SCALE_9_GRID);

		protected static const THUMB_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("thumb-skin"), SCALE_9_GRID);

		protected static const SCROLL_BAR_THUMB_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("scrollbar-thumb-skin"), SCROLLBAR_THUMB_SCALE_9_GRID);

		protected static const INSET_BACKGROUND_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("inset-background-skin"), SCALE_9_GRID);
		protected static const INSET_BACKGROUND_DISABLED_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("inset-background-disabled-skin"), SCALE_9_GRID);

		protected static const DROP_DOWN_ARROW_TEXTURE:Texture = ATLAS.getTexture("drop-down-arrow");

		protected static const LIST_ITEM_UP_TEXTURE:Texture = ATLAS.getTexture("list-item-up");
		protected static const LIST_ITEM_DOWN_TEXTURE:Texture = ATLAS.getTexture("list-item-down");
		protected static const LIST_ITEM_SELECTED_TEXTURE:Texture = ATLAS.getTexture("list-item-selected");

		protected static const HEADER_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("header-skin"), SCALE_9_GRID);

		protected static const POPUP_BACKGROUND_SKIN_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("callout-background-skin"), SCALE_9_GRID);
		protected static const CALLOUT_TOP_ARROW_SKIN_TEXTURE:Texture = ATLAS.getTexture("callout-arrow-top");
		protected static const CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE:Texture = ATLAS.getTexture("callout-arrow-bottom");
		protected static const CALLOUT_LEFT_ARROW_SKIN_TEXTURE:Texture = ATLAS.getTexture("callout-arrow-left");
		protected static const CALLOUT_RIGHT_ARROW_SKIN_TEXTURE:Texture = ATLAS.getTexture("callout-arrow-right");

		protected static const CHECK_SELECTED_ICON_TEXTURES:Scale9Textures = new Scale9Textures(ATLAS.getTexture("check-selected-icon"), CHECK_SCALE_9_GRID);

		protected static const RADIO_ICON_TEXTURE:Texture = ATLAS.getTexture("radio-icon");
		protected static const RADIO_SELECTED_ICON_TEXTURE:Texture = ATLAS.getTexture("radio-selected-icon");

		[Embed(source="/../assets/fonts/pf_ronda_seven.fnt",mimeType="application/octet-stream")]
		protected static const ATLAS_FONT_XML:Class;

		//protected static const BITMAP_FONT:BitmapFont = new BitmapFont(ATLAS.getTexture("pf_ronda_seven_0"), XML(new ATLAS_FONT_XML()));
    protected static const BITMAP_FONT:BitmapFont = TextField.getBitmapFont("kroeger 06_65");

		public function MinimalTheme(root:DisplayObject, scaleToDPI:Boolean = true)
		{
			super(root);
			Starling.current.nativeStage.color = BACKGROUND_COLOR;
			if(root.stage)
			{
				root.stage.color = BACKGROUND_COLOR;
			}
			else
			{
				root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			this._scaleToDPI = scaleToDPI;
			this.initialize();
		}

		protected var _originalDPI:int;

		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		protected var _scaleToDPI:Boolean;

		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}

		protected var _scale:Number;
		protected var _fontSize:int;

		protected function initialize():void
		{
			if(this._scaleToDPI)
			{
				//special case for ipad. should be same pixel size as iphone
				if(Capabilities.screenDPI % (ORIGINAL_DPI_IPAD_RETINA / 2) == 0)
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			else
			{
				this._originalDPI = Capabilities.screenDPI;
			}
			//our min scale is 0.25 because lines in the graphics are four
			//pixels wide and this will keep them crisp.
			this._scale = Math.max(0.25, Capabilities.screenDPI / this._originalDPI);

			//since it's a pixel font, we want a multiple of the original size,
			//which, in this case, is 8.
			//this._fontSize = Math.max(4, roundToNearest(24 * this._scale, 8));
      _fontSize = 30;//28;

			this.setInitializerForClass(BitmapFontTextRenderer, labelInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, sliderThumbInitializer, "foxhole-slider-thumb");
			this.setInitializerForClass(Button, simpleScrollBarThumbInitializer, "foxhole-simple-scroll-bar-thumb");
			this.setInitializerForClass(Button, sliderThumbInitializer, "foxhole-slider-thumb");
			this.setInitializerForClass(Button, nothingInitializer, "foxhole-slider-minimum-track");
			this.setInitializerForClass(Button, nothingInitializer, "foxhole-slider-maximum-track");
			this.setInitializerForClass(Button, toggleSwitchOnTrackInitializer, "foxhole-toggle-switch-on-track");
			this.setInitializerForClass(Button, toggleSwitchThumbInitializer, "foxhole-toggle-switch-thumb");
			this.setInitializerForClass(Button, tabInitializer, "foxhole-tabbar-tab");
			this.setInitializerForClass(Button, toolBarButtonInitializer, "foxhole-header-item");
			this.setInitializerForClass(Button, pickerListButtonInitializer, "foxhole-picker-list-button");
			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(Check, checkInitializer);
			this.setInitializerForClass(Radio, radioInitializer);
			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerOrFooterRendererInitializer);
			this.setInitializerForClass(List, listInitializer);
			this.setInitializerForClass(List, nothingInitializer, "foxhole-picker-list-list");
			this.setInitializerForClass(GroupedList, groupedListInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
			this.setInitializerForClass(ScreenHeader, screenHeaderInitializer);
			this.setInitializerForClass(TextInput, textInputInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(Callout, calloutInitializer);
		}

		protected function nothingInitializer(target:DisplayObject):void
		{
			//if this is assigned as an initializer, chances are the target will
			//be a subcomponent of something. the initializer for this
			//component's parent is probably handing the initializing for the
			//target too.
		}

		protected function labelInitializer(label:BitmapFontTextRenderer):void
		{
			label.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			//since it's a pixel font, we don't want to smooth it.
			label.smoothing = TextureSmoothing.NONE;
		}

		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = BUTTON_UP_SKIN_TEXTURES;
			skinSelector.defaultSelectedValue = BUTTON_SELECTED_SKIN_TEXTURES;
			skinSelector.setValueForState(BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, false);
			skinSelector.setValueForState(BUTTON_DISABLED_SKIN_TEXTURES, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, true);
			skinSelector.imageProperties =
			{
				width: 66 * this._scale,
				height: 66 * this._scale,
				textureScale: this._scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);//PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

			button.paddingTop = button.paddingBottom = 8 * this._scale;
			button.paddingLeft = button.paddingRight = 16 * this._scale;
			button.gap = 12 * this._scale;
			button.minWidth = 66 * this._scale;
			button.minHeight = 66 * this._scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this._scale;
		}

		protected function toolBarButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = TOOLBAR_BUTTON_UP_SKIN_TEXTURES;
			skinSelector.defaultSelectedValue = TOOLBAR_BUTTON_SELECTED_SKIN_TEXTURES;
			skinSelector.setValueForState(TOOLBAR_BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, false);
			skinSelector.setValueForState(TOOLBAR_BUTTON_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, true);
			skinSelector.imageProperties =
			{
				width: 60 * this._scale,
				height: 60 * this._scale,
				textureScale: this._scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

			button.paddingTop = button.paddingBottom = 8 * this._scale;
			button.paddingLeft = button.paddingRight = 16 * this._scale;
			button.gap = 12 * this._scale;
			button.minWidth = button.minHeight = 60 * this._scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this._scale;
		}

		protected function tabInitializer(tab:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = TAB_UP_SKIN_TEXTURES;
			skinSelector.defaultSelectedValue = TAB_SELECTED_SKIN_TEXTURES;
			skinSelector.setValueForState(TAB_DOWN_SKIN_TEXTURES, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this._scale,
				height: 88 * this._scale,
				textureScale: this._scale
			};
			tab.stateToSkinFunction = skinSelector.updateValue;

			tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			tab.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

			tab.iconPosition = Button.ICON_POSITION_TOP;
			tab.paddingTop = tab.paddingRight = tab.paddingBottom =
				tab.paddingLeft = 28 * this._scale;
			tab.gap = 12 * this._scale;
			tab.minWidth = tab.minHeight = 88 * this._scale;
			tab.minTouchWidth = tab.minTouchHeight = 88 * this._scale;
		}

		protected function simpleScrollBarThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(SCROLL_BAR_THUMB_SKIN_TEXTURES, this._scale);
			defaultSkin.width = 8 * this._scale;
			defaultSkin.height = 8 * this._scale;
			thumb.defaultSkin = defaultSkin;

			thumb.minTouchWidth = thumb.minTouchHeight = 12 * this._scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			const sliderTrackDefaultSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				sliderTrackDefaultSkin.width = 66 * this._scale;
				sliderTrackDefaultSkin.height = 198 * this._scale;
			}
			else //horizontal
			{
				sliderTrackDefaultSkin.width = 198 * this._scale;
				sliderTrackDefaultSkin.height = 66 * this._scale;
			}
			slider.minimumTrackProperties.defaultSkin = sliderTrackDefaultSkin;
		}

		protected function sliderThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(THUMB_SKIN_TEXTURES, this._scale);
			defaultSkin.width = 66 * this._scale;
			defaultSkin.height = 66 * this._scale;
			thumb.defaultSkin = defaultSkin;

			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this._scale;
		}

		protected function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			toggleSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

			toggleSwitch.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			toggleSwitch.onLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
		}

		protected function toggleSwitchOnTrackInitializer(track:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			defaultSkin.width = 148 * this._scale;
			defaultSkin.height = 66 * this._scale;
			track.defaultSkin = defaultSkin;
			track.minTouchWidth = track.minTouchHeight = 88 * this._scale;
		}

		protected function toggleSwitchThumbInitializer(thumb:Button):void
		{
			const defaultSkin:Scale9Image = new Scale9Image(THUMB_SKIN_TEXTURES, this._scale);
			defaultSkin.width = 66 * this._scale;
			defaultSkin.height = 66 * this._scale;
			thumb.defaultSkin = defaultSkin;
			thumb.minTouchWidth = thumb.minTouchHeight = 88 * this._scale;
		}

		protected function checkInitializer(check:Check):void
		{
			const iconSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			iconSelector.defaultValue = INSET_BACKGROUND_SKIN_TEXTURES;
			iconSelector.defaultSelectedValue = CHECK_SELECTED_ICON_TEXTURES;
			iconSelector.imageProperties =
			{
				width: 40 * this._scale,
				height: 40 * this._scale,
				textureScale: this._scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			check.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

			check.minTouchWidth = check.minTouchHeight = 88 * this._scale;
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function radioInitializer(radio:Radio):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = RADIO_ICON_TEXTURE;
			iconSelector.defaultSelectedValue = RADIO_SELECTED_ICON_TEXTURE;
			iconSelector.imageProperties =
			{
				scaleX: this._scale,
				scaleY: this._scale,
				textureScale: this._scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			radio.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

			radio.minTouchWidth = radio.minTouchHeight = 88 * this._scale;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = LIST_ITEM_UP_TEXTURE;
			skinSelector.defaultSelectedValue = LIST_ITEM_SELECTED_TEXTURE;
			skinSelector.setValueForState(LIST_ITEM_DOWN_TEXTURE, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this._scale,
				height: 88 * this._scale,
				smoothing: TextureSmoothing.NONE
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.paddingTop = renderer.paddingBottom = 11 * this._scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this._scale;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.minWidth = renderer.minHeight = 88 * this._scale;
		}

		protected function headerOrFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{
			const backgroundSkin:Image = new Image(LIST_ITEM_DOWN_TEXTURE);
			backgroundSkin.smoothing = TextureSmoothing.NONE;
			backgroundSkin.width = 44 * this._scale;
			backgroundSkin.height = 44 * this._scale;
			renderer.backgroundSkin = backgroundSkin;

			renderer.paddingTop = renderer.paddingBottom = 6 * this._scale;
			renderer.paddingLeft = renderer.paddingRight = 16 * this._scale;
			renderer.minWidth = renderer.minHeight = 44 * this._scale;
		}

		protected function listInitializer(list:List):void
		{
			const backgroundSkin:Image = new Image(LIST_ITEM_UP_TEXTURE);
			backgroundSkin.scaleX = backgroundSkin.scaleY = this._scale;
			backgroundSkin.smoothing = TextureSmoothing.NONE;
			list.backgroundSkin = backgroundSkin;
		}

		protected function groupedListInitializer(list:GroupedList):void
		{
			const backgroundSkin:Image = new Image(LIST_ITEM_UP_TEXTURE);
			backgroundSkin.scaleX = backgroundSkin.scaleY = this._scale;
			backgroundSkin.smoothing = TextureSmoothing.NONE;
			list.backgroundSkin = backgroundSkin;
		}

		protected function pickerListInitializer(list:PickerList):void
		{
			if(PhysicalCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.popUpContentManager = new CalloutPopUpContentManager();
			}
			else
			{
				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
					centerStage.marginLeft = 16 * this._scale;
				list.popUpContentManager = centerStage;
			}

			const layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.useVirtualLayout = true;
			layout.gap = 0;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			list.listProperties.layout = layout;

			if(PhysicalCapabilities.isTablet(Starling.current.nativeStage))
			{
				list.listProperties.minWidth = 10 * this._scale;
				list.listProperties.maxHeight = 352 * this._scale;
			}
			else
			{
				const backgroundSkin:Scale9Image = new Scale9Image(POPUP_BACKGROUND_SKIN_TEXTURES, this._scale);
				backgroundSkin.width = 20 * this._scale;
				backgroundSkin.height = 20 * this._scale;
				list.listProperties.backgroundSkin = backgroundSkin;
				list.listProperties.paddingTop = list.listProperties.paddingRight =
					list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this._scale;
			}
		}

		protected function pickerListButtonInitializer(button:Button):void
		{
			//we're going to expand on the standard button styles
			this.buttonInitializer(button);

			const defaultIcon:Image = new Image(DROP_DOWN_ARROW_TEXTURE);
			defaultIcon.scaleX = defaultIcon.scaleY = this._scale;
			button.defaultIcon = defaultIcon;
			button.gap = Number.POSITIVE_INFINITY, //fill as completely as possible
				button.iconPosition = Button.ICON_POSITION_RIGHT;
			button.horizontalAlign =  Button.HORIZONTAL_ALIGN_LEFT;
		}

		protected function screenHeaderInitializer(header:ScreenHeader):void
		{
			header.minWidth = 88 * this._scale;
			header.minHeight = 88 * this._scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 14 * this._scale;
			const backgroundSkin:Scale9Image = new Scale9Image(HEADER_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = 88 * this._scale;
			backgroundSkin.height = 88 * this._scale;
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
		}

		protected function textInputInitializer(input:TextInput):void
		{
			input.minWidth = input.minHeight = 66 * this._scale;
			input.minTouchWidth = input.minTouchHeight = 66 * this._scale;
			input.paddingTop = input.paddingBottom = 14 * this._scale;
			input.paddingLeft = input.paddingRight = 16 * this._scale;
			input.stageTextProperties.fontFamily = "Helvetica";
			input.stageTextProperties.fontSize = 30 * this._scale;
			input.stageTextProperties.color = INSET_TEXT_COLOR;

			const backgroundSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = 264 * this._scale;
			backgroundSkin.height = 66 * this._scale;
			input.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_DISABLED_SKIN_TEXTURES, this._scale);
			backgroundDisabledSkin.width = 264 * this._scale;
			backgroundDisabledSkin.height = 66 * this._scale;
			input.backgroundDisabledSkin = backgroundDisabledSkin;
		}

		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 22) * this._scale;
			backgroundSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 22 : 264) * this._scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_DISABLED_SKIN_TEXTURES, this._scale);
			backgroundDisabledSkin.width = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 264 : 22) * this._scale;
			backgroundDisabledSkin.height = (progress.direction == ProgressBar.DIRECTION_HORIZONTAL ? 22 : 264) * this._scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale9Image = new Scale9Image(BUTTON_UP_SKIN_TEXTURES, this._scale);
			fillSkin.width = 12 * this._scale;
			fillSkin.height = 12 * this._scale;
			progress.fillSkin = fillSkin;

			const fillDisabledSkin:Scale9Image = new Scale9Image(BUTTON_DISABLED_SKIN_TEXTURES, this._scale);
			fillDisabledSkin.width = 12 * this._scale;
			fillDisabledSkin.height = 12 * this._scale;
			progress.fillDisabledSkin = fillDisabledSkin;
		}

		protected function calloutInitializer(callout:Callout):void
		{
			callout.minWidth = 20 * this._scale;
			callout.minHeight = 20 * this._scale;
			callout.paddingTop = callout.paddingRight = callout.paddingBottom =
				callout.paddingLeft = 8 * this._scale;
			const backgroundSkin:Scale9Image = new Scale9Image(POPUP_BACKGROUND_SKIN_TEXTURES, this._scale);
			backgroundSkin.width = 20 * this._scale;
			backgroundSkin.height = 20 * this._scale;
			callout.backgroundSkin = backgroundSkin;

			const topArrowSkin:Image = new Image(CALLOUT_TOP_ARROW_SKIN_TEXTURE);
			topArrowSkin.scaleX = topArrowSkin.scaleY = this._scale;
			callout.topArrowSkin = topArrowSkin;
			callout.topArrowGap = -4 * this._scale;

			const bottomArrowSkin:Image = new Image(CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE);
			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this._scale;
			callout.bottomArrowSkin = bottomArrowSkin;
			callout.bottomArrowGap = -4 * this._scale;

			const leftArrowSkin:Image = new Image(CALLOUT_LEFT_ARROW_SKIN_TEXTURE);
			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this._scale;
			callout.leftArrowSkin = leftArrowSkin;
			callout.leftArrowGap = -4 * this._scale;

			const rightArrowSkin:Image = new Image(CALLOUT_RIGHT_ARROW_SKIN_TEXTURE);
			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this._scale;
			callout.rightArrowSkin = rightArrowSkin;
			callout.rightArrowGap = -4 * this._scale;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
		}
	}
}