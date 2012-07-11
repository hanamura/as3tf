/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.loader {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import org.typefest.events.AltEvent;
	
	
	
	
	
	public class LoadersLoader extends EventDispatcher implements ILoader {
		///// loaders
		protected var _loaders:Array = null;
		protected var _limit:uint = 0;
		
		public function get loaders():Array { return _loaders.concat() }
		public function get limit():uint { return _limit }
		
		///// loader
		protected var _loadeds:Array = [];
		protected var _loadings:Array = [];
		protected var _waitings:Array = [];
		
		///// loading/loaded
		public function get loading():Boolean {
			return !!_loadings.length;
		}
		public function get loaded():Boolean {
			return _loadeds.length === _loaders.length;
		}
		
		///// data
		public function get data():* {
			var data:Array = [];

			for each (var loader:ILoader in _loaders) {
				data.push(loader.data);
			}

			return data;
		}

		// length
		public function get length():int { return _loaders.length }
		public function get lengthLoaded():int {
			var count:int = 0;

			for each (var loader:ILoader in _loaders) {
				if (loader.loaded) {
					count++;
				}
			}
			return count;
		}
		public function get lengthLoading():int {
			var count:int = 0;

			for each (var loader:ILoader in _loaders) {
				if (loader.loading) {
					count++;
				}
			}
			return count;
		}
		public function get lengthWaiting():int {
			var count:int = 0;

			for each (var loader:ILoader in _loaders) {
				if (!loader.loaded && !loader.loading) {
					count++;
				}
			}
			return count;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LoadersLoader(loaders:Array, limit:uint = 3) {
			super();
			
			_loaders = loaders ? loaders.concat() : [];
			_limit = limit;
		}
		
		
		
		
		
		// load
		public function load():void {
			if (!loaded && !loading) {
				for each (var loader:ILoader in _loaders) {
					if (loader.loaded) {
						_loadeds.push(loader);
					} else if (loader.loading) {
						_loadings.push(loader);
					} else {
						_waitings.push(loader);
					}
				}

				if (_loaders.length && (_waitings.length || _loadings.length)) {
					_load();

					dispatchEvent(new Event(Event.OPEN));
				} else {
					dispatchEvent(new Event(Event.OPEN));
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		// load
		protected function _load():void {
			var loader:ILoader;

			while (_loadings.length < _limit && _waitings.length) {
				loader = _waitings.shift();
				loader.load();
				_loadings.push(loader);
			}

			for each (loader in _loadings) {
				loader.addEventListener(Event.COMPLETE, _loaderComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, _loaderComplete);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderComplete);
			}
		}
		// complete
		protected function _loaderComplete(e:Event):void {
			var loader:ILoader = e.currentTarget as ILoader;

			loader.removeEventListener(Event.COMPLETE, _loaderComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderComplete);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderComplete);

			_loadings.splice(_loadings.indexOf(loader), 1);
			_loadeds.push(loader);

			if (_loadings.length || _waitings.length) {
				_load();
				dispatchEvent(new AltEvent(AltEvent.STEP, false, false, loader));
			} else {
				dispatchEvent(new AltEvent(AltEvent.STEP, false, false, loader));
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		// unload
		public function unload():void {
			for each (var loader:ILoader in _loadings) {
				loader.removeEventListener(Event.COMPLETE, _loaderComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderComplete);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderComplete);
				loader.unload();
			}

			_loadeds = [];
			_loadings = [];
			_waitings = [];
		}
		// unload all
		public function unloadAll():void {
			var loader:ILoader;

			if (loading) {
				for each (loader in _loadings) {
					loader.removeEventListener(Event.COMPLETE, _loaderComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderComplete);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderComplete);
				}
			}

			var some:Boolean = false;

			for each (loader in _loaders) {
				if (loader.loaded) {
					some = true;
				}
				loader.unload();
			}

			_loadeds = [];
			_loadings = [];
			_waitings = [];

			if (some) {
				dispatchEvent(new Event(Event.UNLOAD));
			}
		}
	}
}