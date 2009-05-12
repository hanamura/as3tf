/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
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