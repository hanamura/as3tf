/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	import org.typefest.core.Arr;
	import org.typefest.core.Num;
	import org.typefest.namespaces.untyped;
	
	public class TwoDUtil {
		/*
		*	TODOs:
		*	
		*	divideIntoConvex
		*	validatePolygon
		*	
		*	*/
		
		public static const LEFT:int   = 1;
		public static const CENTER:int = 0;
		public static const RIGHT:int  = -1;
		
		public static function toAngle(radian:Number):Number {
			return radian * (180 / Math.PI);
		}
		
		public static function toRadian(angle:Number):Number {
			return angle * (Math.PI / 180);
		}
		
		public static function side(start:TwoDVector, end:TwoDVector, target:TwoDVector):int {
			var startEnd:TwoDVector    = new TwoDVector(end.x - start.x, end.y - start.y);
			var startTarget:TwoDVector = new TwoDVector(target.x - start.x, target.y - start.y);
			
			return Num.sign(TwoDVectorUtil.cross(startTarget, startEnd));
		}
		untyped static function side(start:*, end:*, target:*):int {
			return TwoDUtil.side(
				new TwoDVector(start.x, start.y),
				new TwoDVector(end.x, end.y),
				new TwoDVector(target.x, target.y));
		}
		
		public static function inside(
			a:TwoDVector, b:TwoDVector, c:TwoDVector, p:TwoDVector, includeLine:Boolean):Boolean {
			
			var sides:Array = [TwoDUtil.side(a, b, p), TwoDUtil.side(b, c, p), TwoDUtil.side(c, a, p)];
			if(includeLine && Arr.has(TwoDUtil.CENTER, sides)) {
				if(Arr.count(TwoDUtil.CENTER, sides) == 2) {
					return true;
				} else {
					var rest:Array = Arr.remove(TwoDUtil.CENTER, sides);
					if(rest[0] == rest[1]) {
						return true;
					} else {
						return false;
					}
				}
			} else {
				if(sides[0] == sides[1] && sides[1] == sides[2]) {
					return true;
				} else {
					return false;
				}
			}
		}
		untyped static function inside(a:*, b:*, c:*, p:*, includeLine:Boolean):Boolean {
			return TwoDUtil.inside(
				new TwoDVector(a.x, a.y),
				new TwoDVector(b.x, b.y),
				new TwoDVector(c.x, c.y),
				new TwoDVector(p.x, p.y),
				includeLine);
		}
		
		public static function concave(vertices:Array):Boolean {
			var len:int = vertices.length;
			if(len < 3) {
				throw new ArgumentError("Error: TwoDUtil.concave() needs at least 3 vertices.");
			}
			
			var side:int;
			var start:TwoDVector;
			var target:TwoDVector;
			var end:TwoDVector;
			
			for(var i:int = 0; i < len; i++) {
				start  = vertices[((i - 1) + len) % len];
				target = vertices[i];
				end    = vertices[(i + 1) % len];
				
				if(i == 0) {
					side = TwoDUtil.side(start, end, target);
				} else {
					if(side != TwoDUtil.side(start, end, target)) {
						return true;
					}
				}
			}
			
			return false;
		}
		untyped static function concave(vertices:Array):Boolean {
			return TwoDUtil.concave(Arr.map(function(v:*):TwoDVector {
				return new TwoDVector(v.x, v.y);
			}, vertices));
		}
		
		/*　via http://son-son.sakura.ne.jp/programming/post_67.html　*/
		public static function divideIntoTriangles(vertices:Array):Array {
			if(vertices.length < 3) {
				throw new ArgumentError("Error: TwoDUtil.divideIntoTriangles() needs at least 3 vertices.");
			}
			
			var furthest:TwoDVector = Arr.best(function(a:TwoDVector, b:TwoDVector):TwoDVector {
				return (
					TwoDPointUtil.distance(new TwoDVector(0, 0), a) >
					TwoDPointUtil.distance(new TwoDVector(0, 0), b)) ? a : b;
			}, vertices);
			var curr:int = vertices.indexOf(furthest);
			var prev:int = Num.loop(curr - 1, 0, vertices.length);
			var next:int = Num.loop(curr + 1, 0, vertices.length);
			var direction:int = TwoDUtil.side(vertices[prev], vertices[next], vertices[curr]);
			var increase:Function = function(length:int):void {
				prev = Num.loop(prev + 1, 0, length);
				curr = Num.loop(curr + 1, 0, length);
				next = Num.loop(next + 1, 0, length);
			}
			
			var rec:Function = function(vertices:Array, acc:Array):Array {
				if(vertices.length == 3) {
					acc.push(vertices);
					return acc;
				}
				
				prev = 0;
				curr = 1;
				next = 2;
				
				tryVertices: while(true) {
					if(TwoDUtil.side(vertices[prev], vertices[next], vertices[curr]) != direction) {
						increase(vertices.length);
						continue;
					}
					
					var checkees:Array = Arr.filter(function(v:TwoDVector):Boolean {
						return (v != vertices[prev] && v != vertices[curr] && v != vertices[next]);
					}, vertices);
					
					for(var i:int = 0; i < checkees.length; i++) {
						if(TwoDUtil.inside(vertices[prev], vertices[curr], vertices[next], checkees[i], true)) {
							increase(vertices.length);
							continue tryVertices;
						}
					}
					
					break;
				}
				
				acc.push([vertices[prev], vertices[curr], vertices[next]]);
				return arguments.callee(Arr.remove(vertices[curr], vertices), acc);
			}
			
			return rec(Arr.map(TwoDVectorUtil.copy, vertices), []);
		}
		untyped static function divideIntoTriangles(vertices:Array):Array {
			var translatedVertices:Array = Arr.map(function(v:*):TwoDVector {
				return new TwoDVector(v.x, v.y);
			}, vertices);
			var triangles:Array = TwoDUtil.divideIntoTriangles(translatedVertices);
			return Arr.mapTree(function(v:TwoDVector):Object {
				return {x:v.x, y:v.y};
			}, triangles);
		}
	}
}