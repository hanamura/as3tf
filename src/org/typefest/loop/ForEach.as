/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.loop {
	public class ForEach extends For {
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ForEach(
			target:*,
			body:Function,
			scope:*       = null,
			count:int     = 10,
			cont:Function = null
		) {
			super(target, body, scope, count, cont);
		}
		
		
		
		
		
		//---------------------------------------
		// on start
		//---------------------------------------
		override protected function _init():void {
			for each (var value:* in _target) {
				_values.push(value);
			}
		}
	}
}