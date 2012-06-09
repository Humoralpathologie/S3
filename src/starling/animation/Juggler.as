// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.animation
{
    import starling.events.Event;
    import starling.events.EventDispatcher;

    /** The Juggler takes objects that implement IAnimatable (like Tweens) and executes them.
     * 
     *  <p>A juggler is a simple object. It does no more than saving a list of objects implementing 
     *  "IAnimatable" and advancing their time if it is told to do so (by calling its own 
     *  "advanceTime"-method). When an animation is completed, it throws it away.</p>
     *  
     *  <p>There is a default juggler available at the Starling class:</p>
     *  
     *  <pre>
     *  var juggler:Juggler = Starling.juggler;
     *  </pre>
     *  
     *  <p>You can create juggler objects yourself, just as well. That way, you can group 
     *  your game into logical components that handle their animations independently. All you have
     *  to do is call the "advanceTime" method on your custom juggler once per frame.</p>
     * 
     *  <p>A time multiplication factor can be set by changing the "timeFactor" property. This can
     *  be used to slow down or speed up the game.</p>
     * 
     *  <p>Another handy feature of the juggler is the "delayCall"-method. Use it to 
     *  execute a function at a later time. Different to conventional approaches, the method
     *  will only be called when the juggler is advanced, giving you perfect control over the 
     *  call.</p>
     *  
     *  <pre>
     *  juggler.delayCall(object.removeFromParent, 1.0);
     *  juggler.delayCall(object.addChild, 2.0, theChild);
     *  juggler.delayCall(function():void { doSomethingFunny(); }, 3.0);
     *  </pre>
     * 
     *  @see Tween
     *  @see DelayedCall 
     */
    public class Juggler implements IAnimatable
    {
        private var mObjects:Vector.<IAnimatable>;
        private var mElapsedTime:Number;
        private var mTimeFactor:Number
        private var mPaused:Boolean;
        
        /** Create an empty juggler. */
        public function Juggler()
        {
            mElapsedTime = 0;
            mTimeFactor = 1;
            mPaused = false;
            mObjects = new <IAnimatable>[];
        }

        /** Adds an object to the juggler. */
        public function add(object:IAnimatable):void
        {
            if (object != null) mObjects.push(object);
            
            var dispatcher:EventDispatcher = object as EventDispatcher;
            if (dispatcher) dispatcher.addEventListener(Event.REMOVE_FROM_JUGGLER, onRemove);
        }
        
        /** Removes an object from the juggler. */
        public function remove(object:IAnimatable):void
        {
            if (object == null) return;
            
            var dispatcher:EventDispatcher = object as EventDispatcher;
            if (dispatcher) dispatcher.removeEventListener(Event.REMOVE_FROM_JUGGLER, onRemove);
            
            for (var i:int=mObjects.length-1; i>=0; --i)
                if (mObjects[i] == object) 
                    mObjects.splice(i, 1);
        }
        
        /** Removes all tweens with a certain target. */
        public function removeTweens(target:Object):void
        {
            if (target == null) return;
            var numObjects:int = mObjects.length;
            
            for (var i:int=numObjects-1; i>=0; --i)
            {
                var tween:Tween = mObjects[i] as Tween;
                if (tween && tween.target == target)
                    mObjects.splice(i, 1);
            }
        }
        
        /** Removes all objects at once. */
        public function purge():void
        {
            for (var i:int=mObjects.length-1; i>=0; --i)
            {
                var dispatcher:EventDispatcher = mObjects.pop() as EventDispatcher;
                if (dispatcher) dispatcher.removeEventListener(Event.REMOVE_FROM_JUGGLER, onRemove);
            }
        }
        
        /** Delays the execution of a function until a certain time has passed. Creates an
         *  object of type 'DelayedCall' internally and returns it. Remove that object
         *  from the juggler to cancel the function call. */
        public function delayCall(call:Function, delay:Number, ...args):DelayedCall
        {
            if (call == null) return null;
            
            var delayedCall:DelayedCall = new DelayedCall(call, delay, args);
            add(delayedCall);
            return delayedCall;
        }
        
        /** Advances all objects by a certain time (in seconds). */
        public function advanceTime(time:Number):void
        {   
          if(!mPaused) {
            // Adjust by time multiplation factor.
            time *= mTimeFactor;
            
            mElapsedTime += time;
            if (mObjects.length == 0) return;
            
            // since 'advanceTime' could modify the juggler (through a callback), we iterate
            // over a copy of 'mObjects'.
            
            var numObjects:int = mObjects.length;
            var objectCopy:Vector.<IAnimatable> = mObjects.concat();
            
            for (var i:int=0; i<numObjects; ++i)
                objectCopy[i].advanceTime(time);
          }
        }
        
        private function onRemove(event:Event):void
        {
            remove(event.target as IAnimatable);
        }
        
        /** The total life time of the juggler. */
        public function get elapsedTime():Number { return mElapsedTime; }        
        
        /** Get and set the time multiplication factor **/
        public function set timeFactor(value:Number):void { mTimeFactor = value; } 
        public function get timeFactor():Number { return mTimeFactor; }
        
        public function set paused(value:Boolean):void { mPaused = value; }
        public function get paused():Boolean { return mPaused;}
    }
}