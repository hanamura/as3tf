/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.draft {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.typefest.core.Fn;
	import org.typefest.time.SharedEngine;
	
	import org.typefest.core.Dict;
	
	public class Delay {
		protected static var _delay:Delay = new Delay();
		
		public static function add(fn:Function, time:*):void {
			_delay.add(fn, time);
		}
		
		public static function has(fn:Function):Boolean {
			return _delay.has(fn);
		}
		
		public static function remove(fn:Function):Boolean {
			return _delay.remove(fn);
		}
		
		public static function clear():void {
			_delay.clear();
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _sharedEngine:SharedEngine = null;
		
		protected var _seconds:Dictionary = null;
		protected var _frames:Dictionary  = null;
		
		public function Delay(sharedEngine:SharedEngine = null) {
			super();
			
			if(sharedEngine === null) {
				this._sharedEngine = SharedEngine.sharedEngine;
			} else {
				this._sharedEngine = sharedEngine;
			}
			this._frames  = new Dictionary();
			this._seconds = new Dictionary();
		}
		
		public function add(fn:Function, time:*):void {
			//log("Delay.add");
			
			this.remove(fn);
			
			utilParse(time, Fn.reserve(this._add, fn));
		}
		
		protected function _add(fn:Function, time:Number, frame:Boolean):void {
			//log("Delay._add");
			
			if(time <= 0) {
				fn();
				return;
			}
			
			if(frame) {
				this._frames[fn] = time;
			} else {
				this._seconds[fn] = this._sharedEngine.time + (time * 1000);
			}
			
			this._sharedEngine.addEventListener(
				Event.ENTER_FRAME, this._check, false, 0, true
			);
		}
		
		public function has(fn:Function):Boolean {
			return (fn in this._frames) || (fn in this._seconds);
		}
		
		public function remove(fn:Function):Boolean {
			if(fn in this._frames) {
				return delete this._frames[fn];
			}
			return delete this._seconds[fn];
		}
		
		public function clear():void {
			this._frames  = new Dictionary();
			this._seconds = new Dictionary();
			
			this._sharedEngine.removeEventListener(Event.ENTER_FRAME, this._check);
		}
		
		protected function _check(e:Event):void {
			var fn:*;
			var some:Boolean    = false;
			var f_targets:Array = [];
			var s_targets:Array = [];
			var time:Number     = this._sharedEngine.time;
			
			// for(var $$$:* in this._frames) {
			// 	log("Delay._check");
			// }
			
			for(fn in this._frames) {
				this._frames[fn]--;
				//this._frames[fn] = this._frames[fn] - 1;
				
				//log("Delay._check frames loop bef", this._frames[fn], f_targets.indexOf(fn));
				
				if(this._frames[fn] <= 0 && f_targets.indexOf(fn) < 0) {
					f_targets.push(fn);
				}
				
				//log("Delay._check frames loop", this._frames[fn], f_targets.indexOf(fn));
				
				some = true;
			}
			
			for(fn in this._seconds) {
				if(this._seconds[fn] <= time) {
					s_targets.push(fn);
				}
				some = true;
			}
			
			if(!some) {
				this._sharedEngine.removeEventListener(Event.ENTER_FRAME, this._check);
				return;
			}
			
			for each(fn in f_targets) {
				delete this._frames[fn];
			}
			
			for each(fn in s_targets) {
				delete this._seconds[fn];
			}
			
			// log(
			// 	"Delay._check out of loop",
			// 	f_targets.length,
			// 	s_targets.length,
			// 	Dict.length(this._frames),
			// 	Dict.length(this._seconds)
			// );
			for each(fn in f_targets.concat(s_targets)) {
				// log("Delay._check in loop");
				fn();
			}
			
			if(Dict.length(this._frames) <= 0 && Dict.length(this._seconds) <= 0) {
				this._sharedEngine.removeEventListener(Event.ENTER_FRAME, this._check);
			}
		}
	}
}