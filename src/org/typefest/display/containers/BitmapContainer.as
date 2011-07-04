/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.containers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class BitmapContainer extends Container {
		///// params
		protected var _bitmapData:BitmapData = null;
		protected var _pixelSnapping:String  = "auto";
		protected var _smoothing:Boolean     = false;
		
		public function get bitmapData():BitmapData { return _bitmapData }
		public function set bitmapData(_:BitmapData):void {
			if (_bitmapData !== _) {
				_bitmapData = _;
				_updateBitmapParams();
			}
		}
		public function get pixelSnapping():String { return _pixelSnapping }
		public function set pixelSnapping(_:String):void {
			if (_pixelSnapping !== _) {
				_pixelSnapping = _;
				_updateBitmapParams();
			}
		}
		public function get smoothing():Boolean { return _smoothing }
		public function set smoothing(_:Boolean):void {
			if (_smoothing !== _) {
				_smoothing = _;
				_updateBitmapParams();
			}
		}
		
		///// bitmap
		protected var _bitmap:Bitmap = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function BitmapContainer(
			bitmapData:BitmapData = null,
			pixelSnapping:String  = "auto",
			smoothing:Boolean     = false
		) {
			super();
			
			_bitmapData    = bitmapData;
			_pixelSnapping = pixelSnapping;
			_smoothing     = smoothing;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_bitmap = new Bitmap();
			addChild(_bitmap);
			
			_onInit();
			_updateBitmap();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// update bitmap params
		//---------------------------------------
		protected function _updateBitmapParams():void {
			_updateBitmap();
			_onBitmapParams();
			dispatchEvent(new AltEvent(AltEvent.BITMAP));
		}
		protected function _onBitmapParams():void {}
		
		
		
		
		
		//---------------------------------------
		// resize
		//---------------------------------------
		override protected function _resize():void {
			_updateBitmap();
			super._resize();
		}
		
		
		
		
		
		//---------------------------------------
		// update bitmap
		//---------------------------------------
		protected function _updateBitmap():void {
			_bitmap.bitmapData    = _bitmapData;
			_bitmap.pixelSnapping = _pixelSnapping;
			_bitmap.smoothing     = _smoothing;
			
			if (width > 0 && height > 0 && _bitmapData) {
				_bitmap.visible = true;
				_bitmap.width   = width;
				_bitmap.height  = height;
			} else {
				_bitmap.visible = false;
			}
		}
	}
}