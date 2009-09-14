/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.image {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.typefest.adhoc.Container;
	import org.typefest.adhoc.events.SilentErrorEvent;
	import org.typefest.adhoc.shape.Rect;
	import org.typefest.layout.Layout;
	
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
		
		//---------------------------------------
		// passed to constructor
		//---------------------------------------
		protected var _sourceLoader:Loader     = null;
		protected var _base:DisplayObject      = null;
		protected var _request:URLRequest      = null;
		protected var _loader:Loader           = null;
		protected var _checkPolicyFile:Boolean = false;
		
		public function get base():DisplayObject {
			return _base;
		}
		public function get request():URLRequest {
			return _request;
		}
		public function get loader():Loader {
			return _loader;
		}
		
		//---------------------------------------
		// bitmap properties
		//---------------------------------------
		protected var _bitmap:Bitmap        = null;
		protected var _pixelSnapping:String = PixelSnapping.AUTO;
		protected var _smoothing:Boolean    = true;
		
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
		
		//---------------------------------------
		// masking
		//---------------------------------------
		protected var _loaderMask:Rect     = null;
		protected var _maskEnabled:Boolean = false;
		
		public function get maskEnabled():Boolean {
			return _maskEnabled;
		}
		public function set maskEnabled(x:Boolean):void {
			if(_maskEnabled !== x) {
				_maskEnabled = x;
				_updateMask();
			}
		}
		
		//---------------------------------------
		// scale and position
		//---------------------------------------
		protected var _layout:Function  = Layout.exactFit;
		protected var _positionX:Number = 0;
		protected var _positionY:Number = 0;
		
		public function get layout():Function {
			return _layout;
		}
		public function set layout(x:Function):void {
			if (_layout !== x) {
				_layout = x;
				_update();
			}
		}
		public function get positionX():Number {
			return _positionX;
		}
		public function set positionX(x:Number):void {
			if (_positionX !== x) {
				_positionX = x;
				_update();
			}
		}
		public function get positionY():Number {
			return _positionY;
		}
		public function set positionY(x:Number):void {
			if (_positionY !== x) {
				_positionY = x;
				_update();
			}
		}
		
		//---------------------------------------
		// raw size
		//---------------------------------------
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
		
		//---------------------------------------
		// status
		//---------------------------------------
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
				var area:Rectangle   = new Rectangle(0, 0, _width, _height);
				var target:Rectangle = new Rectangle(0, 0, rawWidth, rawHeight);
				
				var rect:Rectangle = _layout(area, target, _positionX, _positionY);
				
				if (rect.width <= 0 || rect.height <= 0) {
					_loader.visible = false;
					return;
				}
				_loader.visible = true;
				
				_loader.width  = rect.width;
				_loader.height = rect.height;
				_loader.x      = rect.x;
				_loader.y      = rect.y;
				
				_loaderMask.width  = _width;
				_loaderMask.height = _height;
				
				_bitmap.smoothing     = _smoothing;
				_bitmap.pixelSnapping = _pixelSnapping;
			}
		}
	}
}