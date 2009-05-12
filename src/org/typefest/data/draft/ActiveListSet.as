/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data.draft {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import org.typefest.core.Arr;
	import org.typefest.core.Dict;
	
	public class ActiveListSet extends Proxy implements IEventDispatcher {
		protected static function _passIndex(name:*, cont:Function, ...args:Array):* {
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
			
			var index:Number = parseInt(key);
			
			if(isNaN(index) || index < 0) {
				throw new ArgumentError("ActiveListSet._passIndex: error");
			}
			
			args.unshift(prefix, uint(index));
			
			return cont.apply(null, args);
		}
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _ed:EventDispatcher = null;
		
		protected var _olds:Dictionary = null;
		protected var _news:Dictionary = null;
		
		protected var _oldList:Array = null;
		protected var _newList:Array = null;
		
		protected var _buzzy:Boolean = false;
		
		public function get buzzy():Boolean {
			return this._buzzy;
		}
		public function set buzzy(bool:Boolean):void {
			this._buzzy = bool;
		}
		
		public function get $length():Number {
			return this._oldList.length;
		}
		public function get length():Number {
			return this._newList.length;
		}
		
		public function get $array():Array {
			return this._oldList.concat();
		}
		public function get array():Array {
			return this._newList.concat();
		}
		
		public function get changing():Boolean {
			var olds:Dictionary = Dict.copy(this._olds);
			var value:*;
			
			for(value in this._news) {
				if(value in this._olds) {
					delete olds[value];
				} else {
					return true;
				}
			}
			for(value in olds) {
				return true;
			}
			return false;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function ActiveListSet(init:* = null) {
			this._ed = new EventDispatcher(this);
			
			this._olds    = new Dictionary();
			this._news    = new Dictionary();
			this._oldList = [];
			this._newList = [];
			
			for each(var value:* in init) {
				if(!(value in this._olds)) {
					this._olds[value] = this._news[value] = this._oldList.length;
					this._oldList.push(value);
					this._newList.push(value);
				}
			}
		}
		
		//---------------------------------------
		// Apply
		//---------------------------------------
		public function apply():void {
			var removed_temp:Dictionary = Dict.copy(this._olds);
			var added:Dictionary        = null;
			var value:*;
			
			for(value in this._news) {
				if(value in this._olds) {
					delete removed_temp[value];
				} else {
					added || (added = new Dictionary());
					added[this._news[value]] = value;
				}
			}
			
			var removed:Dictionary = null;
			
			for(value in removed_temp) {
				removed || (removed = new Dictionary());
				removed[removed_temp[value]] = value;
			}
			
			var oldLength:int = this._olds.length;
			
			this._olds    = Dict.copy(this._news);
			this._oldList = this._newList.concat();
			
			if(added !== null || removed !== null) {
				this.dispatchEvent(
					new ActiveListSetEvent(
						ActiveListSetEvent.UPDATE,
						removed,
						added,
						oldLength,
						this._newList.length
					)
				);
			}
		}
		
		//---------------------------------------
		// Operations
		//---------------------------------------
		public function append(...values:Array):void {
			var pushes:Array = [];
			
			for each(var value:* in values) {
				if(!(value in this._news)) {
					this._news[value] = this._newList.length + pushes.length;
					pushes.push(value);
				}
			}
			
			if(pushes.length > 0) {
				this._newList.push.apply(null, pushes);
				
				var oldLength:int    = this._newList.length - pushes.length;
				var added:Dictionary = new Dictionary();
				
				for(var i:int = 0; i < pushes.length; i++) {
					added[i + oldLength] = pushes[i];
				}
				
				if(this._buzzy) {
					this.dispatchEvent(
						new ActiveListSetEvent(
							ActiveListSetEvent.CHANGE,
							null,
							added,
							oldLength,
							this._newList.length
						)
					);
				}
			}
		}
		
		public function prepend(...values:Array):void {
			var unshifts:Array = [];
			
			for each(var value:* in values) {
				if(!(value in this._news)) {
					this._news[value] = unshifts.length;
					unshifts.push(value);
				}
			}
			
			if(unshifts.length > 0) {
				for each(value in this._newList.length) {
					this._news[value] += unshifts.length;
				}
				
				this._newList.unshift.apply(null, unshifts);
				
				var added:Dictionary = new Dictionary();
				
				for(var i:int = 0; i < unshifts.length; i++) {
					added[i] = unshifts[i];
				}
				
				if(this._buzzy) {
					this.dispatchEvent(
						new ActiveListSetEvent(
							ActiveListSetEvent.CHANGE,
							null,
							added,
							this._newList.length - unshifts.length,
							this._newList.length
						)
					);
				}
			}
		}
		
		public function pullHead():* {
			var pulled:* = this._newList.shift();
			
			delete this._news[pulled];
			
			for(var value:* in this._news) {
				this._news[value] -= 1;
			}
			
			var removed:Dictionary = new Dictionary();
			removed[0] = pulled;
			
			if(this._buzzy) {
				this.dispatchEvent(
					new ActiveListSetEvent(
						ActiveListSetEvent.CHANGE,
						removed,
						null,
						this._newList.length + 1,
						this._newList.length
					)
				);
			}
			
			return pulled;
		}
		
		public function pullTail():* {
			var pulled:* = this._newList.pop();
			
			delete this._news[pulled];
			
			var removed:Dictionary = new Dictionary();
			removed[this._newList.length] = pulled;
			
			if(this._buzzy) {
				this.dispatchEvent(
					new ActiveListSetEvent(
						ActiveListSetEvent.CHANGE,
						removed,
						null,
						this._newList.length + 1,
						this._newList.length
					)
				);
			}
			
			return pulled;
		}
		
		public function replace(from:int, ...rest:Array):Array {
			var oldLength:int = this._newList.length;
			
			var len:int      = (rest.length > 0) ? rest.shift() : this._newList.length;
			var values:Array = rest.concat();
			var value:*;
			
			var dels:Array = this._newList.splice(from, len);
			
			var news:Dictionary = Dict.copy(this._news);
			for each(value in dels) {
				delete news[value];
			}
			var addables:Array = Arr.filter(function(value:*):Boolean {
				return !(value in news);
			}, values);
			
			this._newList.splice.apply(null, [from, 0].concat(addables));
			
			var i:int;
			
			var removed:Dictionary    = null;
			var removedSet:Dictionary = new Dictionary();
			
			for(i = 0; i < dels.length; i++) {
				removed || (removed = new Dictionary());
				removed[i + from]   = dels[i];
				removedSet[dels[i]] = i + from;
			}
			
			var added:Dictionary    = null;
			var addedSet:Dictionary = new Dictionary();
			
			for(i = 0; i < addables.length; i++) {
				added || (added = new Dictionary());
				added[i + from]       = addables[i];
				addedSet[addables[i]] = i + from;
			}
			
			for(value in removedSet) {
				if(value in addedSet) {
					delete removed[removedSet[value]];
					delete added[addedSet[value]];
				} else {
					delete this._news[value];
				}
			}
			if(Dict.empty(removed)) {
				removed = null;
			}
			if(Dict.empty(added)) {
				added = null;
			}
			
			for(i = 0; i < addables.length; i++) {
				this._news[addables[i]] = i + from;
			}
			if(dels.length !== addables.length) {
				for(i = from + addables.length; i < this._newList.length; i++) {
					this._news[this._newList[i]] = i;
				}
			}
			
			if(added !== null || removed !== null) {
				if(this._buzzy) {
					this.dispatchEvent(
						new ActiveListSetEvent(
							ActiveListSetEvent.CHANGE,
							removed,
							added,
							oldLength,
							this._newList.length
						)
					);
				}
			}
			
			return dels;
		}
		
		// public function remove(...values:Array):void {
		// 	
		// 	for each(var value:* in values) {
		// 		this._news[value]
		// 	}
		// 	
		// }
		
		// public function clear():void {
		// 	// this._olds = new Dictionary();
		// 	// this._news = new Dictionary();
		// 	// 
		// 	// this._oldList = [];
		// 	// this._newList = [];
		// }
		
		//---------------------------------------
		// Utilities
		//---------------------------------------
		public function $has(value:*):Boolean {
			return value in this._olds;
		}
		public function has(value:*):Boolean {
			return value in this._news;
		}
		
		public function $find(value:*):int {
			if(value in this._olds) {
				return this._olds[value];
			} else {
				return -1;
			}
		}
		public function find(value:*):int {
			if(value in this._news) {
				return this._news[value];
			} else {
				return -1;
			}
		}
		
		//---------------------------------------
		// Proxy: Set / Get
		//---------------------------------------
		override flash_proxy function setProperty(name:*, value:*):void {
			_passIndex(name, this._setProperty, value);
		}
		protected function _setProperty(prefix:String, index:int, value:*):void {
			if(prefix === "$") {
				throw new ArgumentError("ActiveListSet._setProperty: error");
			}
			
			if(index < this._newList.length) {
				this.replace(index, 1, value);
			} else {
				throw new ArgumentError("ActiveListSet._setProperty: error");
			}
		}
		
		override flash_proxy function getProperty(name:*):* {
			return _passIndex(name, this._getProperty);
		}
		protected function _getProperty(prefix:String, index:int):* {
			var list:Array = (prefix === "$") ? this._oldList : this._newList;
			
			if(index < list.length) {
				return list[index];
			} else {
				throw new ArgumentError("ActiveListSet._getProperty: error");
			}
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return _passIndex(name, this._hasProperty);
		}
		protected function _hasProperty(prefix:String, index:int):Boolean {
			var list:Array = (prefix === "$") ? this._oldList : this._newList;
			
			return index < list.length;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean {
			return _passIndex(name, this._deleteProperty);
		}
		protected function _deleteProperty(prefix:String, index:int):Boolean {
			if(prefix === "$") {
				throw new ArgumentError("ActiveListSet._deleteProperty: error");
			}
			
			var r:Boolean = index < this._newList.length;
			
			this.replace(index, 1);
			
			return r;
		}
		
		override flash_proxy function callProperty(name:*, ...args:Array):* {
			return _passIndex(name, this._getProperty).apply(null, args);
		}
		
		//---------------------------------------
		// Proxy: Iteration
		//---------------------------------------
		override flash_proxy function nextName(index:int):String {
			return String(index - 1);
		}
		
		override flash_proxy function nextNameIndex(index:int):int {
			if(index < this._newList.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):* {
			return this._newList[index - 1];
		}
		
		//---------------------------------------
		// IEventDispatcher
		//---------------------------------------
		public function addEventListener(
			t:String,
			l:Function,
			uc:Boolean = false,
			p:int = 0,
			uw:Boolean = false
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
			t:String,
			l:Function,
			uc:Boolean = false
		):void {
			this._ed.removeEventListener(t, l, uc);
		}
		
		public function willTrigger(t:String):Boolean {
			return this._ed.willTrigger(t);
		}
		
		//---------------------------------------
		// toString
		//---------------------------------------
		public function toString():String {
			return "[ActiveListSet]";
		}
	}
}