/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	public class Bool {
		static public function bool(object:*):Boolean {
			return !!object;
		}
		
		static public function and(...args:Array):Boolean {
			for each (var value:* in args) {
				if (!value) {
					return false;
				}
			}
			return true;
		}
		
		static public function or(...args:Array):Boolean {
			for each (var value:* in args) {
				if (value) {
					return true;
				}
			}
			return false;
		}
		
		public static function random(rate:Number = 0.5):Boolean {
			return Math.random() < rate;
		}
	}
}