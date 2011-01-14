/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.accelerate {
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class Accelerate extends Proxy implements IEventDispatcher {
		static protected function __key(name:*):String {
			if (name is QName) {
				return name.localName;
			} else if (name is String) {
				return name;
			} else {
				return String(name);
			}
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _datas:*            = {};
		protected var _targets:Dictionary = new Dictionary(true);
		protected var _temp:Array         = null;
		
		protected var _engine:IEventDispatcher = null;
		
		//---------------------------------------
		// auto
		//---------------------------------------
		protected var _auto:Boolean = true;
		
		public function get auto():Boolean {
			return _auto;
		}
		public function set auto(bool:Boolean):void {
			if (_auto !== bool) {
				_auto = bool;
				
				if (bool) {
					_checkToSwitch();
				} else {
					if (_engine) {
						_engine.removeEventListener(Event.ENTER_FRAME, _step);
						_engine = null;
					}
				}
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Accelerate(target:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			target && add(target);
		}
		
		//---------------------------------------
		// Proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			var key:String = __key(name);
			
			if (!(key in _datas)) {
				_datas[key] = new Data();
			}
			
			_datas[key].velocity = value;
			
			if (_auto) {
				_checkToSwitch();
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			var key:String = __key(name);
			
			return _datas[key] && _datas[key].velocity;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return __key(name) in _datas;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			var key:String = __key(name);
			
			if (key in _datas) {
				delete _datas[key];
				
				if (_auto) {
					_checkToSwitch();
				}
				
				return true;
			} else {
				return false;
			}
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = __key(name);
			
			if (args.length > 0) {
				return setOption.apply(null, [key].concat(args));
			} else {
				return getOption(key);
			}
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				_temp = [];
				
				for (var key:String in _datas) {
					_temp.push(key);
				}
			}
			
			if (index < _temp.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextName(index:int):String {
			return _temp[index - 1];
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _datas[_temp[index - 1]].velocity;
		}
		
		//---------------------------------------
		// check to switch
		//---------------------------------------
		protected function _checkToSwitch():void {
			for each (var data:Data in _datas) {
				if (data.velocity !== 0) {
					if (!_engine) {
						_engine = new Bitmap();
						_engine.addEventListener(Event.ENTER_FRAME, _step);
						dispatchEvent(new Event(Event.OPEN));
					}
					return;
				}
			}
			if (_engine) {
				_engine.removeEventListener(Event.ENTER_FRAME, _step);
				_engine = null;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//---------------------------------------
		// add / remove
		//---------------------------------------
		public function add(...targets:Array):void {
			for each (var target:* in targets) {
				_targets[target] = true;
			}
		}
		
		public function remove(...targets:Array):void {
			for each (var target:* in targets) {
				delete _targets[target];
			}
		}
		
		public function has(target:*):Boolean {
			return target in _targets;
		}
		
		public function clear():void {
			_targets = new Dictionary(true);
		}
		
		//---------------------------------------
		// step
		//---------------------------------------
		protected function _step(e:Event):void {
			step();
		}
		
		public function step():void {
			var some:Boolean = false;
			
			for (var key:String in _datas) {
				var data:Data = _datas[key];
				
				if (data.velocity !== 0) {
					some = true;
				}
				
				// step targets
				for (var target:* in _targets) {
					if (key in target) {
						target[key] += data.velocity;
					}
				}
				
				// apply forces
				data.step();
			}
			
			if (some) {
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			if (_auto) {
				_checkToSwitch();
			}
		}
		
		//---------------------------------------
		// set / get option
		//---------------------------------------
		public function setOption(key:String, ...args:Array):void {
			if (key in _datas) {
				_datas[key].option = args[0];
			} else {
				throw new ArgumentError("Key named " + key + " not found.");
			}
		}
		public function getOption(key:String):* {
			if (key in _datas) {
				return _datas[key].option;
			} else {
				return null;
			}
		}
		
		//---------------------------------------
		// IEventDispatcher
		//---------------------------------------
		public function addEventListener(
			t:String,
			l:Function,
			uc:Boolean = false,
			p:int      = 0,
			uw:Boolean = false
		):void {
			__ed.addEventListener(t, l, uc, p, uw);
		}
		
		public function removeEventListener(
			t:String,
			l:Function,
			uc:Boolean = false
		):void {
			__ed.removeEventListener(t, l, uc);
		}
		
		public function hasEventListener(t:String):Boolean {
			return __ed.hasEventListener(t);
		}
		
		public function willTrigger(t:String):Boolean {
			return __ed.willTrigger(t);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return __ed.dispatchEvent(e);
		}
	}
}

internal class Data extends Object {
	public var velocity:Number  = 0;
	public var friction:Number  = 0;
	public var threshold:Number = 0;
	
	public function get option():* {
		return {
			friction:friction,
			threshold:threshold
		};
	}
	public function set option(_:*):void {
		("friction"  in _) && (friction  = _["friction"]);
		("threshold" in _) && (threshold = _["threshold"]);
	}
	
	public function Data() {}
	
	public function step():void {
		velocity *= 1 - friction;
		
		if (Math.abs(velocity) < threshold) {
			velocity = 0;
		}
	}
}