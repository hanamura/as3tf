/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class VolumeList extends Proxy {
		protected static function _smaller(a:Number, b:Number):Number {
			return a - b;
		}
		protected static function _makeVolume(name:*):Number {
			if(name is Number) {
				return name;
			} else if(name is QName) {
				return parseFloat(name.localName);
			} else {
				return parseFloat(name);
			}
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _dict:Dictionary = new Dictionary();
		protected var _list:Array      = [];
		
		public function get length():int {
			return this._list.length;
		}
		
		public function get lowest():* {
			return this._toValue(this.lowestKey);
		}
		public function get lowestValue():* {
			return this._toValue(this.lowestKey);
		}
		
		public function get highest():* {
			return this._toValue(this.highestKey);
		}
		public function get highestValue():* {
			return this._toValue(this.highestKey);
		}
		
		public function get lowestKey():Number {
			if(this._list.length > 0) {
				return this._list[0];
			} else {
				return NaN;
			}
		}
		
		public function get highestKey():Number {
			if(this._list.length > 0) {
				return this._list[this._list.length - 1];
			} else {
				return NaN;
			}
		}
		
		public function get values():Array {
			var r:Array = [];
			var len:int = this._list.length;
			
			for(var i:int = 0; i < len; i++) {
				r[i] = this._dict[this._list[i]];
			}
			
			return r;
		}
		
		public function get keys():Array {
			return this._list.concat();
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function VolumeList() {
		}
		
		/* =================== */
		/* = Multiple Return = */
		/* =================== */
		protected function _selectDict(key:*, index:int, array:Array):* {
			return this._dict[key];
		}
		
		public function lowers(volume:Number):Array {
			return this.lowerKeys(volume).map(this._selectDict);
		}
		public function lowerValues(volume:Number):Array {
			return this.lowerKeys(volume).map(this._selectDict);
		}
		
		public function highers(volume:Number):Array {
			return this.higherKeys(volume).map(this._selectDict);
		}
		public function higherValues(volume:Number):Array {
			return this.higherKeys(volume).map(this._selectDict);
		}
		
		public function lowerKeys(volume:Number):Array {
			if(this._list.length <= 0) {
				return [];
			}
			if(this._dict[volume] !== undefined) {
				return this._list.slice(0, this._list.indexOf(volume) + 1);
			} else {
				return this._list.slice(0, this._lookup(volume));
			}
		}
		
		public function higherKeys(volume:Number):Array {
			if(this._list.length <= 0) {
				return [];
			}
			if(this._dict[volume] !== undefined) {
				return this._list.slice(this._list.indexOf(volume));
			} else {
				return this._list.slice(this._lookup(volume));
			}
		}
		
		/* ================= */
		/* = Single Return = */
		/* ================= */
		protected function _toValue(volume:Number):* {
			return isNaN(volume) ? null : this._dict[volume];
		}
		
		public function lower(volume:Number):* {
			return this._toValue(this.lowerKey(volume));
		}
		public function lowerValue(volume:Number):* {
			return this._toValue(this.lowerKey(volume));
		}
		
		public function higher(volume:Number):* {
			return this._toValue(this.higherKey(volume));
		}
		public function higherValue(volume:Number):* {
			return this._toValue(this.higherKey(volume));
		}
		
		public function floor(volume:Number):* {
			return this._toValue(this.floorKey(volume));
		}
		public function floorValue(volume:Number):* {
			return this._toValue(this.floorKey(volume));
		}
		
		public function ceil(volume:Number):* {
			return this._toValue(this.ceilKey(volume));
		}
		public function ceilValue(volume:Number):* {
			return this._toValue(this.ceilKey(volume));
		}
		
		public function near(volume:Number):* {
			return this._toValue(this.nearKey(volume));
		}
		public function nearValue(volume:Number):* {
			return this._toValue(this.nearKey(volume));
		}
		
		protected function _getKey(volume:Number, fn:Function):Number {
			if(this._list.length <= 0) {
				return NaN;
			}
			if(this._dict[volume] !== undefined) {
				return volume;
			}
			return fn(this._lookup(volume), volume);
		}
		
		public function lowerKey(volume:Number):Number {
			return this._getKey(volume, this.__lowerKey);
		}
		protected function __lowerKey(index:int, volume:Number):Number {
			return (index <= 0) ? NaN : this._list[index - 1];
		}
		
		public function higherKey(volume:Number):Number {
			return this._getKey(volume, this.__higherKey);
		}
		protected function __higherKey(index:int, volume:Number):Number {
			return (index >= this._list.length) ? NaN : this._list[index];
		}
		
		public function floorKey(volume:Number):Number {
			return this._getKey(volume, this.__floorKey);
		}
		protected function __floorKey(index:int, volume:Number):Number {
			return (index <= 0) ? this._list[index] : this._list[index - 1];
		}
		
		public function ceilKey(volume:Number):Number {
			return this._getKey(volume, this.__ceilKey);
		}
		protected function __ceilKey(index:int, volume:Number):Number {
			return (index >= this._list.length) ? this._list[index - 1] : this._list[index];
		}
		
		public function nearKey(volume:Number):Number {
			return this._getKey(volume, this.__nearKey);
		}
		protected function __nearKey(index:int, volume:Number):Number {
			if(index <= 0) {
				return this._list[index];
			} else if(index >= this._list.length) {
				return this._list[index - 1];
			} else {
				var floor:Number = this._list[index - 1];
				var ceil:Number  = this._list[index];
				
				return (volume - floor > ceil - volume) ? ceil : floor;
			}
		}
		
		/* ============= */
		/* = Set / Get = */
		/* ============= */
		protected function _lookup(volume:Number):int {
			if(this._list.length <= 0) {
				return 0;
			} else if(this._list.length === 1) {
				return (_smaller(this._list[0], volume) <= 0) ? 1 : 0;
			} else if(this._list.length === 2) {
				if(_smaller(this._list[0], volume) > 0) {
					return 0;
				} else if(_smaller(this._list[1], volume) <= 0) {
					return 2;
				} else {
					return 1;
				}
			} else {
				var start:int    = 0;
				var end:int      = this._list.length - 1;
				var left:Boolean = true;
				var center:int, index:int;
				
				while(true) {
					if(end - start === 1) {
						if(left) {
							index = (_smaller(this._list[start], volume) <= 0) ? end : start;
						} else {
							index = (_smaller(this._list[end], volume) <= 0) ? end + 1 : end;
						}
						break;
					} else {
						center = Math.floor((start + end) * 0.5);
						
						if(_smaller(this._list[center], volume) <= 0) {
							start = center;
							left  = false;
						} else {
							end  = center;
							left = true;
						}
					}
				}
				
				return index;
			}
		}
		
		public function set(volume:Number, data:*):void {
			if(this._dict[volume] === undefined) {
				this._list.splice(this._lookup(volume), 0, volume);
			}
			
			this._dict[volume] = data;
		}
		
		public function get(volume:Number):* {
			if(this._dict[volume] !== undefined) {
				return this._dict[volume];
			} else {
				return null;
			}
		}
		
		public function hasKey(volume:Number):Boolean {
			return this._dict[volume] !== undefined;
		}
		
		public function hasValue(data:*):Boolean {
			for each(var d:* in this._dict) {
				if(d === data) {
					return true;
				}
			}
			return false;
		}
		
		public function remove(volume:Number):Boolean {
			if(this._dict[volume] !== undefined) {
				this._list.splice(this._list.indexOf(volume), 1);
				return delete this._dict[volume];
			} else {
				return false;
			}
		}
		
		public function clear():void {
			this._list = [];
			this._dict = new Dictionary();
		}
		
		public function copy():VolumeList {
			var list:VolumeList = new VolumeList();
			
			list._init(this._list, this._dict);
			
			return list;
		}
		
		protected function _init(list:Array, dict:Dictionary):void {
			this._list = list.concat();
			this._dict = new Dictionary();
			
			for(var key:* in dict) {
				this._dict[key] = dict[key];
			}
		}
		
		/* ========= */
		/* = Proxy = */
		/* ========= */
		flash_proxy override function setProperty(name:*, value:*):void {
			this.set(_makeVolume(name), value);
		}
		
		flash_proxy override function getProperty(name:*):* {
			return this._dict[_makeVolume(name)];
		}
		
		flash_proxy override function hasProperty(name:*):Boolean {
			return this.hasKey(_makeVolume(name));
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean {
			return this.remove(_makeVolume(name));
		}
		
		flash_proxy override function nextNameIndex(index:int):int {
			if(index < this._list.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		flash_proxy override function nextName(index:int):String {
			return (index - 1).toString();
		}
		
		flash_proxy override function nextValue(index:int):* {
			return this._list[index - 1];
		}
	}
}