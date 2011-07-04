/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.loader {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import org.typefest.core.Arr;
	
	
	
	
	
	public class LoadersLoader extends EventDispatcher implements ILoader {
		///// loaders
		protected var _loaders:Array = null;
		
		public function get loaders():Array { return _loaders.concat() }
		
		
		
		///// loader
		protected var _loader:ILoader = null;
		protected var _queue:Array    = null;
		
		
		
		///// loading / loaded
		public function get loading():Boolean {
			return !!_loader;
		}
		public function get loaded():Boolean {
			return !_loader && !!_queue && !_queue.length;
		}
		
		
		
		///// data
		public function get data():* {
			if (_queue) {
				var loaders:Array = _loaders.slice(
					0, (_queue.length + (_loader ? 1 : 0)) * -1
				);
				
				return Arr.select(loaders, "data");
			} else {
				return [];
			}
			
			var _:Array = [];
			
			for each (var loader:ILoader in _loaders) {
				if (loader.loaded) {
					_.push(loader.data);
				} else {
					break;
				}
			}
			return _;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function LoadersLoader(loaders:Array) {
			super();
			
			_loaders = loaders.concat();
		}
		
		
		
		
		
		//---------------------------------------
		// load / unload
		//---------------------------------------
		public function load():void {
			if (!loading && !loaded) {
				_queue = _loaders.concat();
				_load();
				
				dispatchEvent(new Event(Event.OPEN));
			}
		}
		protected function _load():void {
			if (_queue.length) {
				_loader = _queue.shift();
				_loader.load();
				_loader.addEventListener(
					Event.COMPLETE, _loaderComplete
				);
				_loader.addEventListener(
					IOErrorEvent.IO_ERROR, _loaderComplete
				);
				_loader.addEventListener(
					SecurityErrorEvent.SECURITY_ERROR, _loaderComplete
				);
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		public function unload():void {
			if (loading) {
				_drop();
				_loader.unload();
				_loader = null;
			}
			_queue = null;
			
			var some:Boolean = false;
			
			for each (var loader:ILoader in _loaders) {
				if (loader.loaded) {
					some = true;
				}
				loader.unload();
			}
			
			if (some) {
				dispatchEvent(new Event(Event.UNLOAD));
			}
		}
		
		
		
		
		
		//---------------------------------------
		// drop
		//---------------------------------------
		protected function _drop():void {
			_loader.removeEventListener(
				Event.COMPLETE, _loaderComplete
			);
			_loader.removeEventListener(
				IOErrorEvent.IO_ERROR, _loaderComplete
			);
			_loader.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, _loaderComplete
			);
		}
		
		
		
		
		
		//---------------------------------------
		// complete
		//---------------------------------------
		protected function _loaderComplete(e:Event):void {
			_drop();
			_loader = null;
			
			_load();
		}
	}
}