/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	import org.typefest.namespaces.untyped;
	
	public class TwoDLineUtil {
		public static function intersect(p1:TwoDVector, p2:TwoDVector, q1:TwoDVector, q2:TwoDVector):TwoDVector {
			var pa:Number = (p2.y - p1.y) / (p2.x - p1.x);
			var qa:Number = (q2.y - q1.y) / (q2.x - q1.x);
			
			if(pa == qa) {
				return null; // does not exist because they are parallel
			}
			
			var x:Number;
			var y:Number;
			var qb:Number = q1.y - (qa * q1.x);
			var pb:Number = p1.y - (pa * p1.x);
			
			if(pa == Infinity || pa == -Infinity) {
				x  = p1.x;
				y  = (qa * x) + qb;
			} else if(qa == Infinity || qa == -Infinity) {
				x  = q1.x;
				y  = (pa * x) + pb;
			} else {
				x = (pb - qb) / (qa - pa);
				y = (pa * x) + pb;
			}
			
			return new TwoDVector(x, y);
		}
		untyped static function intersect(p1:*, p2:*, q1:*, q2:*):Object {
			var v:TwoDVector = TwoDLineUtil.intersect(
				new TwoDVector(p1.x, p1.y),
				new TwoDVector(p2.x, p2.y),
				new TwoDVector(q1.x, q1.y),
				new TwoDVector(q2.x, q2.y)
			);
			return {x:v.x, y:v.y};
		}
	}
}