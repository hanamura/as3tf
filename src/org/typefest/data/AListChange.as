/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	public class AListChange extends AChange {
		static public const ADD:String    = "AListChange.ADD";
		static public const REMOVE:String = "AListChange.REMOVE";
		static public const CHANGE:String = "AListChange.CHANGE";
		
		protected var _prev:Array    = null;
		protected var _curr:Array    = null;
		protected var _method:String = null;
		protected var _args:Array    = null;
		
		public function get prev():Array {
			return _prev && _prev.concat();
		}
		public function get curr():Array {
			return _curr && _curr.concat();
		}
		public function get method():String {
			return _method;
		}
		public function get args():Array {
			return _args && _args.concat();
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function AListChange(
			type:String,
			prev:Array,
			curr:Array,
			method:String,
			args:Array
		) {
			super(type);
			
			_prev   = prev;
			_curr   = curr;
			_method = method;
			_args   = args;
		}
	}
}