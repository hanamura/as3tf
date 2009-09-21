/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class LayoutArea extends LayoutRect {
		protected var _:Dictionary = null;
		
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
			a:*,                    // target object
			l:* = "noScale",        // layout function
			r:* = null,             // original rectangle / function to get rectangle
			px:* = 0,               // positionX / if null, not apply x to target
			py:* = 0,               // positionY / if null, not apply y to target
			applier:Function = null // function to apply rect to target
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
			
			if (applier === null) {
				$.applier = Layout.apply;
			} else {
				$.applier = applier;
			}
			
			_[a] = $;
			
			_position(a);
		}
		public function has(a:*):Boolean {
			return a in _;
		}
		public function remove(a:*):void {
			delete _[a];
		}
		public function clear():void {
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
		override protected function _update():void {
			for (var a:* in _) {
				_position(a);
			}
			dispatchEvent(new Event(Event.CHANGE));
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
				$.applier(rect, a);
			}
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

internal class Struct extends Object {
	public var layout:Function  = null;
	
	public var rect:Rectangle   = null;
	public var getRect:Function = null;
	
	public var positionX:*           = null;
	public var getPositionX:Function = null;
	
	public var positionY:*           = null;
	public var getPositionY:Function = null;
	
	public var applier:Function = null;
	
	public function Struct() {
		super();
	}
}