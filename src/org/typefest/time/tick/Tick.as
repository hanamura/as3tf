/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.tick {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.typefest.core.Num;
	
	
	
	
	
	public class Tick extends EventDispatcher {
		///// prop
		protected var _interval:Number = 0;
		protected var _base:Date       = null;
		
		public function get interval():Number { return _interval }
		public function get base():Date { return new Date(_base.time) }
		
		
		
		///// containers
		protected var _dict:Dictionary = null;
		protected var _items:Array     = null;
		
		public function get length():int { return _items.length }
		
		
		
		///// engine
		protected var _engine:IEventDispatcher = null;
		protected var _last:Date               = null;
		
		public function get date():Date {
			if (active) {
				return new Date(_last.time);
			} else {
				return null;
			}
		}
		public function get position():Number {
			if (active) {
				return Num.loop(_last.time - _base.time, 0, _interval);
			} else {
				return NaN;
			}
		}
		
		
		
		///// active
		public function get active():Boolean { return !!_engine }
		public function set active(bool:Boolean):void {
			if (bool && !_engine) {
				_last   = new Date();
				_engine = new Bitmap();
				_engine.addEventListener(Event.ENTER_FRAME, _check, false, 0, true);
			} else if (!bool && _engine) {
				_last = null;
				_engine.removeEventListener(Event.ENTER_FRAME, _check, false);
				_engine = null;
			}
		}
		
		
		
		///// arrays
		public function get keys():Array {
			var _:Array = [];
			
			for each (var item:TickItem in _items) {
				_.push(item.time);
			}
			return _;
		}
		public function get values():Array {
			var _:Array = [];
			
			for each (var item:TickItem in _items) {
				_.push(item.data);
			}
			return _;
		}
		public function get items():Array {
			var _:Array = [];
			
			for each (var item:TickItem in _items) {
				_.push(item.clone());
			}
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Tick(interval:Number, base:Date = null) {
			super();
			
			_interval = interval;
			_base     = base || new Date();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_dict  = new Dictionary();
			_items = [];
		}
		
		
		
		
		
		//---------------------------------------
		// operations
		//---------------------------------------
		public function set(time:Number, data:* = null):void {
			if (time < 0 || time >= _interval) {
				throw new ArgumentError("Out of range.");
			}
			
			del(time);
			
			var item:TickItem = new TickItem(time, data);
			var i:int;
			
			for (i = 0; i < _items.length; i++) {
				if (_items[i].time > time) { break }
			}
			
			_items.splice(i, 0, item);
			
			for (; i < _items.length; i++) {
				_dict[_items[i].time] = i;
			}
		}
		public function get(time:Number):* {
			if (time in _dict) {
				return _items[_dict[time]].data;
			} else {
				return undefined;
			}
		}
		public function del(time:Number):Boolean {
			if (time in _dict) {
				var i:int = _dict[time];
				
				_items.splice(i, 1);
				
				for (; i < _items.length; i++) {
					_dict[_items[i].time] = i;
				}
				return delete _dict[time];
			} else {
				return false;
			}
		}
		public function has(time:Number):Boolean {
			return time in _dict;
		}
		public function clear():void {
			_dict  = new Dictionary();
			_items = [];
		}
		
		
		
		
		
		//---------------------------------------
		// each
		//---------------------------------------
		public function each(fn:Function):void {
			for each (var item:TickItem in _items) {
				fn(item.time, item.data);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// check
		//---------------------------------------
		protected function _check(e:Event):void {
			///// now
			var now:Date = new Date();
			
			var from:Number = Num.loop(_last.time - _base.time, 0, _interval);
			var to:Number   = from + (now.time - _last.time);
			
			_last = now;
			
			
			
			///// construct targets
			var loops:int     = Math.ceil(to / _interval);
			var targets:Array = [];
			var i:int;
			var item:TickItem;
			var offset:Number;
			
			for (i = 0; i < loops; i++) {
				offset = _interval * i;
				
				for each (item in _items) {
					targets.push(new Target(item, item.time + offset));
				}
			}
			
			
			
			///// define start & end
			var start:int = targets.length;
			var end:int   = targets.length;
			
			for (i = 0; i < targets.length; i++) {
				if (targets[i].altTime > from) {
					start = i;
					break;
				}
			}
			for (i = 0; i < targets.length; i++) {
				if (targets[i].altTime > to) {
					end = i;
					break;
				}
			}
			
			
			
			///// dispatch
			var triggers:Array = targets.slice(start, end);
			
			if (triggers.length) {
				var items:Array = [];
				
				for each (var target:Target in triggers) {
					items.push(target.item);
				}
				
				dispatchEvent(new TickEvent(
					TickEvent.TICK,
					false,
					false,
					items,
					now,
					position
				));
			}
		}
	}
}

import org.typefest.time.tick.TickItem;

internal class Target extends Object {
	public var item:TickItem  = null;
	public var altTime:Number = 0;
	
	public function Target(item:TickItem, altTime:Number) {
		this.item    = item;
		this.altTime = altTime;
	}
}