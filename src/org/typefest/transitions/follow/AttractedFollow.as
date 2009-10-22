/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.follow {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	dynamic public class AttractedFollow extends Follow {
		protected var _rate:Number = 0;
		protected var _drop:Number = 0;
		
		public function get rate():Number {
			return _rate;
		}
		public function get drop():Number {
			return _drop;
		}
		
		protected var _engine:IEventDispatcher = null;
		
		override public function get moving():Boolean {
			return _engine !== null;
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
		}
		
		//---------------------------------------
		// main
		//---------------------------------------
		protected function _needsUpdate():Boolean {
			for (var key:String in _dest) {
				if (_dest[key] !== _curr[key]) {
					return true;
				}
			}
			return false;
		}
		protected function _checkToSwitch():void {
			if (!_engine && _needsUpdate()) {
				_engine = new Bitmap();
				_engine.addEventListener(Event.ENTER_FRAME, _update);
				dispatchEvent(new Event(Event.OPEN));
			} else if (_engine && !_needsUpdate()) {
				_engine.removeEventListener(Event.ENTER_FRAME, _update);
				_engine = null;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		override protected function _addKeys(...keys:Array):void {}
		override protected function _updateKeys(...keys:Array):void {
			_checkToSwitch();
		}
		override protected function _cancelKeys(...keys:Array):void {
			_checkToSwitch();
		}
		protected function _update(e:Event):void {
			var sub:Number;
			var option:Option;
			var rate:Number;
			var drop:Number;
			var key:String;
			
			for (key in _dest) {
				sub = _dest[key] - _curr[key];
				
				if (sub === 0) {
					continue;
				}
				
				option = getOption(key);
				rate   = option ? option.rate : _rate;
				drop   = option ? option.drop : _drop;
				
				if (Math.abs(sub) <= drop) {
					_curr[key] = _dest[key];
				} else {
					_curr[key] = _curr[key] + (sub * rate);
				}
			}
			
			_checkToSwitch();
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