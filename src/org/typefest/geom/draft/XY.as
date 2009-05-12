/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom.draft {
	import flash.geom.Point;
	import org.typefest.core.Arr;
	import org.typefest.namespaces.destructive;
	import org.typefest.namespaces.untyped;
	
	public class XY {
		protected static const _DOUBLE_PI:Number = Math.PI * 2;
		
		public static function toPoint(vec:*):Point {
			return new Point(vec.x, vec.y);
		}
		
		public static function toObject(point:Point):* {
			return {x:point.x, y:point.y};
		}
		
		public static function add(...points:Array):Point {
			var x:Number = 0;
			var y:Number = 0;
			
			for each(var point:Point in points) {
				x += point.x;
				y += point.y;
			}
			
			return new Point(x, y);
		}
		untyped static function add(...vecs:Array):* {
			return toObject(add.apply(null, Arr.map(toPoint, vecs)));
		}
		destructive static function add(point:Point, ...adds:Array):void {
			var x:Number = point.x;
			var y:Number = point.y;
			
			for each(var add:Point in adds) {
				x += add.x;
				y += add.y;
			}
			
			point.x = x;
			point.y = y;
		}
		
		public static function sub(point:Point, ...subs:Array):Point {
			var x:Number = point.x;
			var y:Number = point.y;
			
			for each(var sub:Point in subs) {
				x -= sub.x;
				y -= sub.y;
			}
			
			return new Point(x, y);
		}
		untyped static function sub(vec:*, ...subs:Array):* {
			subs.unshift(vec);
			return toObject(sub.apply(null, Arr.map(toPoint, subs)));
		}
		destructive static function sub(point:Point, ...subs:Array):void {
			var x:Number = point.x;
			var y:Number = point.y;
			
			for each(var sub:Point in subs) {
				x -= sub.x;
				y -= sub.y;
			}
			
			point.x = x;
			point.y = y;
		}
		
		public static function mul(point:Point, ...nums:Array):Point {
			var x:Number = point.x;
			var y:Number = point.y;
			
			for each(var num:Number in nums) {
				x *= num;
				y *= num;
			}
			
			return new Point(x, y);
		}
		untyped static function mul(vec:*, ...nums:Array):* {
			nums.unshift(toPoint(vec));
			return toObject(mul.apply(null, nums));
		}
		destructive static function mul(point:Point, ...nums:Array):void {
			var x:Number = point.x;
			var y:Number = point.y;
			
			for each(var num:Number in nums) {
				x *= num;
				y *= num;
			}
			
			point.x = x;
			point.y = y;
		}
		
		public static function div(point:Point, ...nums:Array):Point {
			if(nums.length === 0) {
				return new Point(1 / point.x, 1 / point.y);
			} else {
				var x:Number = point.x;
				var y:Number = point.y;
				var len:int  = nums.length;
				var num:Number;
				
				for(var i:int = 0; i < len; i++) {
					num = nums[i];
					x /= num;
					y /= num;
				}
				
				return new Point(x, y);
			}
		}
		untyped static function div(vec:*, ...nums:Array):* {
			nums.unshift(toPoint(vec));
			return toObject(div.apply(null, nums));
		}
		destructive static function div(point:Point, ...nums:Array):void {
			if(nums.length === 0) {
				point.x = 1 / point.x;
				point.y = 1 / point.y;
			} else {
				var x:Number = point.x;
				var y:Number = point.y;
				var len:int = nums.length;
				var num:Number;
				
				for(var i:int = 0; i < len; i++) {
					num = nums[i];
					x /= num;
					y /= num;
				}
				
				point.x = x;
				point.y = y;
			}
		}
		
		public static function copy(point:Point):Point {
			return new Point(point.x, point.y);
		}
		untyped static function copy(vec:*):* {
			return {x:vec.x, y:vec.y};
		}
		
		public static function magnitude(point:Point):Number {
			var x:Number = point.x;
			var y:Number = point.y;
			
			return Math.sqrt((x * x) + (y * y));
		}
		untyped static function magnitude(vec:*):* {
			return magnitude(toPoint(vec));
		}
		
		public static function distance(p1:Point, p2:Point):Number {
			var subx:Number = p1.x - p2.x;
			var suby:Number = p1.y - p2.y;
			
			return Math.sqrt((subx * subx) + (suby * suby));
		}
		untyped static function distance(v1:*, v2:*):Number {
			return distance(toPoint(v1), toPoint(v2));
		}
		
		public static function between(p1:Point, p2:Point, t:Number = 0.5):Point {
			var x:Number = p1.x + ((p2.x - p1.x) * t);
			var y:Number = p1.y + ((p2.y - p1.y) * t);
			
			return new Point(x, y);
		}
		untyped static function between(v1:*, v2:*, t:Number = 0.5):* {
			return toObject(between(toPoint(v1), toPoint(v2), t));
		}
		
		public static function equal(p1:Point, p2:Point):Boolean {
			return p1.x === p2.x && p1.y === p2.y;
		}
		untyped static function equal(v1:*, v2:*):Boolean {
			return v1.x === v2.x && v1.y === v2.y;
		}
		
		public static function radian(point:Point):Number {
			var x:Number = point.x;
			var y:Number = point.y;
			
			if(x === 0 && y === 0) {
				return 0;
			} else {
				var magnitude:Number = Math.sqrt((x * x) + (y * y));
				var acos:Number      = Math.acos(x / magnitude);
				
				return (y >= 0) ? acos : _DOUBLE_PI - acos;
			}
		}
		untyped static function radian(vec:*):Number {
			return radian(toPoint(vec));
		}
		
		public static function swap(point:Point):Point {
			return new Point(point.y, point.x);
		}
		untyped static function swap(vec:*):* {
			return {x:vec.y, y:vec.x};
		}
		destructive static function swap(point:Point):void {
			var x:Number = point.x;
			point.x = point.y;
			point.y = x;
		}
		
		public static function dot(p1:Point, p2:Point):Number {
			return (p1.x * p2.x) + (p1.y + p2.y);
		}
		untyped static function dot(v1:*, v2:*):Number {
			return (v1.x * v2.x) + (v1.y * v2.y);
		}
		
		public static function cross(p1:Point, p2:Point):Number {
			return (p1.x * p2.y) - (p1.y * p2.x);
		}
		untyped static function cross(v1:*, v2:*):Number {
			return (v1.x * v2.y) - (v1.y * v2.x);
		}
		
		public static function normalize(point:Point):Point {
			var magnitude:Number = XY.magnitude(point);
			
			if(magnitude === 0) {
				return new Point(0, 0);
			} else {
				var mul:Number = 1 / magnitude;
				return new Point(point.x * mul, point.y * mul);
			}
		}
		untyped static function normalize(vec:*):* {
			return toObject(normalize(toPoint(vec)));
		}
		destructive static function normalize(point:Point):void {
			var magnitude:Number = XY.magnitude(point);
			
			if(magnitude !== 0) {
				var mul:Number = 1 / magnitude;
				point.x *= mul;
				point.y *= mul;
			}
		}
		
		public static function compose(radian:Number, magnitude:Number):Point {
			var x:Number = Math.cos(radian) * magnitude;
			var y:Number = Math.sin(radian) * magnitude;
			
			return new Point(x, y);
		}
		untyped static function compose(radian:Number, magnitude:Number):* {
			return toObject(compose(radian, magnitude));
		}
	}
}