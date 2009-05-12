/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data.draft {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.typefest.core.Dict;
	
	public class ActiveListSetEvent extends Event {
		static public const UPDATE:String = "activeListSetEvent.update";
		static public const CHANGE:String = "activeListSetEvent.change";
		
		//---------------------------------------
		// Instance
		//---------------------------------------
		protected var _added:Dictionary  = null;
		protected var _addedKeys:Array   = null;
		protected var _addedValues:Array = null;
		
		protected var _removed:Dictionary  = null;
		protected var _removedKeys:Array   = null;
		protected var _removedValues:Array = null;
		
		protected var _oldLength:int = -1;
		protected var _newLength:int = -1;
		
		public function get added():Dictionary {
			if(this._added === null) {
				return null;
			} else {
				return Dict.copy(this._added);
			}
		}
		public function get addedKeys():Array {
			if(this._addedKeys === null) {
				return null;
			} else {
				return this._addedKeys.concat();
			}
		}
		public function get addedValues():Array{
			if(this._addedValues === null) {
				return null;
			} else {
				return this._addedValues.concat();
			}
		}
		
		public function get removed():Dictionary {
			if(this._removed === null) {
				return null;
			} else {
				return Dict.copy(this._removed);
			}
		}
		public function get removedKeys():Array {
			if(this._removedKeys === null) {
				return null;
			} else {
				return this._removedKeys.concat();
			}
		}
		public function get removedValues():Array {
			if(this._removedValues === null) {
				return null;
			} else {
				return this._removedValues.concat();
			}
		}
		
		public function get oldLength():int {
			return this._oldLength;
		}
		public function get newLength():int {
			return this._newLength;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function ActiveListSetEvent(
			type:String,
			removed:Dictionary = null,
			added:Dictionary = null,
			oldLength:int = -1,
			newLength:int = -1,
			bubbles:Boolean = false,
			cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
			
			this._added   = added;
			this._removed = removed;
			
			this._oldLength = oldLength;
			this._newLength = newLength;
			
			var i:int;
			
			if(added !== null) {
				this._addedKeys   = Dict.keys(added).sort(Array.NUMERIC);
				this._addedValues = [];
				
				for(i = 0; i < this._addedKeys.length; i++) {
					this._addedValues.push(added[this._addedKeys[i]]);
				}
			}
			
			if(removed !== null) {
				this._removedKeys   = Dict.keys(removed).sort(Array.NUMERIC);
				this._removedValues = [];
				
				for(i = 0; i < this._removedKeys.length; i++) {
					this._removedValues.push(removed[this._removedKeys[i]]);
				}
			}
		}
		
		override public function clone():Event {
			return new ActiveListSetEvent(
				this.type,
				this.removed,
				this.added,
				this._oldLength,
				this._newLength,
				this.bubbles,
				this.cancelable
			);
		}
	}
}