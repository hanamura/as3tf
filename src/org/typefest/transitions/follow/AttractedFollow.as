/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.follow {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class AttractedFollow extends Follow {
		protected var _rate:Number = 0;
		protected var _drop:Number = 0;
		
		protected var _done:*               = null;
		protected var _engine:DisplayObject = null;
		
		public function get rate():Number {
			return _rate;
		}
		public function get drop():Number {
			return _drop;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AttractedFollow(
			target:*    = null,
			init:*      = null,
			rate:Number = 0.1,
			drop:Number = 0.05
		) {
			super(target, init);
			
			_rate = rate;
			_drop = drop;
			
			_engine = new Bitmap();
		}
		
		//---------------------------------------
		// main
		//---------------------------------------
		override protected function _updateKeys(...keys:Array):void {
			_moving = true;
			
			_done = {};
			
			for (var key:String in _dest) {
				_done[key] = false;
			}
			
			_engine.addEventListener(Event.ENTER_FRAME, _update, false, 0, true);
		}
		override protected function _cancelKeys(...keys:Array):void {
			_moving = false;
			
			_engine.removeEventListener(Event.ENTER_FRAME, _update, false);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		protected function _update(e:Event):void {
			var dist:Number;
			var option:Option;
			var rate:Number;
			var drop:Number;
			
			for (var key:String in _dest) {
				if (_done[key]) {
					continue;
				}
				
				dist = _dest[key] - _curr[key];
				
				option = getOption(key);
				rate   = option ? option.rate : _rate;
				drop   = option ? option.drop : _drop;
				
				if (Math.abs(dist) <= drop) {
					_curr[key] = _dest[key];
					_done[key] = true;
				} else {
					_curr[key] = _curr[key] + (dist * rate);
				}
			}
			
			for each (var bool:Boolean in _done) {
				if (!bool) {
					return;
				}
			}
			
			_moving = false;
			_engine.removeEventListener(Event.ENTER_FRAME, _update, false);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//---------------------------------------
		// option
		//---------------------------------------
		override public function setOption(key:String, ...args:Array):void {
			if (args.length < 1 || args.length > 2) {
				throw new ArgumentError("This method needs 2 or 3 arguments.");
			}
			_options[key] = new Option(
				args[0],
				args.length >= 2 ? args[1] : _drop
			);
		}
		override public function getOption(key:String):* {
			return _options[key] && _options[key].array;
		}
	}
}

internal class Option extends Object {
	public var rate:Number = 0;
	public var drop:Number = 0;
	
	public function get array():Array {
		return [rate, drop];
	}
	
	public function Option(rate:Number, drop:Number) {
		super();
		this.rate = rate;
		this.drop = drop;
	}
}