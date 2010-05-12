/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	public class TwoDCircle {
		public var position:TwoDVector;
		public var radius:Number;
		
		public function TwoDCircle(position:TwoDVector = null, radius:Number = 0) {
			super();
			
			this.position = (position == null) ? new TwoDVector(0, 0) : position;
			this.radius = radius;
		}
		
		public function toString():String {
			return "{radius:" + this.radius + ", position:" + this.position.toString() + "}";
		}
	}
}