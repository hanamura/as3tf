/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.typefest.display.Container;
	import org.typefest.events.SilentErrorEvent;
	import org.typefest.layout.Layout;
	
	[Event(name="complete", type="flash.events.Event.COMPLETE")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(
		name="SilentErrorEvent.IO_ERROR",
		type="org.typefest.events.SilentErrorEvent"
	)]
	public class Img extends Container {
		protected var _request:URLRequest    = null;
		protected var _context:LoaderContext = null;
		
		public function get request():URLRequest {
			return _request;
		}
		public function get context():LoaderContext {
			return _context;
		}
		
		protected var _loader:Loader = null;
		
		//---------------------------------------
		// mask
		//---------------------------------------
		protected var _maskEnabled:Boolean  = false;
		protected var _masker:DisplayObject = null;
		
		public function get maskEnabled():Boolean {
			return _maskEnabled;
		}
		public function set maskEnabled(bool:Boolean):void {
			if (_maskEnabled !== bool) {
				_maskEnabled = bool;
				_updateMask();
			}
		}
		
		//---------------------------------------
		// raw size
		//---------------------------------------
		public function get rawWidth():Number {
			if (loaded) {
				return _loader.contentLoaderInfo.width;
			} else {
				return NaN;
			}
		}
		public function get rawHeight():Number {
			if (loaded) {
				return _loader.contentLoaderInfo.height;
			} else {
				return NaN;
			}
		}
		
		//---------------------------------------
		// bytes
		//---------------------------------------
		public function get bytesLoaded():Number {
			if (loading || loaded) {
				return _loader.contentLoaderInfo.bytesLoaded;
			} else {
				return NaN;
			}
		}
		public function get bytesTotal():Number {
			if (loading || loaded) {
				return _loader.contentLoaderInfo.bytesTotal;
			} else {
				return NaN;
			}
		}
		
		//---------------------------------------
		// loading / loaded
		//---------------------------------------
		public function get loading():Boolean {
			return !!_loader && !_loader.parent;
		}
		public function get loaded():Boolean {
			return !!_loader && !!_loader.parent;
		}
		
		//---------------------------------------
		// error
		//---------------------------------------
		protected var _error:ErrorEvent = null;
		
		public function get error():ErrorEvent {
			return _error;
		}
		
		//---------------------------------------
		// layout
		//---------------------------------------
		protected var _contentLayout:Function  = Layout.exactFit;
		protected var _contentPositionX:Number = 0;
		protected var _contentPositionY:Number = 0;
		protected var _contentApply:Function   = Layout.apply;
		
		public function get contentLayout():Function {
			return _contentLayout;
		}
		public function set contentLayout(f:Function):void {
			if (_contentLayout !== f) {
				_contentLayout = f;
				_update();
			}
		}
		public function get contentPositionX():Number {
			return _contentPositionX;
		}
		public function set contentPositionX(num:Number):void {
			if (_contentPositionX !== num) {
				_contentPositionX = num;
				_update();
			}
		}
		public function get contentPositionY():Number {
			return _contentPositionY;
		}
		public function set contentPositionY(num:Number):void {
			if (_contentPositionY !== num) {
				_contentPositionY = num;
				_update();
			}
		}
		public function get contentApply():Function {
			return _contentApply;
		}
		public function set contentApply(f:Function):void {
			if (_contentApply !== f) {
				_contentApply = f;
				_update();
			}
		}
		
		//---------------------------------------
		// bitmap
		//---------------------------------------
		protected var _pixelSnapping:String = "auto";
		protected var _smoothing:Boolean    = false;
		
		public function get pixelSnapping():String {
			return _pixelSnapping;
		}
		public function set pixelSnapping(str:String):void {
			if (_pixelSnapping !== str) {
				_pixelSnapping = str;
				_updateBitmap();
			}
		}
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(bool:Boolean):void {
			if (_smoothing !== bool) {
				_smoothing = bool;
				_updateBitmap();
			}
		}
		public function get bitmapData():BitmapData {
			if (loaded) {
				try {
					return (_loader.content as Bitmap).bitmapData;
				} catch (e:Error) {}
				return null;
			} else {
				return null;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Img(request:URLRequest, context:LoaderContext = null) {
			super();
			
			_request = request;
			_context = context || new LoaderContext();
		}
		
		//---------------------------------------
		// load / unload
		//---------------------------------------
		public function load():void {
			if (!loading && !loaded) {
				if (error) {
					_error = null;
				}
				_loader = new Loader();
				_loader.load(_request, _context);

				_loader.contentLoaderInfo.addEventListener(
					Event.COMPLETE, _complete
				);
				_loader.contentLoaderInfo.addEventListener(
					IOErrorEvent.IO_ERROR, _ioError
				);
				_loader.contentLoaderInfo.addEventListener(
					ProgressEvent.PROGRESS, dispatchEvent
				);
			}
		}
		public function unload():void {
			if (loaded) {
				removeChild(_loader);
				_loader.unload();
				_loader = null;
			} else if (loading) {
				_unlisten();
				try { _loader.close(); } catch (e:Error) {}
				_loader = null;
			} else if (error) {
				_error = null;
			}
			
			_updateMask();
		}
		
		//---------------------------------------
		// listeners
		//---------------------------------------
		protected function _ioError(e:IOErrorEvent):void {
			_unlisten();
			
			_loader = null;
			_error  = e;
			
			dispatchEvent(new SilentErrorEvent(
				SilentErrorEvent.IO_ERROR,
				false,
				false,
				e.text
			));
		}
		protected function _complete(e:Event):void {
			_unlisten();
			
			addChild(_loader);
			
			_updateBitmap();
			_update();
			_updateMask();
			
			dispatchEvent(e);
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _unlisten():void {
			_loader.contentLoaderInfo.removeEventListener(
				Event.COMPLETE, _complete
			);
			_loader.contentLoaderInfo.removeEventListener(
				IOErrorEvent.IO_ERROR, _ioError
			);
			_loader.contentLoaderInfo.removeEventListener(
				ProgressEvent.PROGRESS, dispatchEvent
			);
		}
		
		//---------------------------------------
		// updates
		//---------------------------------------
		protected function _updateMask():void {
			if (loaded && maskEnabled) {
				if (!_masker) {
					_masker = new Mask();
					addChild(_masker);
					
					_loader.mask = _masker;
					
					_masker.width  = _width;
					_masker.height = _height;
				}
			} else {
				if (_masker) {
					removeChild(_masker);
					_masker = null;
				}
			}
		}
		protected function _updateBitmap():void {
			if (loaded) {
				try {
					var bitmap:Bitmap = _loader.content as Bitmap;
					
					if (bitmap) {
						bitmap.pixelSnapping = _pixelSnapping;
						bitmap.smoothing     = _smoothing;
					}
				} catch (e:Error) {}
			}
		}
		override protected function _update():void {
			if (loaded) {
				var rect:Rectangle = _contentLayout(
					new Rectangle(0, 0, _width, _height),
					new Rectangle(0, 0, rawWidth, rawHeight),
					_contentPositionX,
					_contentPositionY
				);
				
				if (rect.width <= 0 || rect.height <= 0) {
					_loader.visible = false;
				} else {
					_loader.visible = true;
					
					_contentApply(rect, _loader);
				}
			}
			
			if (_masker) {
				_masker.width  = _width;
				_masker.height = _height;
			}
		}
	}
}