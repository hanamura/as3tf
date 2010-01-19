/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class Lazy extends Object {
		static private var __lazy:Lazy = new Lazy();
		
		static public function add(f:Function, time:*):void {
			__lazy.add(f, time);
		}
		static public function remove(f:Function):void {
			__lazy.remove(f);
		}
		static public function has(f:Function):Boolean {
			return __lazy.has(f);
		}
		static public function clear():void {
			__lazy.clear();
		}
		
		//---------------------------------------
		// engine
		//---------------------------------------
		protected var _engine:IEventDispatcher = null;
		
		protected var _frames:Dictionary = null;
		protected var _times:Dictionary  = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Lazy() {
			super();
			
			_frames = new Dictionary();
			_times  = new Dictionary();
			
			_engine = new Bitmap();
		}
		
		//---------------------------------------
		// add / remove
		//---------------------------------------
		public function add(f:Function, time:*):void {
			remove(f);
			
			var r:Array = readTime(time);
			
			time = r[0];
			
			if (r[1]) {
				// why specific object? avoiding a runtime bug
				// https://bugs.adobe.com/jira/browse/ASC-3820?rc=1
				_frames[f] = new F(time);
			} else {
				_times[f] = getTimer() + (time * 1000);
			}
			
			_engine.addEventListener(Event.ENTER_FRAME, _check);
		}
		public function remove(f:Function):void {
			var some:Boolean = false;
			
			if (f in _frames) {
				delete _frames[f];
				some = true;
			} else {
				if (f in _times) {
					delete _times[f];
					some = true;
				}
			}
		}
		public function has(f:Function):Boolean {
			return f in _frames || f in _times;
		}
		public function clear():void {
			_frames = new Dictionary();
			_times  = new Dictionary();
		}
		
		//---------------------------------------
		// check
		//---------------------------------------
		protected function _check(e:Event):void {
			var f:*;
			var time:int = getTimer();
			
			var times:Array  = [];
			var frames:Array = [];
			
			///// frames pickup
			for (f in _frames) {
				if (--_frames[f].frame <= 0) {
					frames.push(f);
				}
			}
			
			///// times pickup
			for (f in _times) {
				if (_times[f] <= time) {
					times.push(f);
				}
			}
			
			///// frames delete
			for each (f in frames) {
				delete _frames[f];
			}
			
			///// times delete
			for each (f in times) {
				delete _times[f];
			}
			
			///// function execute
			var fs:Array = frames.concat(times);
			
			for each (f in fs) {
				f();
			}
			
			///// stop loop
			var some:Boolean = false;
			
			for (f in _frames) {
				some = true;
				break;
			}
			for (f in _times) {
				some = true;
				break;
			}
			
			if (!some) {
				_engine.removeEventListener(Event.ENTER_FRAME, _check);
			}
		}
	}
}

internal class F extends Object {
	public var frame:int  = 0;
	
	public function F(frame:int) {
		super();
		
		this.frame = frame;
	}
}