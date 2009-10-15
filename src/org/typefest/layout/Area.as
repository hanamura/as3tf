/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class Area extends BaseRect implements IPositionable {
		//---------------------------------------
		// static methods suitable for area object
		//---------------------------------------
		// Layout.apply* functions are also OK
		// but these are better at performance
		static public function APPLY(rect:Rectangle, area:Area):void {
			area.set(rect.x, rect.y, rect.width, rect.height);
		}
		static public function APPLY_FLOORED(rect:Rectangle, area:Area):void {
			area.set(
				Math.floor(rect.x),
				Math.floor(rect.y),
				Math.floor(rect.width),
				Math.floor(rect.height)
			);
		}
		static public function APPLY_POSITION(rect:Rectangle, area:Area):void {
			area.set(rect.x, rect.y, area.width, area.height);
		}
		static public function APPLY_POSITION_FLOORED(
			rect:Rectangle,
			area:Area
		):void {
			area.set(
				Math.floor(rect.x),
				Math.floor(rect.y),
				area.width,
				area.height
			);
		}
		
		//=======================================
		// 
		// instance
		// 
		//=======================================
		// 
		//---------------------------------------
		// layout function
		//---------------------------------------
		// usually use Layout class’s static methods
		// (required)
		protected var _layout:Function = Layout.exactFit;
		
		public function get layout():Function {
			return _layout;
		}
		public function set layout(x:Function):void {
			if (_layout !== x) {
				_layout = x;
				_updateByParent();
			}
		}
		
		//---------------------------------------
		// target rectangle
		//---------------------------------------
		// target rectangle is passed to
		// layout function as a second argument
		protected var _original:Rectangle = null;
		
		public function get original():Rectangle {
			return _original && _original.clone();
		}
		public function set original(rect:Rectangle):void {
			if (_original && rect) {
				if (!_original.equals(rect)) {
					_original = rect.clone();
					_updateByParent();
				}
			} else if (_original || rect) {
				_original = _original ? rect : rect.clone();
				_updateByParent();
			}
		}
		
		//---------------------------------------
		// position x / y
		//---------------------------------------
		// NaN or number
		// if number, these values are passed directly to layout function
		// if NaN, x or y won’t be modefied
		// (recommended)
		protected var _positionX:Number = 0;
		protected var _positionY:Number = 0;
		// custom function for an alternative positioning
		// if null, position* (values above) are used
		protected var _getPositionX:Function = null;
		protected var _getPositionY:Function = null;
		
		public function get positionX():Number {
			return _positionX;
		}
		public function set positionX(x:Number):void {
			if (_positionX !== x) {
				_positionX = x;
				_updateByParent();
			}
		}
		public function get positionY():Number {
			return _positionY;
		}
		public function set positionY(y:Number):void {
			if (_positionY !== y) {
				_positionY = y;
				_updateByParent();
			}
		}
		public function get getPositionX():Function {
			return _getPositionX;
		}
		public function set getPositionX(x:Function):void {
			if (_getPositionX !== x) {
				_getPositionX = x;
				_updateByParent();
			}
		}
		public function get getPositionY():Function {
			return _getPositionY;
		}
		public function set getPositionY(y:Function):void {
			if (_getPositionY !== y) {
				_getPositionY = y;
				_updateByParent();
			}
		}
		
		//---------------------------------------
		// apply function
		//---------------------------------------
		// apply rectangle to this area object
		// (required)
		protected var _apply:Function = APPLY;
		
		public function get apply():Function {
			return _apply;
		}
		public function set apply(x:Function):void {
			if (_apply !== x) {
				_apply = x;
				_updateByParent();
			}
		}
		
		//---------------------------------------
		// parent / root
		//---------------------------------------
		protected var _parent:Area = null;

		public function get parent():Area {
			return _parent;
		}
		public function set parent(area:Area):void {
			_parent = area;
		}
		public function get root():Area {
			return _parent ? _parent.root : this;
		}
		
		//---------------------------------------
		// children
		//---------------------------------------
		private var __positionables:Dictionary = new Dictionary(true);
		private var __targets:Dictionary       = new Dictionary(true);
		
		public function get children():Array {
			var _:Array = [];
			var t:*;
			for (t in __positionables) {
				_.push(t);
			}
			for (t in __targets) {
				_.push(t);
			}
			return _;
		}
		
		//=======================================
		// 
		// Constructor
		// 
		//=======================================
		public function Area(
			x:Number      = 0,
			y:Number      = 0,
			width:Number  = 0,
			height:Number = 0
		) {
			super(x, y, width, height);
		}
		
		//---------------------------------------
		// add
		//---------------------------------------
		public function add(
			t:*,
			l:*            = "exactFit", // Function or String
			r:Rectangle    = null,
			px:*           = 0, // Number or Function
			py:*           = 0, // Number or Function
			apply:Function = null
		):void {
			if (t === this) {
				throw ArgumentError("Unable to add to itself.");
			}
			if (t is IPositionable) {
				var p:IPositionable = t as IPositionable;
				
				if (p.parent) {
					p.parent.remove(p);
				}
				p.parent = this;
				
				__positionables[p] = true;
				
				_position(p, p);
			} else {
				var $:Struct = new Struct();
				
				if (l is Function) {
					$.layout = l;
				} else if (l is String) {
					$.layout = Layout[l];
				} else {
					$.layout = Layout.exactFit;
				}
				
				if (r) {
					$.original = r.clone();
				} else {
					$.original = Layout.toRectangle(t);
				}
				
				if (px is Number) {
					$.positionX    = px;
					$.getPositionX = null;
				} else if (px is Function) {
					$.positionX    = NaN;
					$.getPositionX = px;
				} else {
					$.positionX    = Number(px);
					$.getPositionX = null;
				}
				
				if (py is Number) {
					$.positionY    = py;
					$.getPositionY = null;
				} else if (py is Function) {
					$.positionY    = NaN;
					$.getPositionY = py;
				} else {
					$.positionY    = Number(py);
					$.getPositionY = null;
				}
				
				if (apply === null) {
					$.apply = Layout.apply;
				} else {
					$.apply = apply;
				}
				
				__targets[t] = $;
				
				_position($, t);
			}
		}
		
		//---------------------------------------
		// remove
		//---------------------------------------
		public function remove(t:*):void {
			if (t in __positionables) {
				t.parent = null;
				delete __positionables[t];
			} else if (t in __targets) {
				delete __targets[t];
			}
		}
		
		//---------------------------------------
		// clear
		//---------------------------------------
		public function clear():void {
			__positionables = new Dictionary(true);
			__targets       = new Dictionary(true);
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		public function update(t:*):void {
			if (t in __positionables) {
				_position(t, t);
			} else if (t in __targets) {
				_position(__targets[t], t);
			}
		}
		
		//---------------------------------------
		// update by parent
		//---------------------------------------
		protected function _updateByParent():void {
			if (_parent) {
				_parent.update(this);
			}
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		override protected function _update():void {
			for (var p:* in __positionables) {
				_position(p, p);
			}
			for (var t:* in __targets) {
				_position(__targets[t], t);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		//---------------------------------------
		// position
		//---------------------------------------
		protected function _position(p:IPositionable, t:*):void {
			var xnan:Boolean = isNaN(p.positionX);
			var ynan:Boolean = isNaN(p.positionY);
			
			var rect:Rectangle = p.layout(
				_rect,
				p.original || Layout.toRectangle(t),
				xnan ? 0 : p.positionX,
				ynan ? 0 : p.positionY
			);
			
			if (p.getPositionX !== null) {
				rect.x = x + p.getPositionX(width, rect.width);
			} else if (xnan) {
				rect.x = t.x; // no changes
			}
			
			if (p.getPositionY !== null) {
				rect.y = y + p.getPositionY(height, rect.height);
			} else if (ynan) {
				rect.y = t.y; // no changes
			}
			
			p.apply(rect, t);
		}
		
		//---------------------------------------
		// to string
		//---------------------------------------
		override public function toString():String {
			return _rect.toString();
		}
	}
}

import flash.geom.Rectangle;

import org.typefest.layout.Area;
import org.typefest.layout.IPositionable;
import org.typefest.layout.BaseRect;

internal class Struct extends BaseRect implements IPositionable {
	protected var _layout:Function = null;
	public function get layout():Function { return _layout; }
	public function set layout(x:Function):void { _layout = x; }
	
	protected var _original:Rectangle = null;
	public function get original():Rectangle { return _original; }
	public function set original(x:Rectangle):void { _original = x; }
	
	protected var _positionX:Number = 0;
	public function get positionX():Number { return _positionX; }
	public function set positionX(x:Number):void { _positionX = x; }
	
	protected var _positionY:Number = 0;
	public function get positionY():Number { return _positionY; }
	public function set positionY(x:Number):void { _positionY = x; }
	
	protected var _getPositionX:Function = null;
	public function get getPositionX():Function { return _getPositionX; }
	public function set getPositionX(x:Function):void { _getPositionX = x; }
	
	protected var _getPositionY:Function = null;
	public function get getPositionY():Function { return _getPositionY; }
	public function set getPositionY(x:Function):void { _getPositionY = x; }
	
	protected var _apply:Function = null;
	public function get apply():Function { return _apply; }
	public function set apply(x:Function):void { _apply = x; }
	
	public function get parent():Area { return null; }
	public function set parent(x:Area):void {}
	
	public function Struct() {
		super();
	}
}