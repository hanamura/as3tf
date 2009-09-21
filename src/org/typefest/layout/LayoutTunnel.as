/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.typefest.geom.draft.XY;
	
	public class LayoutTunnel extends LayoutArea {
		//---------------------------------------
		// ratio
		//---------------------------------------
		protected var _ratio:Number = 0;
		
		public function get ratio():Number {
			return _ratio;
		}
		public function set ratio(x:Number):void {
			if (_ratio !== x) {
				_ratio = x;
				_update();
			}
		}
		
		//---------------------------------------
		// from
		//---------------------------------------
		protected var _from:LayoutArea = null;
		
		public function get from():LayoutArea {
			return _from;
		}
		public function set from(x:LayoutArea):void {
			if (!x) {
				throw new ArgumentError("from cannot be null.");
			}
			if (_from !== x) {
				_from.removeEventListener(Event.CHANGE, _edgeChange, false);
				_from = x;
				_from.addEventListener(Event.CHANGE, _edgeChange, false, 0, true);
				_update();
			}
		}
		
		//---------------------------------------
		// to
		//---------------------------------------
		protected var _to:LayoutArea = null;
		
		public function get to():LayoutArea {
			return _to;
		}
		public function set to(x:LayoutArea):void {
			if (!x) {
				throw new ArgumentError("to cannot be null.");
			}
			if (_to !== x) {
				_to.removeEventListener(Event.CHANGE, _edgeChange, false);
				_to = x;
				_to.addEventListener(Event.CHANGE, _edgeChange, false, 0, true);
				_update();
			}
		}
		
		//---------------------------------------
		// override
		//---------------------------------------
		override public function set x(x:Number):void {
			throw new IllegalOperationError("x cannot be set.");
		}
		override public function set y(y:Number):void {
			throw new IllegalOperationError("y cannot be set.");
		}
		override public function set width(width:Number):void {
			throw new IllegalOperationError("width cannot be set.");
		}
		override public function set height(height:Number):void {
			throw new IllegalOperationError("height cannot be set.");
		}
		override public function setRect(rect:Rectangle):void {
			throw new IllegalOperationError("setRect() is not callable");
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function LayoutTunnel(
			from:LayoutArea = null,
			to:LayoutArea = null
		) {
			_from = from || new LayoutArea();
			_to   = to   || new LayoutArea();
			
			_from.addEventListener(Event.CHANGE, _edgeChange, false, 0, true);
			_to.addEventListener(Event.CHANGE, _edgeChange, false, 0, true);
			
			super();
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _edgeChange(e:Event):void {
			_update();
		}
		
		override protected function _update():void {
			var rect:Rectangle = new Rectangle();
			
			var topLeft:Point = XY.between(
				new Point(_from.x, _from.y),
				new Point(_to.x, _to.y),
				_ratio
			);
			
			var bottomRight:Point = XY.between(
				new Point(_from.x + _from.width, _from.y + _from.height),
				new Point(_to.x + _to.width, _to.y + _to.height),
				_ratio
			);
			
			rect.left   = topLeft.x;
			rect.top    = topLeft.y;
			rect.right  = bottomRight.x;
			rect.bottom = bottomRight.y;
			
			// set rectangle
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
				super._update();
			}
		}
	}
}