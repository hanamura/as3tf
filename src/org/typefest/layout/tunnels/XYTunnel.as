/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout.tunnels {
	import flash.events.Event;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	
	import org.typefest.core.Num;
	import org.typefest.layout.Area;
	
	public class XYTunnel extends Area {
		//---------------------------------------
		// ratio x / y
		//---------------------------------------
		protected var _ratioX:Number = 0;
		protected var _ratioY:Number = 0;
		
		public function get ratioX():Number {
			return _ratioX;
		}
		public function set ratioX(x:Number):void {
			if (_ratioX !== x) {
				_ratioX = x;
				_updateArea();
			}
		}
		public function get ratioY():Number {
			return _ratioY;
		}
		public function set ratioY(y:Number):void {
			if (_ratioY !== y) {
				_ratioY = y;
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
		override public function set parentArea(x:Area):void {
			throw new IllegalOperationError("Tunnel cannot be a child.");
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function XYTunnel(from:Area = null, to:Area = null) {
			super();
			
			_from = from || new Area();
			_to   = to   || new Area();
			
			_from.addEventListener(Event.CHANGE, _change, false, 0, true);
			_to.addEventListener(Event.CHANGE, _change, false, 0, true);
			
			_updateArea();
		}
		
		protected function _change(e:Event):void {
			_updateArea();
		}
		
		protected function _updateArea():void {
			var rect:Rectangle = new Rectangle();
			
			rect.x      = Num.between(_from.x,      _to.x,      _ratioX);
			rect.width  = Num.between(_from.width,  _to.width,  _ratioX);
			rect.y      = Num.between(_from.y,      _to.y,      _ratioY);
			rect.height = Num.between(_from.height, _to.height, _ratioY);
			
			_applyToUpdate(rect);
		}
		
		protected function _applyToUpdate(rect:Rectangle):void {
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