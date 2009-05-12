/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
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
		
		public static function root(
			dobj:DisplayObject
		):DisplayObject {
			if(dobj.parent === null) {
				return dobj;
			} else {
				return arguments.callee(dobj.parent);
			}
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
		
		// static public function translate(
		// 	point:Point,
		// 	ofObj:DisplayObject,
		// 	forObj:DisplayObject
		// ):Point {
		// 	
		// 	
		// 	
		// }
	}
}