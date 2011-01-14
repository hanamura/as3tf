/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.pull {
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	[Event(name="open", type="flash.events.Event.OPEN")]
	[Event(name="change", type="flash.events.Event.CHANGE")]
	[Event(name="close", type="flash.events.Event.CLOSE")]
	dynamic public class Pull extends Proxy implements IEventDispatcher {
		static protected function __key(name:*):String {
			if (name is QName) {
				return name.localName;
			} else if (name is String) {
				return name;
			} else {
				return String(name);
			}
		}
		static protected const __BITMAP:IEventDispatcher = new Bitmap();
		
		//---------------------------------------
		// instanece
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _target:* = null;
		
		public function get target():* {
			return _target;
		}
		
		protected var _dest:* = {};
		protected var _curr:* = {};
		protected var _opts:* = {};
		
		protected var _opt:Option = null;
		
		public function get option():* {
			return _opt.get();
		}
		
		protected var _engine:IEventDispatcher = null;
		
		protected var __temp:Array = null;
		
		//---------------------------------------
		// adjusted
		//---------------------------------------
		public function get adjusted():Boolean {
			for (var key:String in _dest) {
				if (_curr[key] !== _dest[key]) {
					return false;
				}
			}
			return true;
		}
		
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
				_checkToSwitch();
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Pull(target:*, keys:Array, option:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			_target = target;
			
			for each (var key:String in keys) {
				_curr[key] = _dest[key] = (key in _target) ? _target[key] : 0;
				_opts[key] = new Option();
				_opts[key].set(option);
			}
			
			_opt = new Option();
			_opt.set(option);
		}
		
		//---------------------------------------
		// set / get option
		//---------------------------------------
		public function setOption(key:String, option:*):void {
			if (key in _opts) {
				if (option) {
					var opt:Option = _opts[key];
					
					opt.set(option);
					
					if (opt.sync) {
						_target[key] = opt.convert(_curr[key] = _dest[key]);
						_checkToSwitch();
					}
				} else {
					setOptionDefault(key);
				}
			} else {
				throw new ArgumentError("Key " + key + " not found.");
			}
		}
		public function getOption(key:String):* {
			if (key in _opts) {
				return _opts[key].get();
			} else {
				throw new ArgumentError("Key " + key + " not found.");
			}
		}
		public function setOptionDefault(key:*):void {
			if (key in _opts) {
				var opt:Option = _opts[key];
				
				opt.set(_opt.get());
				
				if (opt.sync) {
					_target[key] = opt.convert(_curr[key] = _dest[key]);
					_checkToSwitch();
				}
			} else {
				throw new ArgumentError("Key " + key + " not found.");
			}
		}
		public function setOptions(option:*):void {
			for (var key:String in _opts) {
				setOption(key, option);
			}
		}
		
		//---------------------------------------
		// check
		//---------------------------------------
		protected function _checkToSwitch():void {
			if (auto && !_engine && !adjusted) {
				_engine = __BITMAP;
				_engine.addEventListener(Event.ENTER_FRAME, _step, false, 0, true);
				
				dispatchEvent(new Event(Event.OPEN));
			} else if ((!auto || adjusted) && _engine) {
				_engine.removeEventListener(Event.ENTER_FRAME, _step, false);
				_engine = null;
				
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		//---------------------------------------
		// set / get
		//---------------------------------------
		public function set(key:String, value:Number):void {
			if (!(key in _dest)) {
				throw new ArgumentError("Key " + key + " not found.");
			}
			if (_dest[key] !== value) {
				_dest[key] = value;
				
				if (_opts[key].sync) {
					_curr[key]   = value;
					_target[key] = _opts[key].convert(value);
				}
				
				_checkToSwitch();
			}
		}
		public function get(key:String):Number {
			if (!(key in _dest)) {
				throw new ArgumentError("Key " + key + " not found.");
			}
			return _dest[key];
		}
		public function $(key:String):Number {
			if (!(key in _dest)) {
				throw new ArgumentError("Key " + key + " not found.");
			}
			return _curr[key];
		}
		public function offset(key:String, value:Number):void {
			if (!(key in _dest)) {
				throw new ArgumentError("Key " + key + " not found.");
			}
			if (value) {
				_dest[key] += value;
				_curr[key] += value;
			}
		}
		
		//---------------------------------------
		// adjust
		//---------------------------------------
		public function adjust(key:String = null):void {
			if (key === null) {
				for (var key:String in _dest) {
					_target[key] = _opts[key].convert(_curr[key] = _dest[key]);
				}
				_checkToSwitch();
			} else {
				if (key in _dest && _curr[key] !== _dest[key]) {
					_target[key] = _opts[key].convert(_curr[key] = _dest[key]);
					
					_checkToSwitch();
				}
			}
		}
		
		//---------------------------------------
		// step
		//---------------------------------------
		protected function _step(e:Event):void {
			step();
		}
		public function step():void {
			var opt:Option;
			var sub:Number;
			
			for (var key:String in _dest) {
				
				sub = _dest[key] - _curr[key];
				
				if (sub === 0) {
					continue;
				}
				
				opt = _opts[key];
				
				if (Math.abs(sub) <= opt.drop) {
					_curr[key] = _dest[key];
				} else {
					_curr[key] = _curr[key] + (sub * opt.rate);
				}
				
				// apply
				_target[key] = opt.convert(_curr[key]);
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
			_checkToSwitch();
		}
		
		//---------------------------------------
		// to string
		//---------------------------------------
		public function toString():String {
			return "";
		}
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			set(__key(name), value);
		}
		override flash_proxy function getProperty(name:*):* {
			return get(__key(name));
		}
		override flash_proxy function hasProperty(name:*):Boolean {
			return __key(name) in _dest;
		}
		override flash_proxy function deleteProperty(name:*):Boolean {
			throw new IllegalOperationError("Unable to delete property.");
		}
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			var key:String = __key(name);
			
			if (args.length) {
				setOption(key, args[0]);
			} else {
				return getOption(key);
			}
		}
		override flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				__temp = [];
				for (var key:String in _dest) {
					__temp.push(key);
				}
			}
			if (index < __temp.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextName(index:int):String {
			return __temp[index - 1];
		}
		override flash_proxy function nextValue(index:int):* {
			return get(__temp[index - 1]);
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
		public function dispatchEvent(e:Event):Boolean {
			return __ed.dispatchEvent(e);
		}
		public function hasEventListener(t:String):Boolean {
			return __ed.hasEventListener(t);
		}
		public function willTrigger(t:String):Boolean {
			return __ed.willTrigger(t);
		}
	}
}

internal class Option extends Object {
	static protected function __pass(x:*):* { return x; }
	
	public var sync:Boolean     = false;
	public var rate:Number      = 0;
	public var drop:Number      = 0;
	public var convert:Function = null;
	
	public function Option() {
		reset();
	}
	
	public function reset():void {
		sync    = false;
		rate    = 0.1;
		drop    = 0.05;
		convert = __pass;
	}
	
	public function set($:*):void {
		if ($) {
			for (var key:String in $) {
				if (key in this) {
					this[key] = $[key];
				}
			}
		} else {
			reset();
		}
	}
	
	public function get():* {
		return {
			sync:sync,
			rate:rate,
			drop:drop,
			convert:convert
		};
	}
}