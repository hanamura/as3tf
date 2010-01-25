/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	public class AChange extends Object {
		protected var _type:String = null;

		public function get type():String {
			return _type;
		}
		
		public function AChange(type:String) {
			super();
			
			_type = type;
		}
	}
}