/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data.draft {
	import flash.events.Event;
	
	public class ActiveAttributeEvent extends Event {
		public static const CHANGE:String = "activeAttributeEvent.change";
		public static const UPDATE:String = "activeAttributeEvent.update";
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _key:String  = null;
		protected var _oldValue:*  = null;
		protected var _newValue:*  = null;
		protected var _olds:Object = null;
		protected var _news:Object = null;
		
		public function get key():String {
			return this._key;
		}
		public function get oldValue():* {
			return this._oldValue;
		}
		public function get newValue():* {
			return this._newValue;
		}
		public function get olds():Object {
			var r:Object = {};
			
			for(var key:String in this._olds) {
				r[key] = this._olds[key];
			}
			return r;
		}
		public function get news():Object {
			var r:Object = {};
			
			for(var key:String in this._news) {
				r[key] = this._news[key];
			}
			return r;
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function ActiveAttributeEvent(
			type:String,
			key:String = null,
			oldValue:* = null,
			newValue:* = null,
			olds:Object = null,
			news:Object = null,
			bubbles:Boolean = false,
			cancelable:Boolean = false
		) {
			super(type, bubbles, cancelable);
			
			this._key      = key;
			this._oldValue = oldValue;
			this._newValue = newValue;
			this._olds     = olds;
			this._news     = news;
		}
		
		public override function clone():Event {
			return new ActiveAttributeEvent(
				this.type,
				this.oldValue,
				this.newValue,
				this.olds,
				this.news,
				this.bubbles,
				this.cancelable
			);
		}
	}
}