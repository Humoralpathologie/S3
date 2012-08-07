/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Below is a list of certain publicly available software that is the source of
intellectual property in this class, along with the licensing terms that pertain
to those sources of IP.

The velocity and throwing physics calculations are loosely based on code from
the TouchScrolling library by Pavel fljot.
Copyright (c) 2011 Pavel fljot
License: Same as above.
Source: https://github.com/fljot/TouchScrolling
*/
package org.josht.starling.foxhole.controls
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;

	import flash.events.MouseEvent;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.getTimer;

	import org.josht.starling.display.ScrollRectManager;
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.controls.supportClasses.IViewPort;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PropertyProxy;
	import org.josht.starling.motion.GTween;
	import org.josht.utils.math.clamp;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Allows horizontal and vertical scrolling of a viewport (which may be any
	 * Starling display object).
	 *
	 * <p>Will react to the <code>onResize</code> signal dispatched by Foxhole
	 * controls to adjust the maximum scroll positions. For regular Starling
	 * display objects, the <code>invalidate()</code> function needs to be
	 * called on the <code>Scroller</code> when they resize because the
	 * <code>Scroller</code> cannot detect the change.</p>
	 */
	public class Scroller extends FoxholeControl
	{
		/**
		 * @private
		 */
		private static var helperPoint:Point = new Point();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";

		/**
		 * The scroller may scroll, if the view port is larger than the
		 * scroller's bounds.
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * The scroller will always scroll.
		 */
		public static const SCROLL_POLICY_ON:String = "on";
		
		/**
		 * The scroller does not scroll at all.
		 */
		public static const SCROLL_POLICY_OFF:String = "off";
		
		/**
		 * Aligns the viewport to the left, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		
		/**
		 * Aligns the viewport to the center, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		
		/**
		 * Aligns the viewport to the right, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * Aligns the viewport to the top, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * Aligns the viewport to the middle, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * Aligns the viewport to the bottom, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The scroll bars appear above the scroller's view port, and fade out
		 * when not in use.
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * The scroll bars are always visible and appear next to the scroller's
		 * view port, making the view port smaller than the scroller.
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * The user may touch anywhere on the scroller and drag to scroll.
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * The user may interact with the scroll bars to scroll.
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";
		
		/**
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
		
		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/**
		 * @private
		 * The point where we stop calculating velocity changes because floating
		 * point issues can start to appear.
		 */
		private static const MINIMUM_VELOCITY:Number = 0.02;
		
		/**
		 * @private
		 * The friction applied every frame when the scroller is "thrown".
		 */
		private static const FRICTION:Number = 0.998;

		/**
		 * @private
		 * Extra friction applied when the scroller is beyond its bounds and
		 * needs to bounce back.
		 */
		private static const EXTRA_FRICTION:Number = 0.95;

		/**
		 * @private
		 * Older saved velocities are given less importance.
		 */
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[2, 1.66, 1.33, 1];

		/**
		 * @private
		 */
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;

		/**
		 * @private
		 */
		protected static function defaultHorizontalScrollBarFactory():IScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			return scrollBar;
		}

		/**
		 * @private
		 */
		protected static function defaultVerticalScrollBarFactory():IScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			return scrollBar;
		}
		
		/**
		 * Constructor.
		 */
		public function Scroller()
		{
			super();

			this._viewPortWrapper = new Sprite();
			this.addChild(this._viewPortWrapper);

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The horizontal scrollbar instance. May be null.
		 */
		protected var horizontalScrollBar:IScrollBar;

		/**
		 * The vertical scrollbar instance. May be null.
		 */
		protected var verticalScrollBar:IScrollBar;

		/**
		 * @private
		 */
		protected var _horizontalScrollBarHeightOffset:Number;

		/**
		 * @private
		 */
		protected var _verticalScrollBarWidthOffset:Number;

		private var _touchPointID:int = -1;
		private var _startTouchX:Number;
		private var _startTouchY:Number;
		private var _startHorizontalScrollPosition:Number;
		private var _startVerticalScrollPosition:Number;
		private var _currentTouchX:Number;
		private var _currentTouchY:Number;
		private var _previousTouchTime:int;
		private var _previousTouchX:Number;
		private var _previousTouchY:Number;
		private var _velocityX:Number;
		private var _velocityY:Number;
		private var _previousVelocityX:Vector.<Number> = new <Number>[];
		private var _previousVelocityY:Vector.<Number> = new <Number>[];
		
		private var _horizontalAutoScrollTween:GTween;
		private var _verticalAutoScrollTween:GTween;
		private var _isDraggingHorizontally:Boolean = false;
		private var _isDraggingVertically:Boolean = false;

		/**
		 * @private
		 */
		protected var ignoreViewPortResizing:Boolean = false;
		
		private var _viewPortWrapper:Sprite;
		
		/**
		 * @private
		 */
		private var _viewPort:DisplayObject;
		
		/**
		 * The display object displayed and scrolled within the Scroller.
		 */
		public function get viewPort():DisplayObject
		{
			return this._viewPort;
		}
		
		/**
		 * @private
		 */
		public function set viewPort(value:DisplayObject):void
		{
			if(this._viewPort == value)
			{
				return;
			}
			if(this._viewPort)
			{
				if(this._viewPort is FoxholeControl)
				{
					FoxholeControl(this._viewPort).onResize.remove(viewPort_onResize);
				}
				this._viewPortWrapper.removeChild(this._viewPort);
			}
			this._viewPort = value;
			if(this._viewPort)
			{
				if(this._viewPort is FoxholeControl)
				{
					FoxholeControl(this._viewPort).onResize.add(viewPort_onResize);
				}
				this._viewPortWrapper.addChild(this._viewPort);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollBarFactory:Function = defaultHorizontalScrollBarFactory;

		/**
		 * Creates the horizontal scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 */
		public function get horizontalScrollBarFactory():Function
		{
			return this._horizontalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarFactory(value:Function):void
		{
			if(this._horizontalScrollBarFactory == value)
			{
				return;
			}
			this._horizontalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollBarProperties:PropertyProxy = new PropertyProxy(horizontalScrollBarProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the scroller's
		 * horizontal scroll bar instance (if it exists). The scroll bar is an
		 * <code>IScrollBar</code> implementation.
		 *
		 * <p>If the sub-component has its own sub-components, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #horizontalScrollBarFactory
		 */
		public function get horizontalScrollBarProperties():Object
		{
			return this._horizontalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.onChange.remove(horizontalScrollBarProperties_onChange);
			}
			this._horizontalScrollBarProperties = PropertyProxy(value);
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.onChange.add(horizontalScrollBarProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _verticalScrollBarFactory:Function = defaultVerticalScrollBarFactory;

		/**
		 * Creates the vertical scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 */
		public function get verticalScrollBarFactory():Function
		{
			return this._verticalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarFactory(value:Function):void
		{
			if(this._verticalScrollBarFactory == value)
			{
				return;
			}
			this._verticalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		private var _verticalScrollBarProperties:PropertyProxy = new PropertyProxy(verticalScrollBarProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the scroller's
		 * vertical scroll bar instance (if it exists). The scroll bar is an
		 * <code>IScrollBar</code> implementation.
		 *
		 * <p>If the sub-component has its own sub-components, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #verticalScrollBarFactory
		 */
		public function get verticalScrollBarProperties():Object
		{
			return this._verticalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.onChange.remove(verticalScrollBarProperties_onChange);
			}
			this._verticalScrollBarProperties = PropertyProxy(value);
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.onChange.add(verticalScrollBarProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollStep:Number = 1;

		/**
		 * The number of pixels the scroller can be stepped horizontally. Passed
		 * to the horizontal scroll bar, if one exists. Touch scrolling is not
		 * affected by the step value.
		 */
		public function get horizontalScrollStep():Number
		{
			return this._horizontalScrollStep;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollStep(value:Number):void
		{
			if(this._horizontalScrollStep == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//nope
				throw new ArgumentError("horizontalScrollStep cannot be NaN.");
			}
			this._horizontalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * @private
		 */
		private var _horizontalScrollPosition:Number = 0;
		
		/**
		 * The number of pixels the scroller has been scrolled horizontally (on
		 * the x-axis).
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _maxHorizontalScrollPosition:Number = 0;
		
		/**
		 * The maximum number of pixels the scroller may be scrolled
		 * horizontally (on the x-axis). This value is automatically calculated
		 * based on the width of the viewport. The <code>horizontalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the scroller,
		 * it will automatically animate back to the maximum (or minimum, if
		 * below 0).
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}
		
		/**
		 * @private
		 */
		private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll horizontally (on the
		 * x-axis) or not.
		 *
		 * @see #SCROLL_POLICY_AUTO
		 * @see #SCROLL_POLICY_ON
		 * @see #SCROLL_POLICY_OFF
		 */
		public function get horizontalScrollPolicy():String
		{
			return this._horizontalScrollPolicy;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollPolicy(value:String):void
		{
			if(this._horizontalScrollPolicy == value)
			{
				return;
			}
			this._horizontalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}
		
		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;
		
		/**
		 * If the viewport's width is less than the scroller's width, it will
		 * be aligned to the left, center, or right of the scroller.
		 * 
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _verticalScrollStep:Number = 1;

		/**
		 * The number of pixels the scroller can be stepped vertically. Passed
		 * to the vertical scroll bar, if it exists, and used for scrolling with
		 * the mouse wheel. Touch scrolling is not affected by the step value.
		 */
		public function get verticalScrollStep():Number
		{
			return this._verticalScrollStep;
		}

		/**
		 * @private
		 */
		public function set verticalScrollStep(value:Number):void
		{
			if(this._verticalScrollStep == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//nope
				throw new ArgumentError("verticalScrollStep cannot be NaN.");
			}
			this._verticalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * @private
		 */
		private var _verticalScrollPosition:Number = 0;
		
		/**
		 * The number of pixels the scroller has been scrolled vertically (on
		 * the y-axis).
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("verticalScrollPosition cannot be NaN.");
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _maxVerticalScrollPosition:Number = 0;
		
		/**
		 * The maximum number of pixels the scroller may be scrolled vertically
		 * (on the y-axis). This value is automatically calculated based on the 
		 * height of the viewport. The <code>verticalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the scroller,
		 * it will automatically animate back to the maximum (or minimum, if
		 * below 0).
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll vertically (on the
		 * y-axis) or not.
		 *
		 * @see #SCROLL_POLICY_AUTO
		 * @see #SCROLL_POLICY_ON
		 * @see #SCROLL_POLICY_OFF
		 */
		public function get verticalScrollPolicy():String
		{
			return this._verticalScrollPolicy;
		}
		
		/**
		 * @private
		 */
		public function set verticalScrollPolicy(value:String):void
		{
			if(this._verticalScrollPolicy == value)
			{
				return;
			}
			this._verticalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}
		
		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		/**
		 * If the viewport's height is less than the scroller's height, it will
		 * be aligned to the top, middle, or bottom of the scroller.
		 * 
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _clipContent:Boolean = true;
		
		/**
		 * If true, the viewport will be clipped to the scroller's bounds. In
		 * other words, anything appearing outside the scroller's bounds will
		 * not be visible.
		 * 
		 * <p>To improve performance, turn off clipping and place other display
		 * objects over the edges of the scroller to hide the content that
		 * bleeds outside of the scroller's bounds.</p>
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}
		
		/**
		 * @private
		 */
		private var _hasElasticEdges:Boolean = true;
		
		/**
		 * Determines if the scrolling can go beyond the edges of the viewport.
		 */
		public function get hasElasticEdges():Boolean
		{
			return this._hasElasticEdges;
		}
		
		/**
		 * @private
		 */
		public function set hasElasticEdges(value:Boolean):void
		{
			this._hasElasticEdges = value;
		}

		/**
		 * @private
		 */
		protected var _scrollBarDisplayMode:String = SCROLL_BAR_DISPLAY_MODE_FLOAT;

		/**
		 * Determines how the scroll bars are displayed.
		 *
		 * @see #SCROLL_BAR_DISPLAY_MODE_FLOAT
		 * @see #SCROLL_BAR_DISPLAY_MODE_FIXED
		 */
		public function get scrollBarDisplayMode():String
		{
			return this._scrollBarDisplayMode;
		}

		/**
		 * @private
		 */
		public function set scrollBarDisplayMode(value:String):void
		{
			if(this._scrollBarDisplayMode == value)
			{
				return;
			}
			this._scrollBarDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _interactionMode:String = INTERACTION_MODE_TOUCH;

		/**
		 * Determines how the user may interact with the scroller.
		 *
		 * @see #INTERACTION_MODE_TOUCH
		 * @see #INTERACTION_MODE_MOUSE
		 */
		public function get interactionMode():String
		{
			return this._interactionMode;
		}

		/**
		 * @private
		 */
		public function set interactionMode(value:String):void
		{
			if(this._interactionMode == value)
			{
				return;
			}
			this._interactionMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalScrollBarHideTween:GTween;

		/**
		 * @private
		 */
		protected var _verticalScrollBarHideTween:GTween;

		/**
		 * @private
		 */
		protected var _hideScrollBarAnimationDuration:Number = 0.2;

		/**
		 * The duration, in seconds, of the animation when a scroll bar fades
		 * out.
		 */
		public function get hideScrollBarAnimationDuration():Number
		{
			return this._hideScrollBarAnimationDuration;
		}

		/**
		 * @private
		 */
		public function set hideScrollBarAnimationDuration(value:Number):void
		{
			this._hideScrollBarAnimationDuration = value;
		}

		/**
		 * @private
		 */
		protected var _throwEase:Function = Cubic.easeOut;

		/**
		 * The easing function used for "throw" animations.
		 */
		public function get throwEase():Function
		{
			return this._throwEase;
		}

		/**
		 * @private
		 */
		public function set throwEase(value:Function):void
		{
			this._throwEase = value;
		}
		
		/**
		 * @private
		 */
		protected var _onScroll:Signal = new Signal(Scroller);
		
		/**
		 * Dispatched when the scroller scrolls in either direction.
		 */
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}

		/**
		 * @private
		 */
		protected var _onDragStart:Signal = new Signal(Scroller);

		/**
		 * Dispatched when a drag has begun that will make the scroller begin
		 * scrolling in either direction.
		 */
		public function get onDragStart():ISignal
		{
			return this._onDragStart;
		}

		/**
		 * @private
		 */
		protected var _onDragEnd:Signal = new Signal(Scroller);

		/**
		 * Dispatched when a drag has ended that will make the scroller end
		 * scrolling in either direction.
		 */
		public function get onDragEnd():ISignal
		{
			return this._onDragEnd;
		}
		
		private var _isScrollingStopped:Boolean = false;
		
		/**
		 * If the user is dragging the scroll, calling stopScrolling() will
		 * cause the scroller to ignore the drag.
		 */
		public function stopScrolling():void
		{
			this._isScrollingStopped = true;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
		}
		
		/**
		 * Throws the scroller to the specified position. If you want to throw
		 * in one direction, pass in NaN or the current scroll position for the
		 * value that you do not want to change.
		 */
		public function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.25):void
		{
			if(!isNaN(targetHorizontalScrollPosition))
			{
				if(this._horizontalAutoScrollTween)
				{
					this._horizontalAutoScrollTween.paused = true;
					this._horizontalAutoScrollTween = null;
				}
				if(this._horizontalScrollPosition != targetHorizontalScrollPosition)
				{
					this._horizontalAutoScrollTween = new GTween(this, duration,
					{
						horizontalScrollPosition: targetHorizontalScrollPosition
					},
					{
						ease: this._throwEase,
						onComplete: horizontalAutoScrollTween_onComplete
					});
				}
				else
				{
					this.finishScrollingHorizontally();
				}
			}
			else
			{
				this.hideHorizontalScrollBar();
			}
			
			if(!isNaN(targetVerticalScrollPosition))
			{
				if(this._verticalAutoScrollTween)
				{
					this._verticalAutoScrollTween.paused = true;
					this._verticalAutoScrollTween = null;
				}
				if(this._verticalScrollPosition != targetVerticalScrollPosition)
				{
					this._verticalAutoScrollTween = new GTween(this, duration,
					{
						verticalScrollPosition: targetVerticalScrollPosition
					},
					{
						ease: this._throwEase,
						onComplete: verticalAutoScrollTween_onComplete
					});
				}
				else
				{
					this.finishScrollingVertically();
				}
			}
			else
			{
				this.hideVerticalScrollBar();
			}
		}

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			//save localX and localY because localPoint could change after the
			//call to super.hitTest().
			const localX:Number = localPoint.x;
			const localY:Number = localPoint.y;
			//first check the children for touches
			var result:DisplayObject = super.hitTest(localPoint, forTouch);
			if(!result)
			{
				//we want to register touches in our hitArea as a last resort
				if(forTouch && (!this.visible || !this.touchable))
				{
					return null;
				}
				return this._hitArea.contains(localX, localY) ? this : null;
			}
			return result;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._onScroll.removeAll();
			this._onDragStart.removeAll();
			this._onDragEnd.removeAll();
			super.dispose();
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this._onScroll.add(internal_onScroll);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = dataInvalid || this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const scrollBarInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);

			if(scrollBarInvalid)
			{
				this.createScrollBars();
			}

			if(scrollBarInvalid || stylesInvalid)
			{
				this.refreshScrollBarStyles();
				this.refreshInteractionModeEvents();
			}

			if(this.horizontalScrollBar is FoxholeControl)
			{
				FoxholeControl(this.horizontalScrollBar).validate();
			}
			if(this.verticalScrollBar is FoxholeControl)
			{
				FoxholeControl(this.verticalScrollBar).validate();
			}

			this.ignoreViewPortResizing = true;
			//even if fixed, we need to measure without them first
			if(sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshViewPortBoundsWithoutFixedScrollBars();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshViewPortBoundsWithFixedScrollBars();
			}
			this.ignoreViewPortResizing = false;
			
			if(sizeInvalid || dataInvalid || scrollBarInvalid)
			{
				//stop animating. this is a serious change.
				if(this._horizontalAutoScrollTween)
				{
					this._horizontalAutoScrollTween.paused = true;
					this._horizontalAutoScrollTween = null;
				}
				if(this._verticalAutoScrollTween)
				{
					this._verticalAutoScrollTween.paused = true;
					this._verticalAutoScrollTween = null;
				}
				this._touchPointID = -1;
				this._velocityX = 0;
				this._velocityY = 0;
				this._previousVelocityX.length = 0;
				this._previousVelocityY.length = 0;
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				this.refreshMaxScrollPositions();
			}

			if(sizeInvalid || scrollInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshScrollBarValues();
			}

			if(sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.layout();
			}
			
			if(sizeInvalid || scrollInvalid || stylesInvalid || scrollBarInvalid || dataInvalid || clippingInvalid)
			{
				this.scrollContent();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._viewPort.width + this._verticalScrollBarWidthOffset;
			}
			if(needsHeight)
			{
				newHeight = this._viewPort.height + this._horizontalScrollBarHeightOffset;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createScrollBars():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.onChange.remove(horizontalScrollBar_onChange);
				DisplayObject(this.horizontalScrollBar).removeFromParent(true);
				this.horizontalScrollBar = null;
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.onChange.remove(verticalScrollBar_onChange);
				DisplayObject(this.verticalScrollBar).removeFromParent(true);
				this.verticalScrollBar = null;
			}

			if(this._horizontalScrollPolicy != SCROLL_POLICY_OFF && this._horizontalScrollBarFactory != null)
			{
				this.horizontalScrollBar = this._horizontalScrollBarFactory();
				this.horizontalScrollBar.onChange.add(horizontalScrollBar_onChange);
				const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
				this.addChild(displayHorizontalScrollBar);
			}
			if(this._verticalScrollPolicy != SCROLL_POLICY_OFF && this._verticalScrollBarFactory != null)
			{
				this.verticalScrollBar = this._verticalScrollBarFactory();
				this.verticalScrollBar.onChange.add(verticalScrollBar_onChange);
				const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
				this.addChild(displayVerticalScrollBar);
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarStyles():void
		{
			if(this.horizontalScrollBar)
			{
				var objectScrollBar:Object = this.horizontalScrollBar;
				for(var propertyName:String in this._horizontalScrollBarProperties)
				{
					if(objectScrollBar.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = this._horizontalScrollBarProperties[propertyName];
						this.horizontalScrollBar[propertyName] = propertyValue;
					}
				}
				if(this._horizontalScrollBarHideTween)
				{
					this._horizontalScrollBarHideTween.paused = true;
					this._horizontalScrollBarHideTween = null;
				}
				const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
				displayHorizontalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
				displayHorizontalScrollBar.touchable = this._interactionMode == INTERACTION_MODE_MOUSE;
			}
			if(this.verticalScrollBar)
			{
				objectScrollBar = this.verticalScrollBar;
				for(propertyName in this._verticalScrollBarProperties)
				{
					if(objectScrollBar.hasOwnProperty(propertyName))
					{
						propertyValue = this._verticalScrollBarProperties[propertyName];
						this.verticalScrollBar[propertyName] = propertyValue;
					}
				}
				if(this._verticalScrollBarHideTween)
				{
					this._verticalScrollBarHideTween.paused = true;
					this._verticalScrollBarHideTween = null;
				}
				const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
				displayVerticalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
				displayVerticalScrollBar.touchable = this._interactionMode == INTERACTION_MODE_MOUSE;
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsWithoutFixedScrollBars():void
		{
			var horizontalScrollBarHeightOffset:Number = 0;
			var verticalScrollBarWidthOffset:Number = 0;
			if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				horizontalScrollBarHeightOffset = this.horizontalScrollBar ? DisplayObject(this.horizontalScrollBar).height : 0;
				verticalScrollBarWidthOffset = this.verticalScrollBar ? DisplayObject(this.verticalScrollBar).width : 0;
			}

			//if scroll bars are fixed, we're going to include the offsets even
			//if they may not be needed in the final pass. if not fixed, the
			//view port fills the entire bounds.
			if(this._viewPort is IViewPort)
			{
				const viewPort:IViewPort = IViewPort(this._viewPort);
				if(isNaN(this.explicitWidth))
				{
					viewPort.visibleWidth = NaN;
				}
				else
				{
					viewPort.visibleWidth = this.explicitWidth - verticalScrollBarWidthOffset;
				}
				if(isNaN(this.explicitHeight))
				{
					viewPort.visibleHeight = NaN;
				}
				else
				{
					viewPort.visibleHeight = this.explicitHeight - horizontalScrollBarHeightOffset;
				}
				viewPort.minVisibleWidth = this._minWidth - verticalScrollBarWidthOffset;
				viewPort.maxVisibleWidth = this._maxWidth - verticalScrollBarWidthOffset;
				viewPort.minVisibleHeight = this._minHeight - horizontalScrollBarHeightOffset;
				viewPort.maxVisibleHeight = this._maxHeight - horizontalScrollBarHeightOffset;
			}

			if(this._viewPort is FoxholeControl)
			{
				FoxholeControl(this._viewPort).validate();
			}

			//in fixed mode, if we determine that scrolling is required, we
			//remember the offsets for later. if scrolling is not needed, then
			//we will ignore the offsets from here forward
			this._horizontalScrollBarHeightOffset = 0;
			this._verticalScrollBarWidthOffset = 0;
			if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				if(this.horizontalScrollBar)
				{
					if(this._horizontalScrollPolicy == SCROLL_POLICY_ON ||
						((this._viewPort.width > this.explicitWidth || this._viewPort.width > this._maxWidth) &&
							this._verticalScrollPolicy != SCROLL_POLICY_OFF))
					{
						this._horizontalScrollBarHeightOffset = horizontalScrollBarHeightOffset;
					}
				}
				if(this.verticalScrollBar)
				{
					if(this._verticalScrollPolicy == SCROLL_POLICY_ON ||
						((this._viewPort.height > this.explicitHeight || this._viewPort.height > this._maxHeight) &&
							this._verticalScrollPolicy != SCROLL_POLICY_OFF))
					{
						this._verticalScrollBarWidthOffset = verticalScrollBarWidthOffset;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsWithFixedScrollBars():void
		{
			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				//if not fixed, ensure that the scroll bars are visible
				if(displayHorizontalScrollBar)
				{
					displayHorizontalScrollBar.visible = true;
				}
				if(displayVerticalScrollBar)
				{
					displayVerticalScrollBar.visible = true;
				}
				//and then we're safe to leave
				return;
			}
			const viewPort:IViewPort = this._viewPort as IViewPort;
			if(displayHorizontalScrollBar)
			{
				displayHorizontalScrollBar.visible = this._horizontalScrollBarHeightOffset > 0;
			}
			if(displayVerticalScrollBar)
			{
				displayVerticalScrollBar.visible = this._verticalScrollBarWidthOffset > 0;
			}

			//we need to make a second pass on the view port to use the offsets
			//and the final actual bounds
			if(viewPort)
			{
				viewPort.visibleWidth = this.actualWidth - this._verticalScrollBarWidthOffset;
				viewPort.visibleHeight = this.actualHeight - this._horizontalScrollBarHeightOffset;
				if(viewPort is FoxholeControl)
				{
					FoxholeControl(viewPort).validate();
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshMaxScrollPositions():void
		{
			if(this._viewPort)
			{
				this._maxHorizontalScrollPosition = Math.max(0, this._viewPort.width + this._verticalScrollBarWidthOffset - this.actualWidth);
				this._maxVerticalScrollPosition = Math.max(0, this._viewPort.height + this._horizontalScrollBarHeightOffset - this.actualHeight);
			}
			else
			{
				this._maxHorizontalScrollPosition = 0;
				this._maxVerticalScrollPosition = 0;
			}
			const oldHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			const oldVerticalScrollPosition:Number = this._verticalScrollPosition;
			this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
			this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
			if(oldHorizontalScrollPosition != this._horizontalScrollPosition ||
				oldVerticalScrollPosition != this._verticalScrollPosition)
			{
				this._onScroll.dispatch(this);
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarValues():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.minimum = 0;
				this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
				this.horizontalScrollBar.value = this._horizontalScrollPosition;
				this.horizontalScrollBar.page = this.actualWidth;
				this.horizontalScrollBar.step = this._horizontalScrollStep;
			}

			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.minimum = 0;
				this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
				this.verticalScrollBar.value = this._verticalScrollPosition;
				this.verticalScrollBar.page = this.actualHeight;
				this.verticalScrollBar.step = this._verticalScrollStep;
			}
		}

		/**
		 * @private
		 */
		protected function refreshInteractionModeEvents():void
		{
			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(this._interactionMode == INTERACTION_MODE_TOUCH)
			{
				this.addEventListener(TouchEvent.TOUCH, touchHandler);
			}
			else
			{
				this.removeEventListener(TouchEvent.TOUCH, touchHandler);
			}

			if(this._interactionMode == INTERACTION_MODE_MOUSE && this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
			{
				if(displayHorizontalScrollBar)
				{
					displayHorizontalScrollBar.addEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(displayVerticalScrollBar)
				{
					displayVerticalScrollBar.addEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
			else
			{
				if(displayHorizontalScrollBar)
				{
					displayHorizontalScrollBar.removeEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(displayVerticalScrollBar)
				{
					displayVerticalScrollBar.removeEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(this.horizontalScrollBar is FoxholeControl)
			{
				FoxholeControl(this.horizontalScrollBar).validate();
			}
			if(this.verticalScrollBar is FoxholeControl)
			{
				FoxholeControl(this.verticalScrollBar).validate();
			}

			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(displayHorizontalScrollBar)
			{
				displayHorizontalScrollBar.x = 0;
				displayHorizontalScrollBar.y = this.actualHeight - displayHorizontalScrollBar.height;
				displayHorizontalScrollBar.width = this.actualWidth;
				if(displayVerticalScrollBar && displayVerticalScrollBar.visible)
				{
					displayHorizontalScrollBar.width -= displayVerticalScrollBar.width;
				}
			}

			if(displayVerticalScrollBar)
			{
				displayVerticalScrollBar.x = this.actualWidth - displayVerticalScrollBar.width;
				displayVerticalScrollBar.y = 0;
				displayVerticalScrollBar.height = this.actualHeight;
				if(displayHorizontalScrollBar && displayHorizontalScrollBar.visible)
				{
					displayVerticalScrollBar.height -= displayHorizontalScrollBar.height;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function scrollContent():void
		{
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			if(this._maxHorizontalScrollPosition == 0)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					offsetX = (this.actualWidth - this._viewPort.width) / 2;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					offsetX = this.actualWidth - this._viewPort.width;
				}
			}
			if(this._maxVerticalScrollPosition == 0)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					offsetY = (this.actualHeight - this._viewPort.height) / 2;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					offsetY = this.actualHeight - this._viewPort.height;
				}
			}
			if(this._clipContent)
			{
				this._viewPortWrapper.x = 0;
				this._viewPortWrapper.y = 0;
				if(!this._viewPortWrapper.scrollRect)
				{
					this._viewPortWrapper.scrollRect = new Rectangle();
				}
				
				const scrollRect:Rectangle = this._viewPortWrapper.scrollRect;
				scrollRect.width = this.actualWidth;
				scrollRect.height = this.actualHeight;
				scrollRect.x = this._horizontalScrollPosition - offsetX;
				scrollRect.y = this._verticalScrollPosition - offsetY;
				this._viewPortWrapper.scrollRect = scrollRect;
			}
			else
			{
				if(this._viewPortWrapper.scrollRect)
				{
					this._viewPortWrapper.scrollRect = null;
				}
				this._viewPortWrapper.x = -this._horizontalScrollPosition + offsetX;
				this._viewPortWrapper.y = -this._verticalScrollPosition + offsetY;
			}
		}
		
		/**
		 * @private
		 */
		protected function updateHorizontalScrollFromTouchPosition(touchX:Number):void
		{
			const offset:Number = this._startTouchX - touchX;
			var position:Number = this._startHorizontalScrollPosition + offset;
			if(position < 0)
			{
				if(this._hasElasticEdges)
				{
					position /= 2;
				}
				else
				{
					position = 0;
				}
			}
			else if(position > this._maxHorizontalScrollPosition)
			{
				if(this._hasElasticEdges)
				{
					position -= (position - this._maxHorizontalScrollPosition) / 2;
				}
				else
				{
					position = this._maxHorizontalScrollPosition;
				}
			}
			
			this.horizontalScrollPosition = position;
		}
		
		/**
		 * @private
		 */
		protected function updateVerticalScrollFromTouchPosition(touchY:Number):void
		{
			const offset:Number = this._startTouchY - touchY;
			var position:Number = this._startVerticalScrollPosition + offset;
			if(position < 0)
			{
				if(this._hasElasticEdges)
				{
					position /= 2;
				}
				else
				{
					position = 0;
				}
			}
			else if(position > this._maxVerticalScrollPosition)
			{
				if(this._hasElasticEdges)
				{
					position -= (position - this._maxVerticalScrollPosition) / 2;
				}
				else
				{
					position = this._maxVerticalScrollPosition;
				}
			}
			
			this.verticalScrollPosition = position;
		}
		
		/**
		 * @private
		 */
		private function finishScrollingHorizontally():void
		{
			var targetHorizontalScrollPosition:Number = NaN;
			if(this._horizontalScrollPosition < 0)
			{
				targetHorizontalScrollPosition = 0;
			}
			else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			
			this._isDraggingHorizontally = false;
			this.throwTo(targetHorizontalScrollPosition, NaN, 0.24);
		}
		
		/**
		 * @private
		 */
		private function finishScrollingVertically():void
		{
			var targetVerticalScrollPosition:Number = NaN;
			if(this._verticalScrollPosition < 0)
			{
				targetVerticalScrollPosition = 0;
			}
			else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			
			this._isDraggingVertically = false;
			this.throwTo(NaN, targetVerticalScrollPosition, 0.24);
		}
		
		/**
		 * @private
		 */
		protected function throwHorizontally(pixelsPerMS:Number):void
		{
			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingHorizontally();
				return;
			}
			var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
			if(targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				var duration:Number = 0;
				targetHorizontalScrollPosition = this._horizontalScrollPosition;
				while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
				{
					targetHorizontalScrollPosition -= pixelsPerMS;
					if(targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						if(this._hasElasticEdges)
						{
							pixelsPerMS *= FRICTION * EXTRA_FRICTION;
						}
						else
						{
							targetHorizontalScrollPosition = clamp(targetHorizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
							duration++;
							break;
						}
					}
					else
					{
						pixelsPerMS *= FRICTION;
					}
					duration++;
				}
			}
			else
			{
				duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
			}
			this.throwTo(targetHorizontalScrollPosition, NaN, duration / 1000);
		}
		
		/**
		 * @private
		 */
		protected function throwVertically(pixelsPerMS:Number):void
		{
			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingVertically();
				return;
			}

			var targetVerticalScrollPosition:Number = this._verticalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
			if(targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition)
			{
				var duration:Number = 0;
				targetVerticalScrollPosition = this._verticalScrollPosition;
				while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
				{
					targetVerticalScrollPosition -= pixelsPerMS;
					if(targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						if(this._hasElasticEdges)
						{
							pixelsPerMS *= FRICTION * EXTRA_FRICTION;
						}
						else
						{
							targetVerticalScrollPosition = clamp(targetVerticalScrollPosition, 0, this._maxVerticalScrollPosition);
							duration++;
							break;
						}
					}
					else
					{
						pixelsPerMS *= FRICTION;
					}
					duration++;
				}
			}
			else
			{
				duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
			}
			this.throwTo(NaN, targetVerticalScrollPosition, duration / 1000);
		}

		/**
		 * @private
		 */
		protected function hideHorizontalScrollBar():void
		{
			if(!this.horizontalScrollBar || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._horizontalScrollBarHideTween)
			{
				return;
			}
			const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
			if(displayHorizontalScrollBar.alpha == 0)
			{
				return;
			}
			this._horizontalScrollBarHideTween = new GTween(this.horizontalScrollBar, this._hideScrollBarAnimationDuration,
			{
				alpha: 0
			},
			{
				ease: Sine.easeOut,
				onComplete: horizontalScrollBarHideTween_onComplete
			});
		}

		/**
		 * @private
		 */
		protected function hideVerticalScrollBar():void
		{
			if(!this.verticalScrollBar || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._verticalScrollBarHideTween)
			{
				return;
			}
			const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
			if(displayVerticalScrollBar.alpha == 0)
			{
				return;
			}
			this._verticalScrollBarHideTween = new GTween(this.verticalScrollBar, this._hideScrollBarAnimationDuration,
			{
				alpha: 0
			},
			{
				ease: Sine.easeOut,
				onComplete: verticalScrollBarHideTween_onComplete
			});
		}

		/**
		 * @private
		 */
		protected function internal_onScroll(scroller:Scroller):void
		{
			this.refreshScrollBarValues();
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBarProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function verticalScrollBarProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_onChange(scrollBar:IScrollBar):void
		{
			this.verticalScrollPosition = scrollBar.value;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_onChange(scrollBar:IScrollBar):void
		{
			this.horizontalScrollPosition = scrollBar.value;
		}
		
		/**
		 * @private
		 */
		protected function viewPort_onResize(viewPort:FoxholeControl):void
		{
			if(this.ignoreViewPortResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function horizontalAutoScrollTween_onComplete(tween:GTween):void
		{
			this._horizontalAutoScrollTween = null;
			this.finishScrollingHorizontally();
		}
		
		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onComplete(tween:GTween):void
		{
			this._verticalAutoScrollTween = null;
			this.finishScrollingVertically();
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBarHideTween_onComplete(tween:GTween):void
		{
			this._horizontalScrollBarHideTween = null;
		}

		/**
		 * @private
		 */
		protected function verticalScrollBarHideTween_onComplete(tween:GTween):void
		{
			this._verticalScrollBarHideTween = null;
		}
		
		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || this._touchPointID >= 0)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch || touch.phase != TouchPhase.BEGAN)
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			if(this._horizontalAutoScrollTween)
			{
				this._horizontalAutoScrollTween.paused = true;
				this._horizontalAutoScrollTween = null
			}
			if(this._verticalAutoScrollTween)
			{
				this._verticalAutoScrollTween.paused = true;
				this._verticalAutoScrollTween = null
			}
			
			this._touchPointID = touch.id;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = location.x;
			this._previousTouchY = this._startTouchY = this._currentTouchY = location.y;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
			this._isDraggingHorizontally = false;
			this._isDraggingVertically = false;
			this._isScrollingStopped = false;

			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			//we need to listen on the stage because if we scroll the bottom or
			//right edge past the top of the scroller, it gets stuck and we stop
			//receiving touch events for "this".
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		}

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			if(this._isScrollingStopped)
			{
				return;
			}
			const now:int = getTimer();
			const timeOffset:int = now - this._previousTouchTime;
			if(timeOffset > 0)
			{
				//we're keeping two velocity updates to improve accuracy
				this._previousVelocityX.unshift(this._velocityX);
				if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityX.pop();
				}
				this._previousVelocityY.unshift(this._velocityY);
				if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityY.pop();
				}
				this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
				this._velocityY = (this._currentTouchY - this._previousTouchY) / timeOffset;
				this._previousTouchTime = now;
				this._previousTouchX = this._currentTouchX;
				this._previousTouchY = this._currentTouchY;
			}
			const horizontalInchesMoved:Number = Math.abs(this._currentTouchX - this._startTouchX) / Capabilities.screenDPI;
			const verticalInchesMoved:Number = Math.abs(this._currentTouchY - this._startTouchY) / Capabilities.screenDPI;
			if((this._horizontalScrollPolicy == SCROLL_POLICY_ON || (this._horizontalScrollPolicy == SCROLL_POLICY_AUTO && this._maxHorizontalScrollPosition > 0)) &&
				!this._isDraggingHorizontally && horizontalInchesMoved >= MINIMUM_DRAG_DISTANCE)
			{
				if(this.horizontalScrollBar)
				{
					if(this._horizontalScrollBarHideTween)
					{
						this._horizontalScrollBarHideTween.paused = true;
						this._horizontalScrollBarHideTween = null;
					}
					if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
					{
						DisplayObject(this.horizontalScrollBar).alpha = 1;
					}
				}
				//if we haven't already started dragging in the other direction,
				//we need to dispatch the signal that says we're starting.
				if(!this._isDraggingVertically)
				{
					this._onDragStart.dispatch(this);
				}
				this._isDraggingHorizontally = true;
			}
			if((this._verticalScrollPolicy == SCROLL_POLICY_ON ||
				(this._verticalScrollPolicy == SCROLL_POLICY_AUTO && this._maxVerticalScrollPosition > 0) ||
				(this._verticalScrollPolicy == SCROLL_POLICY_AUTO && this._maxHorizontalScrollPosition == 0 && this._horizontalScrollPolicy != SCROLL_POLICY_ON)) &&
				!this._isDraggingVertically && verticalInchesMoved >= MINIMUM_DRAG_DISTANCE)
			{
				if(!this._isDraggingHorizontally)
				{
					if(this.verticalScrollBar)
					{
						if(this._verticalScrollBarHideTween)
						{
							this._verticalScrollBarHideTween.paused = true;
							this._verticalScrollBarHideTween = null;
						}
						if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
						{
							DisplayObject(this.verticalScrollBar).alpha = 1;
						}
					}
					this._onDragStart.dispatch(this);
				}
				this._isDraggingVertically = true;
			}
			if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
			{
				this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
			}
			if(this._isDraggingVertically && !this._verticalAutoScrollTween)
			{
				this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
			}
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this.stage);
			if(!touch || (touch.phase != TouchPhase.MOVED && touch.phase != TouchPhase.ENDED) || (this._touchPointID >= 0 && touch.id != this._touchPointID))
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				//we're saving these to use in the enter frame handler because
				//that provides a longer time offset
				const location:Point = touch.getLocation(this);
				this._currentTouchX = location.x;
				this._currentTouchY = location.y;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				this._touchPointID = -1;
				this._onDragEnd.dispatch(this);
				var isFinishingHorizontally:Boolean = false;
				var isFinishingVertically:Boolean = false;
				if(this._horizontalScrollPosition < 0 || this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					isFinishingHorizontally = true;
					this.finishScrollingHorizontally();
				}
				if(this._verticalScrollPosition < 0 || this._verticalScrollPosition > this._maxVerticalScrollPosition)
				{
					isFinishingVertically = true;
					this.finishScrollingVertically();
				}
				if(isFinishingHorizontally && isFinishingVertically)
				{
					return;
				}
				
				if(!isFinishingHorizontally && this._isDraggingHorizontally)
				{
					//take the average for more accuracy
					var sum:Number = this._velocityX * 2.33;
					var velocityCount:int = this._previousVelocityX.length;
					var totalWeight:Number = 0;
					for(var i:int = 0; i < velocityCount; i++)
					{
						var weight:Number = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityX.shift() * weight;
						totalWeight += weight;
					}
					this.throwHorizontally(sum / totalWeight);
				}
				else
				{
					this.hideHorizontalScrollBar();
				}
				
				if(!isFinishingVertically && this._isDraggingVertically)
				{
					sum = this._velocityY * 2.33;
					velocityCount = this._previousVelocityY.length;
					totalWeight = 0;
					for(i = 0; i < velocityCount; i++)
					{
						weight = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityY.shift() * weight;
						totalWeight += weight;
					}
					this.throwVertically(sum / totalWeight);
				}
				else
				{
					this.hideVerticalScrollBar();
				}
			}
		}

		/**
		 * @private
		 */
		protected function nativeStage_mouseWheelHandler(event:MouseEvent):void
		{
			helperPoint.x = event.stageX;
			helperPoint.y = event.stageY;
			helperPoint = this.globalToLocal(helperPoint);
			if(this.hitTest(helperPoint, true))
			{
				this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition, Math.max(0, this._verticalScrollPosition - event.delta * this._verticalScrollStep));
			}
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_touchHandler(event:TouchEvent):void
		{
			const displayHorizontalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			const touch:Touch = event.getTouch(displayHorizontalScrollBar);
			if(!touch)
			{
				this.hideHorizontalScrollBar();
				return;
			}

			if(touch.phase == TouchPhase.HOVER)
			{
				if(this._horizontalScrollBarHideTween)
				{
					this._horizontalScrollBarHideTween.paused = true;
					this._horizontalScrollBarHideTween = null;
				}
				displayHorizontalScrollBar.alpha = 1;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				const location:Point = touch.getLocation(displayHorizontalScrollBar);
				ScrollRectManager.adjustTouchLocation(location, displayHorizontalScrollBar);
				const isInBounds:Boolean = displayHorizontalScrollBar.hitTest(location, true) != null;
				if(!isInBounds)
				{
					this.hideHorizontalScrollBar();
				}
			}
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_touchHandler(event:TouchEvent):void
		{
			const displayVerticalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			const touch:Touch = event.getTouch(displayVerticalScrollBar);
			if(!touch)
			{
				this.hideVerticalScrollBar();
				return;
			}

			if(touch.phase == TouchPhase.HOVER)
			{
				if(this._verticalScrollBarHideTween)
				{
					this._verticalScrollBarHideTween.paused = true;
					this._verticalScrollBarHideTween = null;
				}
				displayVerticalScrollBar.alpha = 1;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				const location:Point = touch.getLocation(displayVerticalScrollBar);
				ScrollRectManager.adjustTouchLocation(location, displayVerticalScrollBar);
				const isInBounds:Boolean = displayVerticalScrollBar.hitTest(location, true) != null;
				if(!isInBounds)
				{
					this.hideVerticalScrollBar();
				}
			}
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
		}
		
		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
			this._touchPointID = -1;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			if(this._verticalAutoScrollTween)
			{
				this._verticalAutoScrollTween.paused = true;
				this._verticalAutoScrollTween = null;
			}
			if(this._horizontalAutoScrollTween)
			{
				this._horizontalAutoScrollTween.paused = true;
				this._horizontalAutoScrollTween = null;
			}
			
			//if we stopped the animation while the list was outside the scroll
			//bounds, then let's account for that
			const oldHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			const oldVerticalScrollPosition:Number = this._verticalScrollPosition;
			this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
			this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
			if(oldHorizontalScrollPosition != this._horizontalScrollPosition ||
				oldVerticalScrollPosition != this._verticalScrollPosition)
			{
				this._onScroll.dispatch(this);
			}
		}
	}
}