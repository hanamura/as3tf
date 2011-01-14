/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class DOC {
		
		public static function addTop(
			parent:DisplayObjectContainer,
			addee:DisplayObject
		):DisplayObject {
			return parent.addChild(addee);
		}
		
		public static function addBottom(
			parent:DisplayObjectContainer,
			addee:DisplayObject
		):DisplayObject {
			return parent.addChildAt(addee, 0);
		}
		
		public static function addAbove(
			child:DisplayObject,
			addee:DisplayObject
		):DisplayObject {
			var parent:DisplayObjectContainer = child.parent;
			
			if(parent === null) {
				throw new ArgumentError("no parent");
			} else {
				if(DOC.child(parent, addee)) {
					if(parent.getChildIndex(child) + 1 === parent.getChildIndex(addee)) {
						return addee;
					} else if(parent.getChildIndex(child) > parent.getChildIndex(addee)) {
						return parent.addChildAt(addee, parent.getChildIndex(child));
					} else {
						return parent.addChildAt(addee, parent.getChildIndex(child) + 1);
					}
				} else {
					return parent.addChildAt(addee, parent.getChildIndex(child) + 1);
				}
			}
		}
		
		public static function addBelow(
			child:DisplayObject,
			addee:DisplayObject
		):DisplayObject {
			var parent:DisplayObjectContainer = child.parent;
			
			if(parent === null) {
				throw new ArgumentError("no parent");
			} else {
				if(DOC.child(parent, addee)) {
					if(parent.getChildIndex(child) - 1 === parent.getChildIndex(addee)) {
						return addee;
					} else if(parent.getChildIndex(child) > parent.getChildIndex(addee)) {
						return parent.addChildAt(addee, parent.getChildIndex(child) - 1);
					} else {
						return parent.addChildAt(addee, parent.getChildIndex(child));
					}
				} else {
					return parent.addChildAt(addee, parent.getChildIndex(child));
				}
			}
		}
		
		public static function child(
			parent:DisplayObjectContainer,
			dobj:DisplayObject
		):Boolean {
			var len:int = parent.numChildren;
			
			for(var i:int = 0; i < len; i++) {
				if(parent.getChildAt(i) === dobj) {
					return true;
				}
			}
			return false;
		}
		
		public static function children(
			parent:DisplayObjectContainer
		):Array {
			var r:Array = [];
			var len:int = parent.numChildren;
			
			for(var i:int = 0; i < len; i++) {
				r.push(parent.getChildAt(i));
			}
			
			return r;
		}
		
		public static function descendants(
			ancestor:DisplayObjectContainer
		):Array {
			var r:Array = [];
			var len:int = ancestor.numChildren;
			var dobj:DisplayObject;
			
			for(var i:int = 0; i < len; i++) {
				dobj = ancestor.getChildAt(i);
				r.push(dobj);
				if(dobj is DisplayObjectContainer) {
					r.push.apply(null, arguments.callee(dobj));
				}
			}
			
			return r;
		}
		
		public static function filterChildren(
			fn:Function,
			parent:DisplayObjectContainer
		):Array {
			var r:Array = [];
			var len:int = parent.numChildren;
			var child:DisplayObject;
			
			for(var i:int = 0; i < len; i++) {
				fn(child = parent.getChildAt(i)) && r.push(child);
			}
			
			return r;
		}
		
		static public function translate(
			from:DisplayObject,
			to:DisplayObject,
			point:Point = null
		):Point {
			///// rotation is not supported yet
			
			var c:DisplayObject = common(from, to);
			
			if (c) {
				var pf:Point = point ? point.clone() : new Point();
				
				var f:DisplayObject = from;
				
				while (f !== c) {
					pf.x *= f.scaleX;
					pf.y *= f.scaleY;
					pf.offset(f.x, f.y);
					f = f.parent;
				}
				
				var t:DisplayObject = to;
				var paths:Array     = [];
				
				while (t !== c) {
					paths.push(t);
					t = t.parent;
				}
				
				while (t = paths.pop()) {
					pf.offset(-t.x, -t.y);
					pf.x /= t.scaleX;
					pf.y /= t.scaleY;
				}
				
				return pf;
			} else {
				return null;
			}
		}
		
		static public function root(d:DisplayObject):DisplayObject {
			while (d.parent) {
				d = d.parent;
			}
			return d;
		}
		static public function common( ///// find common parent
			a:DisplayObject,
			b:DisplayObject
		):DisplayObject {
			var target:DisplayObject = a;
			var parents:Array        = [];
			
			while (target) {
				parents.push(target);
				target = target.parent;
			}
			
			target = b;
			
			while (target) {
				if (parents.indexOf(target) >= 0) {
					return target;
				} else {
					target = target.parent;
				}
			}
			return null;
		}
	}
}