/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.follow {
	public class ExactFollow extends Follow {
		public function ExactFollow(target:* = null, init:* = null) {
			super(target, init);
		}
		
		override protected function _updateKeys(...keys:Array):void {
			for (var key:String in _dest) {
				_curr[key] = _dest[key];
			}
		}
		
		override protected function _cancelKeys(...keys:Array):void {}
	}
}