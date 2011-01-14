/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.loop {
	public class While extends Loop {
		///// pred
		protected var _pred:Function = null;
		
		public function get pred():Function { return _pred }
		public function set pred(_:Function):void { _pred = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function While(
			pred:Function,
			body:Function,
			scope:*       = null,
			count:int     = 10,
			cont:Function = null
		) {
			_pred = pred;
			
			super(body, scope, count, cont);
		}
		
		
		
		
		
		//---------------------------------------
		// next
		//---------------------------------------
		override protected function _next():Function {
			if (_tasks.length) {
				return _tasks.shift();
			} else if (_pred.call(_scope)) {
				return function():void { _body.call(_scope) };
			} else {
				return function():void { throw new Break() }
			}
		}
	}
}