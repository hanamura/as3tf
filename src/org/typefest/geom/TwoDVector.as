/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	public class TwoDVector {
		public var x:Number;
		public var y:Number;
		
		public function TwoDVector(x:Number = 0, y:Number = 0) {
			super();
			
			this.x = x;
			this.y = y;
		}
		
		public function toString():String {
			return "{x:" + this.x + ", " + "y:" + this.y + "}";
		}
	}
}