/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	public class TwoDCircleUtil {
		public static const TWO_PI:Number  = Math.PI * 2;
		public static const HALF_PI:Number = Math.PI * 0.5;
		
		public static function copy(c:TwoDCircle):TwoDCircle {
			return new TwoDCircle(TwoDVectorUtil.copy(c.position), c.radius);
		}
		
		/* via http://nutsu.com/blog/2007/092501_as_circletest.html */
		/* not implemented yet! */
		public static function intersect(c1:TwoDCircle, c2:TwoDCircle):Array {
			throw new Error("Error: TwoDCircleUtil.intersect() has not been implemented yet!");
			
			var dist:Number = TwoDPointUtil.distance(c1.position, c2.position);
			var rsum:Number = c1.radius + c2.radius;
			var rsub:Number = Math.abs(c1.radius - c2.radius);
			if(dist > rsum || dist == 0 || dist < rsub) {
				return [];
			} else if(dist == rsub) {
				/* not yet */return [];
			} else if(dist == rsum) {
				return [TwoDPointUtil.between(c1.position, c2.position, c1.radius / rsum)];
			} else {
				var t:Number = ((c1.radius * c1.radius) - (c2.radius * c2.radius) + (dist * dist)) / (dist * 2);
				var v:TwoDVector = TwoDVectorUtil.sub(c2.position, c1.position);
				var rad:Number = Math.acos(t / c1.radius);
				var vrad:Number = Math.atan2(v.y, v.x);
				
				var p1:TwoDVector = new TwoDVector(
					c1.position.x + (Math.cos(vrad + rad) * c1.radius),
					c1.position.y + (Math.sin(vrad + rad) * c1.radius));
				var p2:TwoDVector = new TwoDVector(
					c1.position.x + (Math.cos(vrad - rad) * c1.radius),
					c1.position.y + (Math.sin(vrad - rad) * c1.radius));
				
				return [p1, p2];
			}
		}
		
		public static function circumference(c:TwoDCircle):Number {
			return 2 * Math.PI * c.radius;
		}
		
		public static function value(c:TwoDCircle, radian:Number):TwoDVector {
			return new TwoDVector(
				(Math.cos(radian) * c.radius) + c.position.x,
				(Math.sin(radian) * c.radius) + c.position.y);
		}
	}
}