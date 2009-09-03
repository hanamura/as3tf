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
			a:*,             // target object
			l:* = "noScale", // layout function
			r:* = null,      // original rectangle / function to get rectangle
			px:* = 0,        // positionX / if null, not apply x to target
			py:* = 0,        // positionY / if null, not apply y to target
			listen:Boolean = true
		):void {
			var $:Struct = new Struct();
			
			if (l is Function) {
				$.layout = l;
			} else if (l is String) {
				$.layout = Layout[l];
			} else {
				$.layout = Layout.noScale;
			}
			
			if (r === null) {
				// if null, refer original a’s rectangle
				$.rect    = Layout.toRectangle(a);
				$.getRect = null;
			} else if (r is Function) {
				// if function, just call it
				$.rect    = null;
				$.getRect = r;
			} else if (r is Rectangle) {
				// if rectangle, refer original rect
				$.rect    = r;
				$.getRect = null;
			} else {
				// if unknown object (including displayobject), refer it lazily
				$.rect    = null;
				$.getRect = function():Rectangle {
					return Layout.toRectangle(r);
				};
			}
			
			if (px is Function) {
				$.getPositionX = px;
				$.positionX    = null;
			} else {
				$.getPositionX = null;
				$.positionX    = px;
			}
			
			if (py is Function) {
				$.getPositionY = py;
				$.positionY    = null;
			} else {
				$.getPositionY = null;
				$.positionY    = py;
			}
			
			if (a is IEventDispatcher && listen) {
				a.addEventListener(Event.CHANGE, _childChange, false, 0, true);
			}
			
			_[a] = $;
			
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
		// Set Rect (Shortcut)
		//---------------------------------------
		public function setRect(rect:Rectangle):void {
			var some:Boolean = false;
			if (_rect.x !== rect.x) {
				_rect.x = rect.x;
				some = true;
			}
			if (_rect.y !== rect.y) {
				_rect.y = rect.y;
				some = true;
			}
			if (_rect.width !== rect.width) {
				_rect.width = rect.width;
				some = true;
			}
			if (_rect.height !== rect.height) {
				_rect.height = rect.height;
				some = true;
			}
			if (some) {
				_update();
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
			var $:Struct = _[a];
			
			var rect:Rectangle = $.layout(
				_rect,
				$.getRect !== null ? $.getRect() : $.rect,
				$.positionX === null ? 0 : $.positionX,
				$.positionY === null ? 0 : $.positionY
			);
			if ($.getPositionX !== null) {
				rect.x = x + $.getPositionX(width, rect.width);
			} else {
				if ($.positionX === null) {
					rect.x = a.x;
				}
			}
			if ($.getPositionY !== null) {
				rect.y = y + $.getPositionY(height, rect.height);
			} else {
				if ($.positionY === null) {
					rect.y = a.y;
				}
			}
			if (a is LayoutArea) {
				(a as LayoutArea).setRect(rect);
			} else {
				Layout.apply(rect, a);
			}
		}
	}
}

import flash.geom.Rectangle;

internal class Struct extends Object {
	public var layout:Function  = null;
	
	public var rect:Rectangle   = null;
	public var getRect:Function = null;
	
	public var positionX:*           = null;
	public var getPositionX:Function = null;
	
	public var positionY:*           = null;
	public var getPositionY:Function = null;
	
	public function Struct() {
		super();
	}
}