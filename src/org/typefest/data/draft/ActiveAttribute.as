/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data.draft {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class ActiveAttribute extends Proxy implements IEventDispatcher {
		protected static function _passKey(name:*, cont:Function, ...args:Array):* {
			var string:String;
			
			if(name is QName) {
				string = name.localName;
			} else if(name is String) {
				string = name;
			} else {
				string = String(name);
			}
			
			var prefix:String;
			var key:String;
			
			if(string.charAt(0) === "$") {
				prefix = "$";
				key    = string.substr(1);
			} else {
				prefix = "";
				key    = string;
			}
			
			args.unshift(prefix, key);
			
			return cont.apply(null, args);
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _ed:EventDispatcher = null;
		
		protected var _news:* = {};
		protected var _olds:* = {};
		
		protected var _changes:* = {};
		
		protected var _buzzy:Boolean = false;
		protected var _buzzes:*      = {};
		
		protected var _enum:Array = null;
		
		public function get buzzy():Boolean {
			return this._buzzy;
		}
		public function set buzzy(bool:Boolean):void {
			this._buzzy = bool;
		}
		
		public function get changing():Boolean {
			for(var key:* in this._changes) {
				return true;
			}
			return false;
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function ActiveAttribute(init:* = null) {
			super();
			
			this._ed = new EventDispatcher(this);
			
			if(init !== null) {
				for(var key:* in init) {
					this._news[key] = this._olds[key] = init[key];
				}
			}
		}
		
		/* ======== */
		/* = Buzz = */
		/* ======== */
		public function setBuzz(key:String, bool:Boolean):void {
			if(bool) {
				this._buzzes[key] = true;
			} else {
				delete this._buzzes[key];
			}
		}
		
		public function getBuzz(key:String):Boolean {
			return key in this._buzzes;
		}
		
		/* ========= */
		/* = Apply = */
		/* ========= */
		public function apply():void {
			var key:String;
			
			var olds:* = {};
			var news:* = {};
			
			var some:Boolean = false;
			
			for(key in this._changes) {
				olds[key] = this._olds[key];
				news[key] = this._olds[key] = this._news[key];
				
				some = true;
			}
			if(!some) {
				return;
			}
			
			this._changes = {};
			
			this._customApply(olds, news);
			
			for(key in olds) {
				this.dispatchEvent(
					new ActiveAttributeEvent(
						"#" + key,
						key,
						olds[key],
						news[key]
					)
				);
			}
			
			this.dispatchEvent(
				new ActiveAttributeEvent(
					ActiveAttributeEvent.UPDATE,
					null,
					null,
					null,
					olds,
					news
				)
			);
		}
		
		protected function _customApply(olds:*, news:*):void {
			
		}
		
		/* ==================== */
		/* = Proxy: Set / Get = */
		/* ==================== */
		flash_proxy override function setProperty(name:*, value:*):void {
			_passKey(name, this._setProperty, value);
		}
		protected function _setProperty(prefix:String, key:String, value:*):void {
			if(prefix === "$") {
				throw new ArgumentError(
					"ActiveAttribute._setProperty: unable to assign it"
				);
			}
			
			if(this._news[key] === value) {
				return;
			}
			
			var lastValue:* = this._news[key];
			
			this._news[key] = value;
			
			if(key in this._olds) {
				if(this._olds[key] !== value) {
					this._changes[key] = true;
				} else {
					delete this._changes[key];
				}
			} else {
				this._changes[key] = true;
			}
			
			if(this._buzzy || this._buzzes[key]) {
				this.dispatchEvent(
					new ActiveAttributeEvent(
						key,
						key,
						lastValue,
						value
					)
				);
				this.dispatchEvent(
					new ActiveAttributeEvent(
						ActiveAttributeEvent.CHANGE,
						key,
						lastValue,
						value
					)
				);
			}
		}
		
		flash_proxy override function getProperty(name:*):* {
			return _passKey(name, this._getProperty);
		}
		protected function _getProperty(prefix:String, key:String):* {
			if(prefix === "$") {
				return this._olds[key];
			} else {
				return this._news[key];
			}
		}
		
		flash_proxy override function hasProperty(name:*):Boolean {
			return _passKey(name, this._hasProperty);
		}
		protected function _hasProperty(prefix:String, key:String):Boolean {
			if(prefix === "$") {
				return key in this._olds;
			} else {
				return key in this._news;
			}
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean {
			return _passKey(name, this._deleteProperty);
		}
		protected function _deleteProperty(prefix:String, key:String):Boolean {
			if(prefix === "$") {
				throw new ArgumentError(
					"ActiveAttribute._setProperty: unable to delete it"
				);
			}
			
			if(key in this._news) {
				if(key in this._olds) {
					this._changes[key] = true;
				} else {
					delete this._changes[key];
				}
				var lastValue:* = this._news[key];
				
				var r:Boolean = delete this._news[key];
				
				if(this._buzzy || this._buzzes[key]) {
					this.dispatchEvent(
						new ActiveAttributeEvent(
							key,
							key,
							lastValue,
							undefined
						)
					);
				}
				return r;
			} else {
				return false;
			}
		}
		
		flash_proxy override function callProperty(name:*, ...args:Array):* {
			args.unshift(name, this._callProperty);
			
			return _passKey.apply(null, args);
		}
		protected function _callProperty(prefix:String, key:String, ...args):* {
			if(prefix === "$") {
				return this._olds[key].apply(null, args);
			} else {
				return this._news[key].apply(null, args);
			}
		}
		
		/* ==================== */
		/* = Proxy: Iteration = */
		/* ==================== */
		flash_proxy override function nextName(index:int):String {
			return this._enum[index - 1];
		}
		flash_proxy override function nextNameIndex(index:int):int {
			if(index === 0) {
				this._enum = [];
				
				for(var key:* in this._news) {
					this._enum.push(key);
				}
			}
			
			if(index < this._enum.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		flash_proxy override function nextValue(index:int):* {
			return this._news[this._enum[index - 1]];
		}
		
		/* =================== */
		/* = EventDispatcher = */
		/* =================== */
		public function addEventListener(
			t:String, l:Function, uc:Boolean = false,
			p:int = 0, uw:Boolean = false
		):void {
			this._ed.addEventListener(t, l, uc, p, uw);
		}
		
		public function dispatchEvent(e:Event):Boolean {
			return this._ed.dispatchEvent(e);
		}
		
		public function hasEventListener(t:String):Boolean {
			return this._ed.hasEventListener(t);
		}
		
		public function removeEventListener(
			t:String, l:Function, uc:Boolean = false
		):void {
			this._ed.removeEventListener(t, l, uc);
		}
		
		public function willTrigger(t:String):Boolean {
			return this._ed.willTrigger(t);
		}
	}
}