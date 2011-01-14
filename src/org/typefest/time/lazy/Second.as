/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.lazy {
	internal class Second extends Object {
		public var f:Function  = null;
		public var time:Number = 0;

		public function Second(f:Function, time:Number) {
			this.f    = f;
			this.time = time;
		}
	}
}