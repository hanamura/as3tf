/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.core {
	public class Bool {
		/*
		*	TODOs
		*	
		*	*/
		
		public static function and(...args:Array):Boolean {
			var len:int = args.length;
			for(var i:int = 0; i < len; i++) {
				if(!args[i]) {
					return false;
				}
			}
			return true;
		}
		
		public static function or(...args:Array):Boolean {
			var len:int = args.length;
			for(var i:int = 0; i < len; i++) {
				if(args[i]) {
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