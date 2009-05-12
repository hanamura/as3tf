/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class SortedSet extends Proxy {
		protected static function _makeIndex(name:*):int {
			if(name is QName) {
				return parseInt(name.localName);
			} else {
				return parseInt(name);
			}
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _compare:Function = null;
		protected var _list:Array       = [];
		protected var _dict:Dictionary  = new Dictionary();
		
		public function get compare():Function {
			return this._compare;
		}
		
		public function get length():int {
			return this._list.length;
		}
		
		public function get array():Array {
			return this._list.concat();
		}
		
		public function get first():* {
			return this._list[0];
		}
		
		public function get last():* {
			return this._list[this._list.length - 1];
		}
		
		public function SortedSet(compare:Function) {
			this._compare = compare;
		}
		
		protected function _lookup(data:*):int {
			if(this._list.length <= 0) {
				return 0;
			} else if(this._list.length === 1) {
				return (this._compare(this._list[0], data) <= 0) ? 1 : 0;
			} else if(this._list.length === 2) {
				if(this._compare(this._list[0], data) > 0) {
					return 0;
				} else if(this._compare(this._list[1], data) <= 0) {
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
							index = (this._compare(this._list[start], data) <= 0) ? end : start;
						} else {
							index = (this._compare(this._list[end], data) <= 0) ? end + 1 : end;
						}
						break;
					} else {
						center = Math.floor((start + end) * 0.5);
						
						if(this._compare(this._list[center], data) <= 0) {
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
		
		public function add(data:*):int {
			if(this._dict[data] === undefined) {
				this._dict[data] = true;
				var index:int = this._lookup(data);
				this._list.splice(index, 0, data);
				return index;
			} else {
				return this.index(data);
			}
		}
		
		public function remove(data:*):Boolean {
			if(this._dict[data] !== undefined) {
				this._list.splice(this._list.indexOf(data), 1);
				delete this._dict[data];
				return true;
			} else {
				return false;
			}
		}
		
		public function has(data:*):Boolean {
			return this._dict[data] !== undefined;
		}
		
		public function index(data:*):int {
			return this._list.indexOf(data);
		}
		
		public function get(index:int):* {
			return this._list[index];
		}
		
		public function clear():void {
			this._list = [];
			this._dict = new Dictionary();
		}
		
		public function sub(start:int, len:int = -1):SortedSet {
			var set:SortedSet = new SortedSet(this._compare);
			
			if(len < 0) {
				set._init(this._list.slice(start));
			} else {
				set._init(this._list.slice(start, len + start));
			}
			
			return set;
		}
		
		public function copy():SortedSet {
			var set:SortedSet = new SortedSet(this._compare);
			
			set._init(this._list);
			
			return set;
		}
		
		protected function _init(list:Array):void {
			this._list = list.concat();
			this._dict = new Dictionary();
			
			for each(var data:* in list) {
				this._dict[data] = true;
			}
		}
		
		/* ========= */
		/* = Proxy = */
		/* ========= */
		flash_proxy override function getProperty(name:*):* {
			return this.get(_makeIndex(name));
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean {
			return this.remove(this.get(_makeIndex(name)));
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