/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.lazy {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.typefest.data.Set;
	import org.typefest.time.readTime;
	
	
	
	
	
	public class Lazy extends Object {
		static protected var _lazy:Lazy = new Lazy();
		
		static public function add(f:Function, time:*):void {
			_lazy.add(f, time);
		}
		static public function remove(f:Function):void {
			_lazy.remove(f);
		}
		static public function has(f:Function):Boolean {
			return _lazy.has(f);
		}
		static public function clear():void {
			_lazy.clear();
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _frames:Dictionary       = null;
		protected var _seconds:Dictionary      = null;
		protected var _execs:Set               = null;
		protected var _engine:IEventDispatcher = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Lazy() {
			super();
			
			_frames  = new Dictionary();
			_seconds = new Dictionary();
			_execs   = new Set();
		}
		
		
		
		
		
		//---------------------------------------
		// add / remove / has / clear
		//---------------------------------------
		public function add(f:Function, time:*):void {
			log("Lazy.add", f, time, f in _frames, f in _seconds);
			
			///// remove
			this.remove(f);
			
			///// read time
			var r:Array = readTime(time);
			
			///// submit
			if (r[1]) {
				_frames[f] = new Frame(f, r[0]);
			} else {
				_seconds[f] = new Second(f, getTimer() + r[0] * 1000);
			}
			
			///// start loop
			if (!_engine) {
				_engine = new Bitmap();
				_engine.addEventListener(Event.ENTER_FRAME, _check);
			}
		}
		public function remove(f:Function):void {
			if (f in _frames) {
				delete _frames[f];
				return;
			}
			if (f in _seconds) {
				delete _seconds[f];
				return;
			}
			_execs.remove(f);
		}
		public function has(f:Function):Boolean {
			return f in _frames || f in _seconds || _execs.has(f);
		}
		public function clear():void {
			_frames  = new Dictionary();
			_seconds = new Dictionary();
			_execs   = new Set();
		}
		
		
		
		
		
		//---------------------------------------
		// check
		//---------------------------------------
		protected function _check(e:Event):void {
			var f:Function;
			
			///// check frames
			for each (var frame:Frame in _frames) {
				if (--frame.count <= 0) {
					_execs.add(frame.f);
				}
			}
			
			///// check seconds
			var now:Number = getTimer();
			
			for each (var second:Second in _seconds) {
				if (second.time <= now) {
					_execs.add(second.f);
				}
			}
			
			///// remove functions from _frames or _seconds
			for each (f in _execs) {
				if (f in _frames) {
					delete _frames[f];
				} else if (f in _seconds) {
					delete _seconds[f];
				}
			}
			
			///// execute functions
			while (_execs.length) {
				for each (f in _execs) {
					_execs.remove(f);
					f();
					break;
				}
			}
			
			///// check rest and remove loop
			var some:Boolean = false;
			var ff:*;
			
			for (ff in _frames) {
				some = true;
				break;
			}
			if (!some) {
				for (ff in _seconds) {
					some = true;
					break;
				}
			}
			
			if (!some) {
				_engine.removeEventListener(Event.ENTER_FRAME, _check);
				_engine = null;
			}
		}
	}
}