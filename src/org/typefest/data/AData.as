/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/*
	
	// an alternative class to mx.utils.ObjectProxy
	
	*/
	public class AData extends Proxy implements IEventDispatcher, IA {
		static protected function __key(name:*):String {
			if (name is QName) {
				return name.localName;
			} else {
				return String(name);
			}
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		private var __ed:EventDispatcher = null;
		
		protected var _o:*     = null;
		protected var _l:Array = null;
		
		//---------------------------------------
		// key event
		//---------------------------------------
		protected var _keyEvent:Boolean = false;
		
		public function get keyEvent():Boolean {
			return _keyEvent;
		}
		public function set keyEvent(bool:Boolean):void {
			if (_keyEvent !== bool) {
				_keyEvent = bool;
			}
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
		public function AData(init:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			_o = {};
			
			for (var key:String in init) {
				an::set(key, init[key]);
			}
		}
		
		//---------------------------------------
		// operations
		//---------------------------------------
		an function set(key:String, value:*):void {
			if (key in _o) {
				if (_o[key] !== value) {
					var prev:* = _o[key];
					
					if (prev is IA) {
						prev.removeEventListener(AEvent.CHANGE, _aChange, false);
					}
					
					_o[key] = value;
					
					if (value is IA) {
						value.addEventListener(AEvent.CHANGE, _aChange, false, 0, true);
					}
					
					_dispatch(ADataChange.CHANGE, key, prev, value);
				}
			} else {
				_o[key] = value;
				
				if (value is IA) {
					value.addEventListener(AEvent.CHANGE, _aChange, false, 0, true);
				}
				
				_dispatch(ADataChange.SET, key, undefined, value);
			}
		}
		an function get(key:String):* {
			return _o[key];
		}
		an function call(key:String, ...args:Array):* {
			if (key in _o && _o[key] is Function) {
				return _o[key].apply(null, args);
			} else {
				throw new IllegalOperationError("Not a function.");
			}
		}
		an function del(key:String):Boolean {
			if (key in _o) {
				var prev:* = _o[key];
				
				delete _o[key];
				
				if (prev is IA) {
					prev.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
				
				_dispatch(ADataChange.DELETE, key, prev, undefined);
			}
			return true;
		}
		an function has(key:String):Boolean {
			return key in _o;
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _dispatch(type:String, key:String, prev:*, curr:*):void {
			dispatchEvent(new AEvent(
				AEvent.CHANGE,
				false,
				false,
				this,
				new ADataChange(type, key, prev, curr)
			));
			
			if (keyEvent) {
				dispatchEvent(new AEvent(
					AEvent.PREFIX + key,
					false,
					false,
					this,
					new ADataChange(type, key, prev, curr)
				));
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
		// to string
		//---------------------------------------
		public function toString():String {
			return "";
		}
		
		public function toObject():* {
			var _:* = {};
			for (var key:String in _o) {
				_[key] = _o[key];
			}
			return _;
		}
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			an::set(__key(name), value);
		}
		override flash_proxy function getProperty(name:*):* {
			return an::get(__key(name));
		}
		override flash_proxy function hasProperty(name:*):Boolean {
			return an::has(__key(name));
		}
		override flash_proxy function callProperty(name:*, ...values:Array):* {
			return an::call.apply(null, [__key(name)].concat(values));
		}
		override flash_proxy function deleteProperty(name:*):Boolean {
			return an::del(__key(name));
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_l = [];
				for (var key:String in _o) {
					_l.push(key);
				}
			}
			
			if (index < _l.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextName(index:int):String {
			return _l[index - 1];
		}
		override flash_proxy function nextValue(index:int):* {
			return _o[_l[index - 1]];
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