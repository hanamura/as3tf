/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

// inspired by http://d.hatena.ne.jp/secondlife/20070428/1177686633
package org.typefest.ui {
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class Kapture extends Proxy {
		/*
		*	// usage:
		*	
		*	var k:Kapture = new Kapture(stage);
		*	
		*	k.a = function():void {
		*		trace("a pressed");
		*	}
		*	k.au = function():void {
		*		trace("a pressed up");
		*	}
		*	k.A = function():void {
		*		trace("shift-a pressed");
		*	}
		*	k.ac = function():void {
		*		trace("control-a pressed");
		*	}
		*	k["{"] = function():void {
		*		trace("left curly bracket pressed");
		*	}
		*	
		*	// refer constants of flash.ui.Keyboard class
		*	k.SPACE = function():void {
		*		trace("space key pressed");
		*	}
		*	
		*	// put a regular expression in parentheses to avoid compile error
		*	k[(/.+/)] = function(event:KeyboardEvent, pressedKey:String, regexpResult:*):void {
		*		trace(pressedKey + " has pressed or pressed up");
		*	}
		*	k[(/^(?:NUMPAD_)?(\d)$/)] = function(event:KeyboardEvent, pressedKey:String, regexpResult:*):void {
		*		trace("number " + regexpResult[1] + " pressed");
		*	}
		*	
		*	// or use method
		*	k.set(/.+/, function(event:KeyboardEvent, pressedKey:String, regexpResult:*):void {
		*		trace(pressedKey + " has pressed or pressed up");
		*	});
		*	
		*	// to remove listener function
		*	delete k.a;
		*	
		*	// or
		*	k.a = null;
		*	
		*	*/
		
		protected static var _keys:Dictionary = new Dictionary();
		_keys[Keyboard.BACKSPACE]       = "BACKSPACE";
		_keys[Keyboard.CAPS_LOCK]       = "CAPS_LOCK";
		_keys[Keyboard.CONTROL]         = "CONTROL";
		_keys[Keyboard.DELETE]          = "DELETE";
		_keys[Keyboard.DOWN]            = "DOWN";
		_keys[Keyboard.END]             = "END";
		_keys[Keyboard.ENTER]           = "ENTER";
		_keys[Keyboard.ESCAPE]          = "ESCAPE";
		_keys[Keyboard.F1]              = "F1";
		_keys[Keyboard.F10]             = "F10";
		_keys[Keyboard.F11]             = "F11";
		_keys[Keyboard.F12]             = "F12";
		_keys[Keyboard.F13]             = "F13";
		_keys[Keyboard.F14]             = "F14";
		_keys[Keyboard.F15]             = "F15";
		_keys[Keyboard.F2]              = "F2";
		_keys[Keyboard.F3]              = "F3";
		_keys[Keyboard.F4]              = "F4";
		_keys[Keyboard.F5]              = "F5";
		_keys[Keyboard.F6]              = "F6";
		_keys[Keyboard.F7]              = "F7";
		_keys[Keyboard.F8]              = "F8";
		_keys[Keyboard.F9]              = "F9";
		_keys[Keyboard.HOME]            = "HOME";
		_keys[Keyboard.INSERT]          = "INSERT";
		_keys[Keyboard.LEFT]            = "LEFT";
		_keys[Keyboard.NUMPAD_0]        = "NUMPAD_0";
		_keys[Keyboard.NUMPAD_1]        = "NUMPAD_1";
		_keys[Keyboard.NUMPAD_2]        = "NUMPAD_2";
		_keys[Keyboard.NUMPAD_3]        = "NUMPAD_3";
		_keys[Keyboard.NUMPAD_4]        = "NUMPAD_4";
		_keys[Keyboard.NUMPAD_5]        = "NUMPAD_5";
		_keys[Keyboard.NUMPAD_6]        = "NUMPAD_6";
		_keys[Keyboard.NUMPAD_7]        = "NUMPAD_7";
		_keys[Keyboard.NUMPAD_8]        = "NUMPAD_8";
		_keys[Keyboard.NUMPAD_9]        = "NUMPAD_9";
		_keys[Keyboard.NUMPAD_ADD]      = "NUMPAD_ADD";
		_keys[Keyboard.NUMPAD_DECIMAL]  = "NUMPAD_DECIMAL";
		_keys[Keyboard.NUMPAD_DIVIDE]   = "NUMPAD_DIVIDE";
		_keys[Keyboard.NUMPAD_ENTER]    = "NUMPAD_ENTER";
		_keys[Keyboard.NUMPAD_MULTIPLY] = "NUMPAD_MULTIPLY";
		_keys[Keyboard.NUMPAD_SUBTRACT] = "NUMPAD_SUBTRACT";
		_keys[Keyboard.PAGE_DOWN]       = "PAGE_DOWN";
		_keys[Keyboard.PAGE_UP]         = "PAGE_UP";
		_keys[Keyboard.RIGHT]           = "RIGHT";
		_keys[Keyboard.SHIFT]           = "SHIFT";
		_keys[Keyboard.SPACE]           = "SPACE";
		_keys[Keyboard.TAB]             = "TAB";
		_keys[Keyboard.UP]              = "UP";
		protected static const _regexpExp:RegExp = /^\/(.+)\/([sxgim]*)$/;
		protected static function _makePattern(name:*):* {
			var string:String;
			
			if(name is QName) {
				string = name.localName;
			} else if(name is String) {
				string = name;
			} else {
				string = name.toString();
			}
			
			var result:* = _regexpExp.exec(string);
			
			if(result !== null) {
				return new RegExp(result[1], result[2]);
			} else {
				return string;
			}
		}
		protected static function _getKeyProp(e:KeyboardEvent):String {
			var key:String;
			
			if(_keys[e.keyCode] !== undefined) {
				key = _keys[e.keyCode];
			} else {
				key = String.fromCharCode(e.charCode);
			}
			
			if(e.type === KeyboardEvent.KEY_UP) {
				key += "u";
			}
			if(e.ctrlKey && e.keyCode !== Keyboard.CONTROL) {
				key += "c";
			}
			
			return key;
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _dispatchers:Dictionary = new Dictionary();
		
		protected var _strings:Dictionary = new Dictionary();
		protected var _regexps:Dictionary = new Dictionary();
		protected var _expstrs:Dictionary = new Dictionary();
		
		protected var _props:Array = null; // for enumeration
		
		protected var _priority:int = 0;
		
		public function get dispatchers():Array {
			var r:Array = [];
			for each(var dispatcher:IEventDispatcher in this._dispatchers) {
				r.push(dispatcher);
			}
			return r;
		}
		
		public function get strings():Array {
			var r:Array = [];
			for(var key:String in this._strings) {
				r.push(key);
			}
			return r;
		}
		
		public function get regexps():Array {
			var r:Array = [];
			for(var key:* in this._regexps) {
				r.push(key);
			}
			return r;
		}
		
		public function get props():Array {
			return this.strings.concat(this.regexps);
		}
		
		public function get priority():int {
			return this._priority;
		}
		public function set priority(priority:int):void {
			if(this._priority !== priority) {
				this._priority = priority;
				for each(var dispatcher:IEventDispatcher in this._dispatchers) {
					dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, this._listener);
					dispatcher.removeEventListener(KeyboardEvent.KEY_UP, this._listener);
					dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, this._listener, false, this._priority, false);
					dispatcher.addEventListener(KeyboardEvent.KEY_UP, this._listener, false, this._priority, false);
				}
			}
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function Kapture(dispatcher:IEventDispatcher = null) {
			this.addDispatcher(dispatcher);
		}
		
		/* =========================== */
		/* = Add / Remove Dispatcher = */
		/* =========================== */
		public function addDispatcher(dispatcher:IEventDispatcher):void {
			if(dispatcher === null) {
				return;
			}
			
			if(this._dispatchers[dispatcher] === undefined) {
				dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, this._listener, false, this._priority, false);
				dispatcher.addEventListener(KeyboardEvent.KEY_UP, this._listener, false, this._priority, false);
				this._dispatchers[dispatcher] = dispatcher;
			}
		}
		
		public function removeDispatcher(dispatcher:IEventDispatcher):void {
			if(this._dispatchers[dispatcher] !== undefined) {
				dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, this._listener);
				dispatcher.removeEventListener(KeyboardEvent.KEY_UP, this._listener);
				delete this._dispatchers[dispatcher];
			}
		}
		
		public function hasDispatcher(dispatcher:IEventDispatcher):Boolean {
			return this._dispatchers[dispatcher] !== undefined;
		}
		
		// public function clearDispatcher():void {
		// 	
		// }
		
		/* ======= */
		/* = Set = */
		/* ======= */
		public function set(pattern:*, fn:Function):void {
			if(pattern is String) {
				if(fn === null) {
					delete this._strings[pattern];
				} else {
					this._strings[pattern] = fn;
				}
			} else if(pattern is RegExp) {
				var expstr:String = pattern.toString();
				
				if(fn === null) {
					if(this._expstrs[expstr] !== undefined) {
						delete this._regexps[this._expstrs[expstr]];
						delete this._expstrs[expstr];
					}
				} else {
					if(this._expstrs[expstr] !== undefined) {
						this._regexps[this._expstrs[expstr]] = fn;
					} else {
						this._expstrs[expstr]  = pattern;
						this._regexps[pattern] = fn;
					}
				}
			} else {
				if(fn === null) {
					delete this._strings[pattern.toString()];
				} else {
					this._strings[pattern.toString()] = fn;
				}
			}
		}
		
		public function get(pattern:*):Function {
			if(pattern is String) {
				if(this._strings[pattern] !== undefined) {
					return this._strings[pattern];
				} else {
					return null;
				}
			} else if(pattern is RegExp) {
				var expstr:String = pattern.toString();
				
				if(this._expstrs[expstr] !== undefined) {
					return this._regexps[this._expstrs[expstr]];
				} else {
					return null;
				}
			} else {
				var string:String = pattern.toString();
				
				if(this._strings[string] !== undefined) {
					return this._strings[string];
				} else {
					return null;
				}
			}
		}
		
		public function remove(pattern:*):Boolean {
			if(pattern is String) {
				return delete this._strings[pattern];
			} else if(pattern is RegExp) {
				var expstr:String = pattern.toString();
				
				if(this._expstrs[expstr] !== undefined) {
					delete this._regexps[this._expstrs[expstr]];
				}
				
				return delete this._expstrs[expstr];
			} else {
				return delete this._strings[pattern.toString()];
			}
		}
		
		public function has(pattern:*):Boolean {
			return this.get(pattern) !== null;
		}
		
		// public function clear():void {
		// 	
		// }
		
		/* ========================== */
		/* = KeyboardEvent Listener = */
		/* ========================== */
		protected function _listener(e:KeyboardEvent):void {
			var prop:String = _getKeyProp(e);
			
			if(this._strings[prop] !== undefined) {
				this._strings[prop](e, prop);
			}
			
			var regexp:RegExp;
			var result:*;
			for(var key:* in this._regexps) {
				regexp = RegExp(key);
				result = regexp.exec(prop);
				(result !== null) && this._regexps[regexp](e, prop, result);
			}
		}
		
		/* ========= */
		/* = Proxy = */
		/* ========= */
		flash_proxy override function setProperty(name:*, value:*):void {
			this.set(_makePattern(name), value);
		}
		
		flash_proxy override function getProperty(name:*):* {
			var r:* = this.get(_makePattern(name));
			
			return r;
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean {
			return this.remove(_makePattern(name));
		}
		
		flash_proxy override function hasProperty(name:*):Boolean {
			return this.has(_makePattern(name));
		}
		
		flash_proxy override function nextName(index:int):String {
			return this._props[index - 1];
		}
		
		flash_proxy override function nextNameIndex(index:int):int {
			if(index === 0) {
				this._props = [];
				var prop:String;
				for(prop in this._strings) {
					this._props.push(prop);
				}
				for(prop in this._regexps) {
					this._props.push(prop);
				}
			}
			
			if(index < this._props.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		flash_proxy override function nextValue(index:int):* {
			return this[this._props[index - 1]];
		}
	}
}