/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.image {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.typefest.adhoc.Container;
	import org.typefest.adhoc.events.SilentErrorEvent;
	import org.typefest.adhoc.shape.Rect;
	
	public class RemoteImage extends Container {
		/*
		
		// usage:
		
		var url:String = "http://farm4.static.flickr.com/3522/3745657952_7fd913c2bb.jpg";
		// Photo by ComputerHotline
		// http://www.flickr.com/photos/computerhotline/
		// http://www.flickr.com/photos/computerhotline/3745657952/
		
		var image:RemoteImage = new RemoteImage(new URLRequest(url));
		image.width       = 100;
		image.height      = 100;
		image.scaleMode   = StageScaleMode.NO_SCALE;
		image.maskEnabled = true;
		image.base.fill   = 0x0000ff;
		image.load();
		
		var listener:Function = function(e:Event):void {
			trace("image loaded");
			image.width  = image.rawWidth;
			image.height = image.rawHeight;
		}
		image.addEventListener(Event.COMPLETE, listener);
		
		anyDisplayObjectContainer.addChild(image);
		
		*/
		
		protected var _sourceLoader:Loader     = null;
		protected var _base:DisplayObject      = null;
		protected var _request:URLRequest      = null;
		protected var _loader:Loader           = null;
		protected var _checkPolicyFile:Boolean = false;
		
		protected var _bitmap:Bitmap   = null;
		protected var _loaderMask:Rect = null;
		
		protected var _pixelSnapping:String = PixelSnapping.AUTO;
		protected var _smoothing:Boolean    = true;
		protected var _maskEnabled:Boolean  = false;
		protected var _scaleMode:String     = StageScaleMode.EXACT_FIT;
		
		public function get base():DisplayObject {
			return _base;
		}
		
		public function get request():URLRequest {
			return _request;
		}
		public function get loader():Loader {
			return _loader;
		}
		
		public function get pixelSnapping():String {
			return _pixelSnapping;
		}
		public function set pixelSnapping(x:String):void {
			if(_pixelSnapping !== x) {
				_pixelSnapping = x;
				_update();
			}
		}
		
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(x:Boolean):void {
			if(_smoothing !== x) {
				_smoothing = x;
				_update();
			}
		}
		
		public function get maskEnabled():Boolean {
			return _maskEnabled;
		}
		public function set maskEnabled(x:Boolean):void {
			if(_maskEnabled !== x) {
				_maskEnabled = x;
				_updateMask();
			}
		}
		
		public function get scaleMode():String {
			return _scaleMode;
		}
		public function set scaleMode(x:String):void {
			if(_scaleMode !== x) {
				_scaleMode = x;
				_update();
			}
		}
		
		public function get rawWidth():Number {
			if (_bitmap) {
				return _bitmap.bitmapData.width;
			} else {
				return NaN;
			}
		}
		
		public function get rawHeight():Number {
			if (_bitmap) {
				return _bitmap.bitmapData.height;
			} else {
				return NaN;
			}
		}
		
		public function get loading():Boolean {
			return !!_loader && !_bitmap;
		}
		
		public function get loaded():Boolean {
			return !!_loader && !!_bitmap;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function RemoteImage(
			request:URLRequest,
			loader:Loader = null,
			base:DisplayObject = null,
			checkPolicyFile:Boolean = false
		) {
			super();
			
			_request      = request;
			_sourceLoader = loader;
			
			if (base) {
				_base = base;
			} else {
				var _:Rect = new Rect();
				_.fill      = 0x000000;
				_.fillAlpha = 1;
				_base = _;
			}
			
			_checkPolicyFile = checkPolicyFile;
			
			addChild(_base);
		}
		
		//---------------------------------------
		// Public Methods
		//---------------------------------------
		public function load():void {
			if (!_loader) {
				var context:LoaderContext = new LoaderContext(_checkPolicyFile);
				
				_loader = _sourceLoader ? _sourceLoader : new Loader();
				_loader.load(_request, context);
				_loader.contentLoaderInfo.addEventListener(
					Event.COMPLETE, _loaderComplete
				);
				_loader.contentLoaderInfo.addEventListener(
					IOErrorEvent.IO_ERROR, _loaderIOError
				);
			}
		}
		
		public function unload():void {
			if (_loader) {
				if (_bitmap) {
					_bitmap.bitmapData.dispose();
					_bitmap = null;
					removeChild(_loader);
					_loader.unload();
					_loader = null;
				} else {
					_delisten();
					_loader.close();
					_loader.unload();
					_loader = null;
				}
			}
		}
		
		//---------------------------------------
		// Utility Method
		//---------------------------------------
		protected function _delisten():void {
			_loader.contentLoaderInfo.removeEventListener(
				Event.COMPLETE, _loaderComplete
			);
			_loader.contentLoaderInfo.removeEventListener(
				IOErrorEvent.IO_ERROR, _loaderIOError
			);
		}
		
		//---------------------------------------
		// Listeners
		//---------------------------------------
		protected function _loaderIOError(e:IOErrorEvent):void {
			_delisten();
			
			_loader.unload();
			_loader = null;
			
			dispatchEvent(new SilentErrorEvent(
				SilentErrorEvent.IO_ERROR,
				false,
				false,
				e.text
			));
		}
		
		protected function _loaderComplete(e:Event):void {
			_delisten();
			
			_bitmap = _loader.content as Bitmap;
			
			if (!_bitmap) {
				_loader.unload();
				_loader = null;
				
				dispatchEvent(new SilentErrorEvent(
					SilentErrorEvent.RESOURCE_ERROR,
					false,
					false,
					"Resource is not bitmap."
				));
				
				return;
			}
			
			_loaderMask = new Rect();
			addChild(_loaderMask);
			addChild(_loader);
			
			_updateMask();
			_update();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//---------------------------------------
		// Updates
		//---------------------------------------
		protected function _updateMask():void {
			if (_loaderMask) {
				if (_maskEnabled) {
					_loaderMask.visible = true;
					_loader.mask = _loaderMask;
				} else {
					_loaderMask.visible = false;
					_loader.mask = null;
				}
			}
		}
		
		override protected function _update():void {
			if (_base) {
				_base.width  = _width;
				_base.height = _height;
			}
			
			if (_bitmap) {
				if (_width <= 0 || _height <= 0) {
					_loader.visible = false;
					return;
				}
				
				_loader.visible = true;
				
				var bdWidth:Number   = _bitmap.bitmapData.width;
				var bdHeight:Number  = _bitmap.bitmapData.height;
				var bdRatio:Number   = bdWidth / bdHeight;
				var areaRatio:Number = _width / _height;
				
				if (_scaleMode === StageScaleMode.NO_SCALE) {
					_loader.width  = bdWidth;
					_loader.height = bdHeight;
				} else if (_scaleMode === StageScaleMode.NO_BORDER) {
					if (areaRatio > bdRatio) {
						_loader.width  = _width;
						_loader.height = bdHeight * (_width / bdWidth);
					} else {
						_loader.width  = bdWidth * (_height / bdHeight);
						_loader.height = _height;
					}
				} else if (_scaleMode === StageScaleMode.SHOW_ALL) {
					if (areaRatio > bdRatio) {
						_loader.width  = bdWidth * (_height / bdHeight);
						_loader.height = _height;
					} else {
						_loader.width  = _width;
						_loader.height = bdHeight * (_width / bdWidth);
					}
				} else {
					_loader.width  = _width;
					_loader.height = _height;
				}
				
				var loaderX:Number = (_width - _loader.width) / 2;
				var loaderY:Number = (_height - _loader.height) / 2;
				_loader.x = loaderX;
				_loader.y = loaderY;
				
				_loaderMask.width  = _width;
				_loaderMask.height = _height;
				
				_bitmap.smoothing     = _smoothing;
				_bitmap.pixelSnapping = _pixelSnapping;
			}
		}
	}
}