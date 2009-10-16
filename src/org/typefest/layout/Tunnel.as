/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout {
	import flash.errors.IllegalOperationError;
	
	public class Tunnel extends XYTunnel {
		//---------------------------------------
		// ratio
		//---------------------------------------
		protected var _ratio:Number = 0;
		
		public function get ratio():Number {
			return _ratio;
		}
		public function set ratio(x:Number):void {
			if (_ratio !== x) {
				_ratio = _ratioX = _ratioY = x;
				_updateArea();
			}
		}
		
		//---------------------------------------
		// forbidden
		//---------------------------------------
		override public function set ratioX(x:Number):void {
			throw new IllegalOperationError("Unable to set ratioX.");
		}
		override public function set ratioY(x:Number):void {
			throw new IllegalOperationError("Unable to set ratioY.");
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Tunnel(from:Area = null, to:Area = null) {
			super(from, to);
		}
	}
}