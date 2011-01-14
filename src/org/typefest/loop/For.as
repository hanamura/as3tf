/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.loop {
	public class For extends Loop {
		///// props
		protected var _target:* = null;
		
		public function get target():* { return _target }
		
		///// values
		protected var _values:Array = [];
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function For(
			target:*,
			body:Function,
			scope:*       = null,
			count:int     = 10,
			cont:Function = null
		) {
			_target = target;
			
			super(body, scope, count, cont);
		}
		
		
		
		
		
		//---------------------------------------
		// on start
		//---------------------------------------
		override protected function _init():void {
			for (var key:* in _target) {
				_values.push(key);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// next
		//---------------------------------------
		override protected function _next():Function {
			if (_tasks.length) {
				return _tasks.shift();
			} else if (_values.length) {
				return function():void { _body.call(_scope, _values.shift()) }
			} else {
				return function():void { throw new Break() }
			}
		}
	}
}