/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.lazy {
	internal class Frame extends Object {
		public var f:Function = null;
		public var count:int  = 0;

		public function Frame(f:Function, count:int) {
			this.f     = f;
			this.count = count;
		}
	}
}