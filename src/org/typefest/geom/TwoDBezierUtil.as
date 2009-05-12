/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.geom {
	import org.typefest.core.Arr;
	import org.typefest.core.Fn;
	import org.typefest.core.Num;
	import org.typefest.namespaces.untyped;
	
	public class TwoDBezierUtil {
		/*
		*	TODOs:
		*	
		*	universalize (n)To(n-1)
		*	universalize length()
		*	universalize toPoint()
		*	
		*	NOTICE:
		*	
		*	Functions in this class consider a bezier line as an array of TwoDVectors.
		*	
		*	*/
		
		/*
		*	not so strict
		*	*/
		public static function cubicToPoints(cb:Array, limitLength:Number):Array {
			var length:Number = TwoDBezierUtil.length(cb);
			var divide:int = Math.ceil(length / limitLength);
			var points:Array = [];
			for(var i:int = 0; i <= divide; i++) {
				points.push(TwoDBezierUtil.value(cb, i / divide));
			}
			return points;
		}
		untyped static function cubicToPoints(cb:Array, limitLength:Number):Array {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, cb);
			var r:Array = TwoDBezierUtil.cubicToPoints(t, limitLength);
			return Arr.map(TwoDVectorUtil.toObject, r);
		}
		
		public static function length(cb:Array, acceptable:Number = 1, depth:int = 10):Number {
			var first:TwoDVector  = Arr.first(cb);
			var last:TwoDVector   = Arr.last(cb);
			var lineCenter:TwoDVector   = TwoDPointUtil.between(first, last, 0.5);
			var bezierCenter:TwoDVector = TwoDBezierUtil.value(cb, 0.5);
			if(TwoDPointUtil.distance(lineCenter, bezierCenter) <= acceptable || depth < 1) {
				return TwoDPointUtil.distance(first, last);
			} else {
				var cbs:Array = TwoDBezierUtil.divide(cb);
				return (
					arguments.callee(cbs[0], acceptable, depth - 1) +
					arguments.callee(cbs[1], acceptable, depth - 1));
			}
		}
		untyped static function length(cb:Array, acceptable:Number = 1, depth:int = 10):Number {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, cb);
			return TwoDBezierUtil.length(t, acceptable, depth);
		}
		
		public static function value(b:Array, ratio:Number):TwoDVector {
			if(Arr.empty(b)) {
				throw new ArgumentError("Error: TwoDBezierUtil.value() wants \"b\" to have at least 1 element");
			}
			var between:Function = Fn.reserve(TwoDPointUtil.between, Fn.BLANK, Fn.BLANK, ratio);
			
			var rec:Function = function(b:Array):TwoDVector {
				if(Arr.single(b)) {
					return Arr.first(b);
				} else {
					return arguments.callee(Arr.mapSide(between, b));
				}
			}
			return rec(Arr.map(TwoDVectorUtil.copy, b));
		}
		untyped static function value(b:Array, ratio:Number):Object {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, b);
			var r:TwoDVector = TwoDBezierUtil.value(t, ratio);
			return TwoDVectorUtil.toObject(r);
		}
		
		/*
		*	cont: function(result:Array, next:Function):*
		*	*/
		public static function valuesCont(b:Array, ratio:Number, cont:Function):void {
			if(Arr.empty(b)) {
				throw new ArgumentError("Error: TwoDBezierUtil.valueCont() wants \"b\" to have at least 1 element");
			}
			var between:Function = Fn.reserve(TwoDPointUtil.between, Fn.BLANK, Fn.BLANK, ratio);
			
			var rec:Function = function(b:Array):void {
				var f:Function;
				if(Arr.single(b)) {
					f = null;
				} else {
					f = Fn.reserve(arguments.callee, Arr.map(TwoDVectorUtil.copy, Arr.mapSide(between, b)));
				}
				cont(b, f);
			}
			rec(Arr.map(TwoDVectorUtil.copy, b));
		}
		
		public static function allValues(b:Array, ratio:Number):Array {
			if(Arr.empty(b)) {
				throw new ArgumentError("Error: TwoDBezierUtil.allValues() wants \"b\" to have at least 1 element");
			}
			var between:Function = Fn.reserve(TwoDPointUtil.between, Fn.BLANK, Fn.BLANK, ratio);
			
			var rec:Function = function(acc:Array):Array {
				var b:Array = Arr.last(acc);
				if(Arr.single(b)) {
					return acc;
				} else {
					acc.push(Arr.mapSide(between, b));
					return arguments.callee(acc);
				}
			}
			return rec([Arr.map(TwoDVectorUtil.copy, b)]);
		}
		untyped static function allValues(b:Array, ratio:Number):Array {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, b);
			var r:Array = TwoDBezierUtil.allValues(t, ratio);
			return Arr.mapTree(TwoDVectorUtil.toObject, r);
		}
		
		/* via http://www.noids.tv/2007/02/bspline_10fd.html */
		/* via http://fontforge.sourceforge.net/ja/bezier.html */
		public static function cubicToQuadratics(cb:Array, acceptable:Number = 1, depth:int = 20):Array {
			var cbs:Array;
			var former:Array;
			var latter:Array;
			
			var startEqual:Boolean = TwoDVectorUtil.equal(cb[0], cb[1]);
			var endEqual:Boolean   = TwoDVectorUtil.equal(cb[2], cb[3]);
			var intersect:TwoDVector;
			
			if(startEqual && endEqual) {
				return [
					[cb[0], TwoDPointUtil.between(cb[0], cb[3], 0.5), cb[3]]
				];
			} else if(startEqual) {
				intersect = cb[2];
			} else if(endEqual) {
				intersect = cb[1];
			} else {
				intersect = TwoDLineUtil.intersect(cb[0], cb[1], cb[2], cb[3]);
			}
			
			if(intersect == null) {
				cbs = TwoDBezierUtil.divide(cb);
				former = arguments.callee(cbs[0], acceptable, depth - 1);
				latter = arguments.callee(cbs[1], acceptable, depth - 1);
				return former.concat(latter);
			}
			
			var qb:Array = [cb[0], intersect, cb[3]];
			
			var cbCenter:TwoDVector = TwoDBezierUtil.value(cb, 0.5);
			var qbCenter:TwoDVector = TwoDBezierUtil.value(qb, 0.5);
			
			if(TwoDPointUtil.distance(cbCenter, qbCenter) <= acceptable) {
				return [qb];
			} else if(depth < 1) {
				return [qb];
			} else {
				cbs = TwoDBezierUtil.divide(cb);
				former = arguments.callee(cbs[0], acceptable, depth - 1);
				latter = arguments.callee(cbs[1], acceptable, depth - 1);
				return former.concat(latter);
			}
		}
		untyped static function cubicToQuadratics(cb:Array, acceptable:Number = 1, depth:int = 20):Array {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, cb);
			var r:Array = TwoDBezierUtil.cubicToQuadratics(t, acceptable, depth);
			return Arr.mapTree(TwoDVectorUtil.toObject, r);
		}
		
		public static function divide(b:Array, ratio:Number = 0.5):Array {
			var values:Array = TwoDBezierUtil.allValues(b, ratio);
			return [
				Arr.map(Fn.compose(Arr.first, TwoDVectorUtil.copy), values),
				Arr.reverse(Arr.map(Arr.last, values))
			];
		}
		untyped static function divide(b:Array, ratio:Number):Array {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, b);
			var r:Array = TwoDBezierUtil.divide(t, ratio);
			return Arr.mapTree(TwoDVectorUtil.toObject, r);
		}
		
		public static function divideByRates(b:Array, ...rates:Array):Array {
			var rec:Function = function(b:Array, rates:Array):Array {
				if(Arr.single(rates)) {
					return b;
				} else {
					var ratio:Number = Arr.first(rates) / Num.add.apply(null, rates);
					var divided:Array = TwoDBezierUtil.divide(Arr.last(b), ratio);
					return arguments.callee(Arr.append(Arr.most(b), divided), Arr.rest(rates));
				}
			}
			return rec([Arr.map(TwoDVectorUtil.copy, b)], rates);
		}
		untyped static function divideByRates(b:Array, ...rates:Array):Array {
			var t:Array = Arr.map(TwoDVectorUtil.toVector, b);
			var r:Array = TwoDBezierUtil.divideByRates.apply(null, Arr.append([b], rates));
			return Arr.mapTree(TwoDVectorUtil.toObject, r);
		}
	}
}