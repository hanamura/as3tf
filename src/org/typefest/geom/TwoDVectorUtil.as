/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	import org.typefest.namespaces.untyped;
	
	public class TwoDVectorUtil {
		/*
		*	TODOs:
		*	
		*	div
		*	reflect
		*	
		*	*/
		
		public static function toVector(v:*):TwoDVector {
			return new TwoDVector(v.x, v.y);
		}
		
		public static function toObject(v:TwoDVector):Object {
			return {x:v.x, y:v.y};
		}
		
		public static function copy(v:TwoDVector):TwoDVector {
			return new TwoDVector(v.x, v.y);
		}
		untyped static function copy(v:*):Object {
			return {x:v.x, y:v.y};
		}
		
		public static function add(v1:TwoDVector, v2:TwoDVector):TwoDVector {
			return new TwoDVector(v1.x + v2.x, v1.y + v2.y);
		}
		untyped static function add(v1:*, v2:*):Object {
			return {x:v1.x + v2.x, y:v1.y + v2.y};
		}
		
		public static function sub(v1:TwoDVector, v2:TwoDVector):TwoDVector {
			return new TwoDVector(v1.x - v2.x, v1.y - v2.y);
		}
		untyped static function sub(v1:*, v2:*):Object {
			return {x:v1.x - v2.x, y:v1.y - v2.y};
		}
		
		public static function mul(v:TwoDVector, num:Number):TwoDVector {
			return new TwoDVector(v.x * num, v.y * num);
		}
		untyped static function mul(v:TwoDVector, num:Number):Object {
			return {x:v.x * num, y:v.y * num};
		}
		
		public static function normalize(v:TwoDVector):TwoDVector {
			var magnitude:Number = TwoDVectorUtil.magnitude(v);
			if(magnitude == 0) {
				return new TwoDVector(0, 0);
			} else {
				return TwoDVectorUtil.mul(v, 1 / magnitude);
			}
		}
		untyped static function normalize(v:*):Object {
			var r:TwoDVector = TwoDVectorUtil.normalize(TwoDVectorUtil.toVector(v));
			return {x:r.x, y:r.y};
		}
		
		public static function magnitude(v:TwoDVector):Number {
			return Math.sqrt((v.x * v.x) + (v.y * v.y));
		}
		untyped static function magnitude(v:*):Number {
			return Math.sqrt((v.x * v.x) + (v.y * v.y));
		}
		
		public static function dot(v1:TwoDVector, v2:TwoDVector):Number {
			return (v1.x * v2.x) + (v1.y * v2.y);
		}
		untyped static function dot(v1:*, v2:*):Number {
			return (v1.x * v2.x) + (v1.y * v2.y);
		}
		
		public static function cross(v1:TwoDVector, v2:TwoDVector):Number {
			return (v1.x * v2.y) - (v1.y * v2.x);
		}
		untyped static function cross(v1:*, v2:*):Number {
			return (v1.x * v2.y) - (v1.y * v2.x);
		}
		
		public static function equal(v1:TwoDVector, v2:TwoDVector):Boolean {
			return (v1.x == v2.x && v1.y == v2.y);
		}
		untyped static function equal(v1:*, v2:*):Boolean {
			return (v1.x == v2.x && v1.y == v2.y);
		}
		
		public static function radian(v1:TwoDVector, v2:TwoDVector):Number {
			return Math.acos(TwoDVectorUtil.dot(v1, v2) / (TwoDVectorUtil.magnitude(v1) * TwoDVectorUtil.magnitude(v2)));
		}
		
		public static function compose(radian:Number, magnitude:Number):TwoDVector {
			var x:Number = Math.cos(radian) * magnitude;
			var y:Number = Math.sin(radian) * magnitude;
			
			return new TwoDVector(x, y);
		}
	}
}