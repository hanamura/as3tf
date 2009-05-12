/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.Dictionary;
	
	public class MutualDict {
		protected var _leftKeys:Dictionary  = null;
		protected var _rightKeys:Dictionary = null;
		protected var _weakKeys:Boolean     = false;
		
		public function get lefts():Array {
			var keys:Array = [];
			
			for(var key:* in this._leftKeys) {
				keys.push(key);
			}
			
			return keys;
		}
		
		public function get rights():Array {
			var keys:Array = [];
			
			for(var key:* in this._rightKeys) {
				keys.push(key);
			}
			
			return keys;
		}
		
		public function get length():int {
			var length:int = 0;
			
			for(var key:* in this._leftKeys) {
				length++;
			}
			
			return length;
		}
		
		public function get arrays():Array {
			var arrays:Array = [];
			
			for(var key:* in this._leftKeys) {
				arrays.push([key, this._leftKeys[key]]);
			}
			
			return arrays;
		}
		
		public function get objects():Array {
			var objects:Array = [];
			
			for(var key:* in this._leftKeys) {
				objects.push({left:key, right:this._leftKeys[key]});
			}
			
			return objects;
		}
		
		public function MutualDict(weakKeys:Boolean = false) {
			this._leftKeys  = new Dictionary(weakKeys);
			this._rightKeys = new Dictionary(weakKeys);
			this._weakKeys  = weakKeys;
		}
		
		public function set(left:*, right:*):Boolean {
			if(left === undefined || right === undefined) {
				return false;
			}
			if(this._leftKeys[left] !== undefined || this._rightKeys[right] !== undefined) {
				return false;
			}
			
			this._leftKeys[left]   = right;
			this._rightKeys[right] = left;
			
			return true;
		}
		
		public function setByLeft(left:*, right:*):Boolean {
			if(left === undefined || right === undefined) {
				return false;
			}
			if(this._rightKeys[right] !== undefined) {
				return false;
			}
			
			this._leftKeys[left]   = right;
			this._rightKeys[right] = left;
			
			return true;
		}
		
		public function setByRight(left:*, right:*):Boolean {
			if(left === undefined || right === undefined) {
				return false;
			}
			if(this._leftKeys[left] !== undefined) {
				return false;
			}
			
			this._leftKeys[left]   = right;
			this._rightKeys[right] = left;
			
			return true;
		}
		
		public function getByLeft(left:*):* {
			return this._leftKeys[left];
		}
		
		public function getByRight(right:*):* {
			return this._rightKeys[right];
		}
		
		public function hasLeft(left:*):Boolean {
			return this._leftKeys[left] !== undefined;
		}
		
		public function hasRight(right:*):Boolean {
			return this._rightKeys[right] !== undefined;
		}
		
		public function has(data:*):Boolean {
			return this._leftKeys[data] !== undefined || this._rightKeys[data] !== undefined;
		}
		
		public function removeByLeft(left:*):Boolean {
			if(this._leftKeys[left] !== undefined) {
				return delete this._leftKeys[left];
			} else {
				return false;
			}
		}
		
		public function removeByRight(right:*):Boolean {
			if(this._rightKeys[right] !== undefined) {
				return delete this._rightKeys[right];
			} else {
				return false;
			}
		}
		
		public function clear():void {
			this._leftKeys  = new Dictionary(this._weakKeys);
			this._rightKeys = new Dictionary(this._weakKeys);
		}
		
		public function copy():MutualDict {
			var dict:MutualDict = new MutualDict(this._weakKeys);
			
			dict._init(this._leftKeys);
			
			return dict;
		}
		
		protected function _init(left:Dictionary):void {
			this._leftKeys  = new Dictionary(this._weakKeys);
			this._rightKeys = new Dictionary(this._weakKeys);
			
			for(var key:* in left) {
				this._leftKeys[key]        = left[key];
				this._rightKeys[left[key]] = key;
			}
		}
	}
}