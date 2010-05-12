/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class ASet extends Proxy implements IA {
		private var __ed:EventDispatcher = null;
		
		protected var _d:Dictionary = null;
		protected var _l:Array      = null;
		
		public function get length():uint {
			return toArray().length;
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
		public function ASet(init:* = null) {
			super();
			
			__ed = new EventDispatcher(this);
			
			_d = new Dictionary();
			
			var values:Array = [];
			
			for each (var value:* in init) {
				values.push(value);
			}
			
			if (values.length) {
				add.apply(null, values);
			}
		}
		
		//---------------------------------------
		// operations
		//---------------------------------------
		public function add(...values:Array):void {
			var dadds:Dictionary = new Dictionary();
			var adds:Array = [];
			var value:*;
			
			for each (value in values) {
				if (!(value in _d) && !(value in dadds)) {
					dadds[value] = true;
					adds.push(value);
				}
			}
			
			var a:IA;
			
			for each (value in adds) {
				_d[value] = true;
				
				if (value is IA) {
					a = value as IA;
					a.addEventListener(
						AEvent.CHANGE,
						_aChange,
						false,
						int.MAX_VALUE,
						true
					);
				}
			}
			
			if (adds.length) {
				_dispatch(ASetChange.ADD, adds, null);
			}
		}
		public function remove(...values:Array):void {
			var dremoves:Dictionary = new Dictionary();
			var removes:Array = [];
			var value:*;
			
			for each (value in values) {
				if (value in _d && !(value in dremoves)) {
					dremoves[value] = true;
					removes.push(value);
				}
			}
			
			var a:IA;
			
			for each (value in removes) {
				delete _d[value];
				
				if (value is IA) {
					a = value as IA;
					a.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
			}
			
			if (removes.length) {
				_dispatch(ASetChange.REMOVE, null, removes);
			}
		}
		public function has(value:*):Boolean {
			return value in _d;
		}
		public function clear():void {
			var removes:Array = [];
			var a:IA;
			
			for (var value:* in _d) {
				removes.push(value);
				
				if (value is IA) {
					a = value as IA;
					a.removeEventListener(AEvent.CHANGE, _aChange, false);
				}
			}
			
			_d = new Dictionary();
			
			if (removes.length) {
				_dispatch(ASetChange.REMOVE, null, removes);
			}
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _dispatch(type:String, adds:Array, removes:Array):void {
			dispatchEvent(new AEvent(
				AEvent.CHANGE,
				false,
				false,
				this,
				new ASetChange(type, adds, removes)
			));
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
		
		public function toArray():Array {
			var _:Array = [];
			for (var key:* in _d) {
				_.push(key);
			}
			return _;
		}
		
		public function toDict(weakKeys:Boolean = false):Dictionary {
			var _:Dictionary = new Dictionary(weakKeys);
			for (var key:* in _d) {
				_[key] = true;
			}
			return _;
		}
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_l = [];
				for (var value:* in _d) {
					_l.push(value);
				}
			}
			
			if (index < _l.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextValue(index:int):* {
			return _l[index - 1];
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