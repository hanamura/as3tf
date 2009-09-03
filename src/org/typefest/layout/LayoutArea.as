/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class LayoutArea extends Object {
		protected var _:Dictionary = null;
		
		protected var _rect:Rectangle = null;
		
		public function get rect():Rectangle {
			return _rect.clone();
		}
		
		public function get x():Number {
			return _rect.x;
		}
		public function set x(x:Number):void {
			if (_rect.x !== x) {
				_rect.x = x;
				_update();
			}
		}
		public function get y():Number {
			return _rect.y;
		}
		public function set y(x:Number):void {
			if (_rect.y !== x) {
				_rect.y = x;
				_update();
			}
		}
		public function get width():Number {
			return _rect.width;
		}
		public function set width(x:Number):void {
			if (_rect.width !== x) {
				_rect.width = x;
				_update();
			}
		}
		public function get height():Number {
			return _rect.height;
		}
		public function set height(x:Number):void {
			if (_rect.height !== x) {
				_rect.height = x;
				_update();
			}
		}
		
		public function get targets():Array {
			var r:Array = [];
			for (var a:* in _) {
				r.push(a);
			}
			return r;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function LayoutArea(
			x:Number = 0,
			y:Number = 0,
			width:Number = 0,
			height:Number = 0
		) {
			super();
			
			_     = new Dictionary(true);
			_rect = new Rectangle(x, y, width, height);
			
			_update();
		}
		
		//---------------------------------------
		// Interfaces
		//---------------------------------------
		public function add(
			a:*,
			l:* = "noScale",
			r:* = null,
			px:* = null,
			py:* = null,
			listen:Boolean = true
		):void {
			_[a] = {};
			_[a].positionX = px !== null ? px : "positionX" in a ? a["positionX"] : null;
			_[a].positionY = py !== null ? py : "positionY" in a ? a["positionY"] : null;
			_[a].rect      = r  !== null ? r  : "rect"      in a ? a["rect"]      : null;
			_[a].layout    = l  !== null ? l  : "layout"    in a ? a["layout"]    : Layout.noScale;
			_[a].callableX = _[a].positionX is Function;
			_[a].callableY = _[a].positionY is Function;
			_[a].layout is String && (_[a].layout = Layout[_[a].layout]);
			
			var rect:Rectangle = Layout.toRectangle(a); // rectangle clone of original a
			
			if (_[a].rect === null) {
				// if null, refer original a’s rectangle
				_[a].getRect = function():Rectangle { return rect; }
			} else if (_[a].rect is Function) {
				// if function, just call it
				_[a].getRect = _[a].rect;
			} else if (_[a].rect is Rectangle) {
				// if rectangle, refer original rect
				_[a].getRect = function():Rectangle { return _[a].rect; }
			} else {
				// if unknown object (including displayobject), refer it lazily
				_[a].getRect = function():Rectangle {
					return Layout.toRectangle(_[a].rect);
				}
			}
			
			if (a is IEventDispatcher && listen) {
				a.addEventListener(Event.CHANGE, _childChange, false, 0, true);
			}
			
			_position(a);
		}
		public function has(a:*):Boolean {
			return a in _;
		}
		public function remove(a:*):void {
			if (a in _ && a is IEventDispatcher) {
				a.removeEventListener(Event.CHANGE, _childChange, false);
			}
			delete _[a];
		}
		public function clear():void {
			for (var a:* in _) {
				if (a is IEventDispatcher) {
					a.removeEventListener(Event.CHANGE, _childChange, false);
				}
			}
			_ = new Dictionary(true);
		}
		public function update(a:*):void {
			if (a in _) {
				_position(a);
			}
		}
		
		//---------------------------------------
		// Updates
		//---------------------------------------
		protected function _childChange(e:Event):void {
			_position(e.currentTarget);
		}
		
		protected function _update():void {
			for (var a:* in _) {
				_position(a);
			}
		}
		
		protected function _position(a:*):void {
			var rect:Rectangle = _[a].layout(
				_rect,
				_[a].getRect(),
				_[a].callableX ? 0 : _[a].positionX,
				_[a].callableY ? 0 : _[a].positionY
			);
			
			if (_[a].callableX) {
				rect.x = x + _[a].positionX(width, rect.width);
			}
			if (_[a].callableY) {
				rect.y = y + _[a].positionY(height, rect.height);
			}
			
			Layout.apply(rect, a);
		}
	}
}