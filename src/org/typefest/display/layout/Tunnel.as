/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.layout {
	import org.typefest.display.containers.IRepresent;
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class Tunnel extends LayoutSetter {
		///// sources
		protected var _a:IRepresent = null;
		protected var _b:IRepresent = null;
		
		public function get a():IRepresent { return _a }
		public function set a(_:IRepresent):void {
			if (_a !== _) {
				if (_a) {
					_a.removeEventListener(AltEvent.RESIZE, _update, false);
					_a.removeEventListener(AltEvent.REPOSITION, _update, false);
				}
				
				_a = _;
				
				if (_a) {
					_a.addEventListener(AltEvent.RESIZE, _update, false, 0, true);
					_a.addEventListener(AltEvent.REPOSITION, _update, false, 0, true);
				}
				
				_update();
			}
		}
		public function get b():IRepresent { return _b }
		public function set b(_:IRepresent):void {
			if (_b !== _) {
				if (_b) {
					_b.removeEventListener(AltEvent.RESIZE, _update, false);
					_b.removeEventListener(AltEvent.REPOSITION, _update, false);
				}
				
				_b = _;
				
				if (_b) {
					_b.addEventListener(AltEvent.RESIZE, _update, false, 0, true);
					_b.addEventListener(AltEvent.REPOSITION, _update, false, 0, true);
				}
				
				_update();
			}
		}
		
		
		
		///// ratio
		protected var _ratio:Number = 0;
		
		public function get ratio():Number { return _ratio }
		public function set ratio(_:Number):void {
			if (_ratio !== _) {
				_ratio = _;
				_update();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Tunnel(a:IRepresent = null, b:IRepresent = null) {
			_a = a;
			
			if (_a) {
				_a.addEventListener(AltEvent.RESIZE, _update, false, 0, true);
				_a.addEventListener(AltEvent.REPOSITION, _update, false, 0, true);
			}
			
			_b = b;
			
			if (_b) {
				_b.addEventListener(AltEvent.RESIZE, _update, false, 0, true);
				_b.addEventListener(AltEvent.REPOSITION, _update, false, 0, true);
			}
			
			super();
			
			_update();
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _update(e:AltEvent = null):void {
			var x:Number, y:Number, width:Number, height:Number;
			
			if (_a && _b) {
				x      = _a.x + (_b.x - _a.x) * _ratio;
				y      = _a.y + (_b.y - _a.y) * _ratio;
				width  = _a.width + (_b.width - _a.width) * _ratio;
				height = _a.height + (_b.height - _a.height) * _ratio;
			} else {
				x      = 0;
				y      = 0;
				width  = 0;
				height = 0;
			}
			
			if (_x !== x || _y !== y) {
				_x = x;
				_y = y;
				_reposition();
			}
			if (_width !== width || _height !== height) {
				_width  = width;
				_height = height;
				_resize();
			}
		}
	}
}