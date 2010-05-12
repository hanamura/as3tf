/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.NetStream;
	
	import org.typefest.proc.Proc;
	
	public class VidDuration extends Proc {
		protected var _stream:NetStream      = null;
		protected var _disp:IEventDispatcher = null;
		
		protected var _time:Number = 0;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function VidDuration(stream:NetStream, disp:IEventDispatcher) {
			super();
			
			_stream = stream;
			_disp   = disp;
		}
		
		override protected function _defaultStopped():void {
			_end();
		}
		
		override protected function _start():void {
			_check();
		}
		
		protected function _check():void {
			if (_time !== _stream.time) {
				_time = _stream.time;
				_disp.dispatchEvent(new Event(Event.CHANGE));
			}
			sleep("1", _check);
		}
	}
}