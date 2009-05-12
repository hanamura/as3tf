/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.draft {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.typefest.core.Fn;
	import org.typefest.time.SharedEngine;
	
	public class TweenSeed {
		static protected var _tweenSeed:TweenSeed = new TweenSeed();
		
		static public function add(
			fn:Function,
			time:*,
			delay:* = null,
			ease:Function = null
		):void {
			_tweenSeed.add(fn, time, delay, ease);
		}
		
		static public function remove(fn:Function):Boolean {
			return _tweenSeed.remove(fn);
		}
		
		static public function has(fn:Function):Boolean {
			return _tweenSeed.has(fn);
		}
		
		static public function clear():void {
			return _tweenSeed.clear();
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _sharedEngine:SharedEngine = null;
		protected var _delay:Delay               = null;
		protected var _seconds:Dictionary        = new Dictionary();
		protected var _frames:Dictionary         = new Dictionary();
		
		public function TweenSeed(sharedEngine:SharedEngine = null) {
			if(sharedEngine === null) {
				this._sharedEngine = SharedEngine.sharedEngine;
			} else {
				this._sharedEngine = sharedEngine;
			}
			this._delay = new Delay(sharedEngine);
		}
		
		//---------------------------------------
		// add / remove
		//---------------------------------------
		public function add(
			fn:Function,
			time:*,
			delay:* = null,
			ease:Function = null
		):void {
			this.remove(fn);
			
			if(delay === null) {
				this._start(fn, time, ease);
			} else {
				this._delay.add(Fn.reserve(this._start, fn, time, ease), delay);
			}
		}
		
		public function remove(fn:Function):Boolean {
			if(this._delay.has(fn)) {
				return this._delay.remove(fn);
			} else if(fn in this._seconds) {
				this._sharedEngine.removeEventListener(
					Event.ENTER_FRAME, this._seconds[fn]
				);
				return delete this._seconds[fn];
			} else if(fn in this._frames) {
				this._sharedEngine.removeEventListener(
					Event.ENTER_FRAME, this._frames[fn]
				);
				return delete this._frames[fn];
			} else {
				return false;
			}
		}
		
		public function has(fn:Function):Boolean {
			return this._delay.has(fn) || fn in this._seconds || fn in this._frames;
		}
		
		public function clear():void {
			this._delay.clear();
			
			var enterFrame:Function;
			
			for each(enterFrame in this._seconds) {
				this._sharedEngine.removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
			this._seconds = new Dictionary();
			
			for each(enterFrame in this._frames) {
				this._sharedEngine.removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
			this._frames = new Dictionary();
		}
		
		//---------------------------------------
		// Internal
		//---------------------------------------
		protected function _start(
			fn:Function,
			time:*,
			ease:Function = null
		):void {
			var parsed:Array = utilParse(time);
			
			(parsed[1] ? this._startFrames : this._startSeconds)(fn, parsed[0], ease);
		}
		
		//---------------------------------------
		// Seconds
		//---------------------------------------
		protected function _startSeconds(
			fn:Function,
			seconds:Number,
			ease:Function = null
		):void {
			var then:Number = this._sharedEngine.time;
			
			var enterFrame:Function = function(e:Event):void {
				var now:Number      = _sharedEngine.time;
				var duration:Number = (now - then) / 1000;
				
				var ratio:Number;
				
				if(duration >= seconds) {
					ratio = 1;
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					delete _seconds[fn];
				} else {
					ratio = duration / seconds;
				}
				
				var value:Number = (ease === null) ? ratio : ease(ratio, 0, 1, 1);
				
				fn(value, duration, seconds);
			}
			
			this._seconds[fn] = enterFrame;
			this._sharedEngine.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			var value:Number = (ease === null) ? 0 : ease(0, 0, 1, 1);
			
			fn(value, 0, seconds);
		}
		
		//---------------------------------------
		// Frames
		//---------------------------------------
		protected function _startFrames(
			fn:Function,
			frames:int,
			ease:Function = null
		):void {
			var count:int = 0;
			
			var enterFrame:Function = function(e:Event):void {
				count++;
				
				var ratio:Number = count / frames;
				
				if(count === frames) {
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					delete _frames[fn];
				}
				
				var value:Number = (ease === null) ? ratio : ease(ratio, 0, 1, 1);
				
				fn(value, count, frames);
			}
			
			this._frames[fn] = enterFrame;
			this._sharedEngine.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			var value:Number = (ease === null) ? 0 : ease(0, 0, 1, 1);
			
			fn(value, 0, frames);
		}
	}
}