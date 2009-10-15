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
	
	public class Tunnel extends Area {
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
				_updateArea();
			}
		}
		
		//---------------------------------------
		// from
		//---------------------------------------
		protected var _from:Area = null;
		
		public function get from():Area {
			return _from;
		}
		public function set from(x:Area):void {
			if (!x) {
				throw new ArgumentError("from cannot be null.");
			}
			if (_from !== x) {
				_from.removeEventListener(Event.CHANGE, _change, false);
				_from = x;
				_from.addEventListener(Event.CHANGE, _change, false, 0, true);
				_updateArea();
			}
		}
		
		//---------------------------------------
		// to
		//---------------------------------------
		protected var _to:Area = null;
		
		public function get to():Area {
			return _to;
		}
		public function set to(x:Area):void {
			if (!x) {
				throw new ArgumentError("to cannot be null.");
			}
			if (_to !== x) {
				_to.removeEventListener(Event.CHANGE, _change, false);
				_to = x;
				_to.addEventListener(Event.CHANGE, _change, false, 0, true);
				_updateArea();
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
		override public function set(x:Number, y:Number, w:Number, h:Number):void {
			throw new IllegalOperationError("set() is not callable.");
		}
		// area
		override public function set parent(x:Area):void {
			throw new IllegalOperationError("Tunnel cannot be a child.");
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Tunnel(from:Area, to:Area) {
			super();
			
			_from = from || new Area();
			_to   = to   || new Area();
			
			_from.addEventListener(Event.CHANGE, _change, false, 0, true);
			_to.addEventListener(Event.CHANGE, _change, false, 0, true);
		}
		
		protected function _change(e:Event):void {
			_updateArea();
		}
		
		protected function _updateArea():void {
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
				_update();
			}
		}
	}
}