/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class AList extends Proxy implements IA {
		static protected function __eq(a:Array, b:Array):Boolean {
			if (a.length !== b.length) {
				return false;
			} else {
				var l:int = a.length;
				
				for (var i:int = 0; i < l; i++) {
					if (a[i] !== b[i]) {
						return false;
					}
				}
				return true;
			}
		}
		static protected function __index(name:*):int {
			if (name is QName) {
				return int(name.localName);
			} else {
				return int(name);
			}
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _a:Array = null;
		
		public function get length():uint {
			return _a.length;
		}
		
		//---------------------------------------
		// depth
		//---------------------------------------
		protected var _depth:int = -1;
		
		public function get depth():int {
			return _depth;
		}
		public function set depth(num:int):void {
			if (_depth !== num) {
				_depth = num;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AList(init:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			_a = [];
			
			if (init is Array) {
				push.apply(null, init);
			} else {
				var _:Array = [];
				for each (var value:* in init) {
					_.push(value);
				}
				push.apply(null, _);
			}
		}
		
		//---------------------------------------
		// push / pop / unshift / shift
		//---------------------------------------
		public function push(...values:Array):uint {
			if (values.length) {
				var prev:Array = _a.concat();
				
				_a.push.apply(null, values);
				
				for each (var value:* in values) {
					if (value is IA) {
						value.addEventListener(AEvent.CHANGE, _aChange, false, 0, true);
					}
				}
				
				_dispatch(prev, _a.concat(), "push", values);
			}
			return _a.length;
		}
		public function pop():* {
			if (_a.length) {
				var prev:Array = _a.concat();
				
				var v:* = _a.pop();
				
				if (v is IA) {
					v.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
				
				_dispatch(prev, _a.concat(), "pop", []);
				
				return v;
			} else {
				return undefined;
			}
		}
		public function unshift(...values:Array):uint {
			if (values.length) {
				var prev:Array = _a.concat();
				
				_a.unshift.apply(null, values);
				
				for each (var value:* in values) {
					if (value is IA) {
						value.addEventListener(AEvent.CHANGE, _aChange, false, 0, true);
					}
				}
				
				_dispatch(prev, _a.concat(), "unshift", values);
			}
			return _a.length;
		}
		public function shift():* {
			if (_a.length) {
				var prev:Array = _a.concat();
				
				var v:* = _a.shift();
				
				if (v is IA) {
					v.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
				
				_dispatch(prev, _a.concat(), "shift", []);
				
				return v;
			} else {
				return undefined;
			}
		}
		
		//---------------------------------------
		// splice
		//---------------------------------------
		public function splice(start:int, del:uint, ...values:Array):Array {
			var prev:Array = _a.concat();
			
			var _:Array = _a.splice.apply(null, [start, del].concat(values));
			
			var value:*;
			
			for each (value in _) {
				if (value is IA) {
					value.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
			}
			for each (value in values) {
				if (value is IA) {
					value.addEventListener(AEvent.CHANGE, _aChange, false, 0, true);
				}
			}
			
			if (!__eq(prev, _a)) {
				_dispatch(prev, _a.concat(), "splice", [start, del].concat(values));
			}
			
			return _;
		}
		
		//---------------------------------------
		// reverse / sort / sortOn
		//---------------------------------------
		public function reverse():Array {
			if (_a.length >= 2) {
				var prev:Array = _a.concat();
				
				_a.reverse();
				
				if (!__eq(prev, _a)) {
					_dispatch(prev, _a.concat(), "reverse", []);
				}
			}
			return _a.concat();
		}
		public function sort(...args:Array):Array {
			if (_a.length >= 2) {
				var prev:Array = _a.concat();
				
				_a.sort.apply(null, args);
				
				if (!__eq(prev, _a)) {
					_dispatch(prev, _a.concat(), "sort", args);
				}
			}
			return _a.concat();
		}
		public function sortOn(name:Object, opt:Object = null):Array {
			if (_a.length >= 2) {
				var prev:Array = _a.concat();
				
				_a.sortOn(name, opt);
				
				if (!__eq(prev, _a)) {
					_dispatch(prev, _a.concat(), "sortOn", [name, opt]);
				}
			}
			return _a.concat();
		}
		
		//---------------------------------------
		// indexOf / lastIndexOf
		//---------------------------------------
		public function indexOf(v:*, i:int = 0):int {
			return _a.indexOf(v, i);
		}
		public function lastIndexOf(v:*, i:int = 0):int {
			return _a.lastIndexOf(v, i);
		}
		
		//---------------------------------------
		// slice
		//---------------------------------------
		public function slice(start:int = 0, end:int = 16777215):Array {
			return _a.slice(start, end);
		}
		
		//---------------------------------------
		// to array
		//---------------------------------------
		public function toArray():Array {
			return _a.concat();
		}
		
		//---------------------------------------
		// to string
		//---------------------------------------
		public function toString():String {
			return "";
		}
		
		//---------------------------------------
		// set / get
		//---------------------------------------
		public function set(index:int, value:*):void {
			var prev:Array = _a.concat();
			
			_a[index] = value;
			
			if (value is IA) {
				value.addEventListener(AEvent.CHANGE, _aChange, false);
			}
			
			if (!__eq(prev, _a)) {
				_dispatch(prev, _a.concat(), "set", [index, value]);
			}
		}
		public function get(index:int):* {
			return _a[index];
		}
		public function has(index:int):Boolean {
			return index in _a;
		}
		public function del(index:int):Boolean {
			var prev:Array = _a.concat();
			
			if (_a[index] is IA) {
				_a[index].removeEventListener(AEvent.CHANGE, _aChange, false);
			}
			
			var _:Boolean = delete _a[index];
			
			if (!__eq(prev, _a)) {
				_dispatch(prev, _a.concat(), "del", [index]);
			}
			
			return _;
		}
		public function call(index:int, ...args:Array):* {
			return _a[index].apply(null, args);
		}
		public function clear():void {
			if (_a.length) {
				var prev:Array = _a.concat();
				
				for each (var value:* in _a) {
					if (value is IA) {
						value.removeEventListener(AEvent.CHANGE, _aChange, false);
					}
				}
				
				_a = [];
				
				_dispatch(prev, [], "clear", []);
			}
		}
		
		//---------------------------------------
		// listener
		//---------------------------------------
		protected function _aChange(e:AEvent):void {
			if (depth < 0 || e.count < depth) {
				dispatchEvent(e.inc());
			}
		}
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		protected function _dispatch(
			prev:Array,
			curr:Array,
			method:String,
			args:Array
		):void {
			dispatchEvent(new AEvent(
				AEvent.CHANGE,
				false,
				false,
				this,
				new AListChange(AListChange.CHANGE, prev, curr, method, args)
			));
		}
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			set(__index(name), value);
		}
		override flash_proxy function getProperty(name:*):* {
			return get(__index(name));
		}
		override flash_proxy function hasProperty(name:*):Boolean {
			return has(__index(name));
		}
		override flash_proxy function deleteProperty(name:*):Boolean {
			return del(__index(name));
		}
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			return call.apply(null, [__index(name)].concat(args));
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			return index < _a.length ? index + 1 : 0;
		}
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		override flash_proxy function nextValue(index:int):* {
			return _a[index - 1];
		}
		
		//---------------------------------------
		// event dispatcher
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