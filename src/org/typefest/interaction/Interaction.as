/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.interaction {
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	
	
	
	
	public class Interaction extends EventDispatcher {
		static protected var _interactions:Dictionary = new Dictionary(false);
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// target & dispatcher
		protected var _target:InteractiveObject    = null;
		protected var _dispatcher:IEventDispatcher = null;
		
		public function get target():InteractiveObject { return _target }
		public function get dispatcher():IEventDispatcher { return _dispatcher }
		public function set dispatcher(dispatcher:IEventDispatcher):void {
			_dispatcher = dispatcher;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Interaction(
			target:InteractiveObject,
			dispatcher:IEventDispatcher = null
		) {
			super();
			
			_target     = target;
			_dispatcher = dispatcher;
		}
		
		
		
		
		
		//---------------------------------------
		// retain release
		//---------------------------------------
		public function retain():void {
			_interactions[this] = true;
		}
		public function release():void {
			delete _interactions[this];
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		public function dispose():void {
			release();
			_onDispose();
		}
		protected function _onDispose():void {}
	}
}