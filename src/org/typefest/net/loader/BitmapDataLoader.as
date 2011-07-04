/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.loader {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	
	
	
	
	public class BitmapDataLoader extends EventDispatcher implements ILoader {
		///// request
		protected var _request:URLRequest = null;
		
		public function get request():URLRequest { return _request }
		
		
		
		///// loader
		protected var _loader:Loader        = null;
		protected var _timer:Timer          = null;
		protected var _currRetryCount:int   = 0;
		protected var _retryCount:int       = 2;
		protected var _retryInterval:Number = 1000;
		
		public function get retryCount():int { return _retryCount }
		public function set retryCount(_:int):void { _retryCount = _ }
		public function get retryInterval():Number { return _retryInterval }
		public function set retryInterval(_:Number):void { _retryInterval = _ }
		
		
		
		///// loading / loaded
		public function get loading():Boolean { return !!_loader || !!_timer }
		public function get loaded():Boolean { return !!_bitmapData }
		
		
		
		///// data
		protected var _bitmapData:BitmapData = null;
		
		public function get data():* { return _bitmapData }
		
		
		
		///// use copypixels
		protected var _useCopyPixels:Boolean = false;
		
		public function get useCopyPixels():Boolean { return _useCopyPixels }
		public function set useCopyPixels(_:Boolean):void { _useCopyPixels = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function BitmapDataLoader(request:URLRequest) {
			super();
			
			_request = request;
		}
		
		
		
		
		
		//---------------------------------------
		// load / unload
		//---------------------------------------
		public function load():void {
			if (!loading && !loaded) {
				_currRetryCount = _retryCount;
				_load();
				
				dispatchEvent(new Event(Event.OPEN));
			}
		}
		protected function _load():void {
			_loader = new Loader();
			_loader.load(_request, new LoaderContext(true));
			_loader.contentLoaderInfo.addEventListener(
				Event.COMPLETE, _loaderComplete
			);
			_loader.contentLoaderInfo.addEventListener(
				IOErrorEvent.IO_ERROR, _loaderIOError
			);
			_loader.contentLoaderInfo.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR, _loaderSecurityError
			);
		}
		public function unload():void {
			if (loading) {
				if (_loader) {
					_drop();
					try { _loader.close() } catch (e:Error) {}
					_loader = null;
				} else if (_timer) {
					_timer.removeEventListener(TimerEvent.TIMER, _retry);
					_timer.stop();
					_timer = null;
				}
			} else if (loaded) {
				_bitmapData.dispose();
				_bitmapData = null;
				
				dispatchEvent(new Event(Event.UNLOAD));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// drop
		//---------------------------------------
		protected function _drop():void {
			_loader.contentLoaderInfo.removeEventListener(
				Event.COMPLETE, _loaderComplete
			);
			_loader.contentLoaderInfo.removeEventListener(
				IOErrorEvent.IO_ERROR, _loaderIOError
			);
			_loader.contentLoaderInfo.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, _loaderSecurityError
			);
		}
		
		
		
		
		
		//---------------------------------------
		// loader io error
		//---------------------------------------
		protected function _loaderIOError(e:IOErrorEvent):void {
			_drop();
			_loader = null;
			
			if (_currRetryCount) {
				_currRetryCount--;
				
				_timer = new Timer(_retryInterval, 1);
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, _retry);
			} else {
				dispatchEvent(e);
			}
		}
		protected function _retry(e:TimerEvent):void {
			_timer.removeEventListener(TimerEvent.TIMER, _retry);
			_timer.stop();
			_timer = null;
			
			_load();
		}
		//---------------------------------------
		// loader security error
		//---------------------------------------
		protected function _loaderSecurityError(e:SecurityErrorEvent):void {
			_drop();
			_loader = null;
			
			dispatchEvent(e);
		}
		//---------------------------------------
		// loader complete
		//---------------------------------------
		protected function _loaderComplete(e:Event):void {
			_drop();
			
			if (_useCopyPixels) {
				var source:BitmapData = (_loader.content as Bitmap).bitmapData;
				_bitmapData = new BitmapData(
					source.width, source.height, source.transparent, 0x00000000
				);
				_bitmapData.copyPixels(
					source,
					new Rectangle(0, 0, source.width, source.height),
					new Point()
				);
				source.dispose();
			} else {
				_bitmapData = (_loader.content as Bitmap).bitmapData;
			}
			
			_loader.unload();
			_loader = null;
			
			dispatchEvent(e);
		}
	}
}