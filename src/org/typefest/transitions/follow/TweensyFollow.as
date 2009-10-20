/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

/*
This class depends on Tweensy (0.2.2)
http://code.google.com/p/tweensy/
*/

package org.typefest.transitions.follow {
	import flash.events.Event;
	
	import fl.motion.easing.Linear;
	
	import com.flashdynamix.motion.TweensyGroup;
	import com.flashdynamix.motion.TweensyTimeline;
	
	public class TweensyFollow extends Follow {
		protected var _duration:Number = 1;
		protected var _ease:Function   = null;
		
		public function get duration():Number {
			return _duration;
		}
		public function get ease():Function {
			return _ease;
		}
		
		protected var _motion:TweensyGroup = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function TweensyFollow(
			target:*        = null,
			init:*          = null,
			duration:Number = 1,
			ease:Function   = null
		) {
			super(target, init);
			
			_duration = duration;
			_ease     = ease || Linear.easeNone;
		}
		
		//---------------------------------------
		// main
		//---------------------------------------
		override protected function _updateKeys(...keys:Array):void {
			_moving = true;
			
			if (_motion) {
				_motion.dispose();
				_motion = null;
			}
			
			_motion = new TweensyGroup();
			_motion.onComplete = _motionComplete;
			
			var dest:*;
			var timeline:TweensyTimeline;
			var option:*;
			
			for (var key:String in _dest) {
				dest = {};
				dest[key] = _dest[key];
				
				timeline = _motion.to(_curr, dest, _duration, _ease);
				
				option = getOption(key);
				
				for (var prop:String in option) {
					timeline[prop] = option[prop];
				}
			}
		}
		override protected function _cancelKeys(...keys:Array):void {
			if (_motion) {
				var count:int = 0;
				
				for (var key:String in _dest) {
					count++;
				}
				
				if (count > 0) {
					_motion.stop.apply(null, [null].concat(keys));
				} else {
					_motionComplete();
				}
			}
		}
		protected function _motionComplete():void {
			_moving = false;
			
			_motion.dispose();
			_motion = null;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//---------------------------------------
		// option
		//---------------------------------------
		override public function setOption(key:String, ...args:Array):void {
			if (args.length !== 1) {
				throw new ArgumentError("This method needs 2 arguments.");
			}
			var _:* = {};
			for (var p:String in args[0]) {
				_[p] = args[0][p];
			}
			_options[key] = _;
		}
		override public function getOption(key:String):* {
			if (_options[key]) {
				var _:* = {};
				var o:* = _options[key];

				for (var p:String in o) {
					_[p] = o[p];
				}

				return _;
			} else {
				return undefined;
			}
		}
	}
}