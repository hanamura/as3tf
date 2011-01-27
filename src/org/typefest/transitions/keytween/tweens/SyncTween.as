/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.keytween.tweens {
	import org.typefest.transitions.keytween.KeyTween;
	import org.typefest.transitions.keytween.KeyTweenEvent;
	
	
	
	
	
	public class SyncTween extends KeyTween {
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function SyncTween(target:*, key:*, filter:Function = null) {
			super(target, key, filter);
		}
		
		
		
		
		
		//---------------------------------------
		// check
		//---------------------------------------
		override protected function _check():void {
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
			
			_value        = _dest;
			_target[_key] = _filter is Function ? _filter(_value) : _value;
			
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.UPDATE));
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
		}
	}
}