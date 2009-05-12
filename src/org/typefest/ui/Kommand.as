/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package org.typefest.ui {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import flash.utils.Timer;
	
	[Event(name="open", type="flash.events.Event.OPEN")]
	[Event(name="close", type="flash.events.Event.CLOSE")]
	
	dynamic public class Kommand extends Proxy implements IEventDispatcher {
		/*
		*	// usage:
		*	
		*	var k:Kommand = new Kommand(stage);
		*	
		*	k.hello = function():void {
		*		trace('the word, "hello" has been typed');
		*	}
		*	
		*	// put a regular expression in parentheses to avoid compile error
		*	k[(/.+/)] = function(event:KeyboardEvent, typedCommand:String, regexpResult:*):void {
		*		trace(typedCommand + " has been typed");
		*	}
		*	
		*	// or use method
		*	k.set(/.+/, function(event:KeyboardEvent, typedCommand:String, regexpResult:*):void {
		*		trace(typedCommand + " has been typed");
		*	});
		*	
		*	// return false, and capturing is stopped
		*	k.foo = function():Boolean {
		*		trace('the word, "foo" has been typed. and stop capturing');
		*		return false;
		*	}
		*	
		*	// to remove listener function
		*	delete k.hello;
		*	
		*	// or
		*	k.hello = null;
		*	
		*	
		*	
		*	// events:
		*	
		*	// - flash.events.Event.OPEN --- capturing start
		*	// - flash.events.Event.CLOSE --- capturing end
		*	
		*	*/
		
		protected static const _ignores:Dictionary = new Dictionary();
		_ignores[Keyboard.BACKSPACE]       = "BACKSPACE";
		_ignores[Keyboard.CAPS_LOCK]       = "CAPS_LOCK";
		_ignores[Keyboard.CONTROL]         = "CONTROL";
		_ignores[Keyboard.DELETE]          = "DELETE";
		_ignores[Keyboard.DOWN]            = "DOWN";
		_ignores[Keyboard.END]             = "END";
		// _ignores[Keyboard.ENTER]           = "ENTER";
		_ignores[Keyboard.ESCAPE]          = "ESCAPE";
		_ignores[Keyboard.F1]              = "F1";
		_ignores[Keyboard.F10]             = "F10";
		_ignores[Keyboard.F11]             = "F11";
		_ignores[Keyboard.F12]             = "F12";
		_ignores[Keyboard.F13]             = "F13";
		_ignores[Keyboard.F14]             = "F14";
		_ignores[Keyboard.F15]             = "F15";
		_ignores[Keyboard.F2]              = "F2";
		_ignores[Keyboard.F3]              = "F3";
		_ignores[Keyboard.F4]              = "F4";
		_ignores[Keyboard.F5]              = "F5";
		_ignores[Keyboard.F6]              = "F6";
		_ignores[Keyboard.F7]              = "F7";
		_ignores[Keyboard.F8]              = "F8";
		_ignores[Keyboard.F9]              = "F9";
		_ignores[Keyboard.HOME]            = "HOME";
		_ignores[Keyboard.INSERT]          = "INSERT";
		_ignores[Keyboard.LEFT]            = "LEFT";
		// _ignores[Keyboard.NUMPAD_0]        = "NUMPAD_0";
		// _ignores[Keyboard.NUMPAD_1]        = "NUMPAD_1";
		// _ignores[Keyboard.NUMPAD_2]        = "NUMPAD_2";
		// _ignores[Keyboard.NUMPAD_3]        = "NUMPAD_3";
		// _ignores[Keyboard.NUMPAD_4]        = "NUMPAD_4";
		// _ignores[Keyboard.NUMPAD_5]        = "NUMPAD_5";
		// _ignores[Keyboard.NUMPAD_6]        = "NUMPAD_6";
		// _ignores[Keyboard.NUMPAD_7]        = "NUMPAD_7";
		// _ignores[Keyboard.NUMPAD_8]        = "NUMPAD_8";
		// _ignores[Keyboard.NUMPAD_9]        = "NUMPAD_9";
		// _ignores[Keyboard.NUMPAD_ADD]      = "NUMPAD_ADD";
		// _ignores[Keyboard.NUMPAD_DECIMAL]  = "NUMPAD_DECIMAL";
		// _ignores[Keyboard.NUMPAD_DIVIDE]   = "NUMPAD_DIVIDE";
		// _ignores[Keyboard.NUMPAD_ENTER]    = "NUMPAD_ENTER";
		// _ignores[Keyboard.NUMPAD_MULTIPLY] = "NUMPAD_MULTIPLY";
		// _ignores[Keyboard.NUMPAD_SUBTRACT] = "NUMPAD_SUBTRACT";
		_ignores[Keyboard.PAGE_DOWN]       = "PAGE_DOWN";
		_ignores[Keyboard.PAGE_UP]         = "PAGE_UP";
		_ignores[Keyboard.RIGHT]           = "RIGHT";
		_ignores[Keyboard.SHIFT]           = "SHIFT";
		// _ignores[Keyboard.SPACE]           = "SPACE";
		// _ignores[Keyboard.TAB]             = "TAB";
		_ignores[Keyboard.UP]              = "UP";
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
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _dispatchers:Dictionary = new Dictionary();
		protected var _command:String         = "";
		protected var _capturing:Boolean      = false;
		protected var _stopper:Timer          = null;
		
		protected var _strings:Dictionary = new Dictionary();
		protected var _regexps:Dictionary = new Dictionary();
		protected var _expstrs:Dictionary = new Dictionary();
		
		protected var _ed:EventDispatcher = null;
		protected var _props:Array        = null; // for enumeration
		
		protected var _priority:int = 0;
		
		public function get dispatchers():Array {
			var r:Array = [];
			for each(var dispatcher:IEventDispatcher in this._dispatchers) {
				r.push(dispatcher);
			}
			return r;
		}
		
		public function get command():String {
			return this._command;
		}
		
		public function get capturing():Boolean {
			return this._capturing;
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
					dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, this._listener, false, this._priority, false);
				}
			}
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function Kommand(dispatcher:IEventDispatcher = null, delay:Number = 1000) {
			this._ed = new EventDispatcher(this);
			
			this.addDispatcher(dispatcher);
			
			this._stopper = new Timer(delay, 0);
			this._stopper.addEventListener(TimerEvent.TIMER, this._stopperTimer);
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
				this._dispatchers[dispatcher] = dispatcher;
			}
		}
		
		public function removeDispatcher(dispatcher:IEventDispatcher):void {
			if(this._dispatchers[dispatcher] !== undefined) {
				dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, this._listener);
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
			if(_ignores[e.keyCode] !== undefined) {
				return;
			}
			
			var typed:String = String.fromCharCode(e.charCode);
			
			if(this._capturing) {
				this._command += typed;
			} else {
				this._command   = typed;
				this._capturing = true;
				
				this.dispatchEvent(new Event(Event.OPEN));
			}
			
			var reset:Boolean = false;
			
			if(this._strings[this._command] !== undefined) {
				if(this._strings[this._command](e, this._command) === false) {
					reset = true;
				}
			}
			
			var regexp:RegExp;
			var result:*;
			for(var key:* in this._regexps) {
				regexp = RegExp(key);
				result = regexp.exec(this._command);
				if(result !== null) {
					if(this._regexps[regexp](e, this._command, result) === false) {
						reset = true;
					}
				}
			}
			
			if(reset) {
				this._stopper.stop();
				this._capturing = false;
				this.dispatchEvent(new Event(Event.CLOSE));
			} else {
				this._stopper.reset();
				this._stopper.start();
			}
		}
		
		/* =========== */
		/* = Stopper = */
		/* =========== */
		protected function _stopperTimer(e:TimerEvent):void {
			this._stopper.stop();
			this._capturing = false;
			
			this.dispatchEvent(new Event(Event.CLOSE));
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
		
		/* ==================== */
		/* = IEventDispatcher = */
		/* ==================== */
		public function addEventListener(t:String, l:Function, uc:Boolean = false, p:int = 0, uw:Boolean = false):void {
			this._ed.addEventListener(t, l, uc, p, uw);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return this._ed.dispatchEvent(e);
		}
		
		public function hasEventListener(t:String):Boolean {
			return this._ed.hasEventListener(t);
		}
		
		public function removeEventListener(t:String, l:Function, uc:Boolean = false):void {
			this._ed.removeEventListener(t, l, uc);
		}
		
		public function willTrigger(t:String):Boolean {
			return this._ed(t);
		}
	}
}