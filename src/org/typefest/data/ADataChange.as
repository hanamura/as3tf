/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	public class ADataChange extends AChange {
		static public const SET:String    = "ADataChange.SET";
		static public const CHANGE:String = "ADataChange.CHANGE";
		static public const DELETE:String = "ADataChange.DELETE";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _key:String = null;
		protected var _prev:*     = null;
		protected var _curr:*     = null;
		
		public function get key():String {
			return _key;
		}
		public function get prev():* {
			return _prev;
		}
		public function get curr():* {
			return _curr;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function ADataChange(type:String, key:String, prev:*, curr:*) {
			super(type);
			
			_key  = key;
			_prev = prev;
			_curr = curr;
		}
	}
}