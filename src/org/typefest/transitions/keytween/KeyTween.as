/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.keytween {
	import flash.events.EventDispatcher;
	
	
	
	
	
	public class KeyTween extends EventDispatcher {
		///// target & key
		protected var _target:* = null;
		protected var _key:*    = null;
		
		public function get target():* { return _target }
		public function get key():* { return _key }
		
		///// value
		protected var _value:* = 0;
		protected var _dest:*  = 0;
		
		public function get value():* { return _value }
		public function get dest():* { return _dest }
		public function set dest(_:*):void {
			if (_dest !== _) {
				_dest = _;
				_check();
			}
		}
		
		///// filter
		protected var _filter:Function = null;
		
		public function get filter():Function { return _filter }
		public function set filter(_:Function):void { _filter = _ }
		
		///// synced
		public function get synced():Boolean { return _value === _dest }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function KeyTween(target:*, key:*, filter:Function = null) {
			super();
			
			_target = target;
			_key    = key;
			_filter = filter;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_dest = _value = _target[_key];
		}
		
		
		
		
		
		//---------------------------------------
		// sync
		//---------------------------------------
		public function sync():void {
			_value = _dest;
			_target[_key] = _filter is Function ? _filter(_value) : _value;
			_check();
		}
		
		
		
		
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _check():void {}
	}
}