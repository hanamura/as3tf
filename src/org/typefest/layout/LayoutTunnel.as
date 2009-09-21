/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.errors.IllegalOperationError;
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
		// area
		//---------------------------------------
		protected var _area:LayoutArea = null;
		
		//---------------------------------------
		// from
		//---------------------------------------
		protected var _from:LayoutTunnelEdge = null;
		
		public function get from():LayoutTunnelEdge {
			return _from;
		}
		public function set from(x:LayoutTunnelEdge):void {
			if (_from !== x) {
				_from.tunnel = null;
				_from = x;
				_from.tunnel = this;
				_update();
			}
		}
		
		//---------------------------------------
		// to
		//---------------------------------------
		protected var _to:LayoutTunnelEdge = null;
		
		public function get to():LayoutTunnelEdge {
			return _to;
		}
		public function set to(x:LayoutTunnelEdge):void {
			if (_to !== x) {
				_to.tunnel = null;
				_to = x;
				_to.tunnel = this;
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
			from:LayoutTunnelEdge = null,
			to:LayoutTunnelEdge = null
		) {
			_area = new LayoutArea();
			
			_from = from || new LayoutTunnelEdge();
			_to   = to   || new LayoutTunnelEdge();
			
			_from.tunnel = this;
			_to.tunnel   = this;
			
			super();
			
			//_update();
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		internal function updateTunnel():void {
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