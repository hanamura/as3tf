/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	import org.typefest.core.Arr;
	import org.typefest.namespaces.untyped;
	
	public class TwoDPointUtil {
		public static function between(start:TwoDVector, end:TwoDVector, ratio:Number):TwoDVector {
			return new TwoDVector(start.x + ((end.x - start.x) * ratio), start.y + ((end.y - start.y) * ratio));
		}
		untyped static function between(start:*, end:*, ratio:Number):Object {
			return {x:start.x + ((end.x - start.x) * ratio), y:start.y + ((end.y - start.y) * ratio)}
		}
		
		public static function distance(p:TwoDVector, q:TwoDVector):Number {
			var w:Number = (q.x - p.x);
			var h:Number = (q.y - p.y);
			return Math.sqrt((w * w) + (h * h));
		}
		untyped static function distance(p:*, q:*):Number {
			var w:Number = (q.x - p.x);
			var h:Number = (q.y - p.y);
			return Math.sqrt((w * w) + (h * h));
		}
		
		public static function clockwiseRadian(a:TwoDVector, b:TwoDVector, c:TwoDVector):Number {
			var radian:Number = TwoDPointUtil.smallerRadian(a, b, c);
			if(TwoDUtil.side(a, c, b) == TwoDUtil.LEFT) {
				radian = (Math.PI * 2) - radian;
			}
			return radian;
		}
		untyped static function clockwiseRadian(a:*, b:*, c:*):Number {
			return TwoDPointUtil.clockwiseRadian.apply(null, Arr.map(TwoDVectorUtil.toVector, [a, b, c]));
		}
		
		public static function smallerRadian(a:TwoDVector, b:TwoDVector, c:TwoDVector):Number {
			return TwoDVectorUtil.radian(TwoDVectorUtil.sub(a, b), TwoDVectorUtil.sub(c, b));
		}
		untyped static function smallerRadian(a:*, b:*, c:*):Number {
			return TwoDPointUtil.smallerRadian.apply(null, Arr.map(TwoDVectorUtil.toVector, [a, b, c]));
		}
	}
}
