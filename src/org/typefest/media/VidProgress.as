/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.NetStream;
	
	import org.typefest.proc.Proc;
	
	public class VidProgress extends Proc {
		protected var _stream:NetStream      = null;
		protected var _disp:IEventDispatcher = null;
		
		protected var _loaded:Number = NaN;
		protected var _total:Number  = NaN;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function VidProgress(stream:NetStream, disp:IEventDispatcher) {
			super();
			
			_stream = stream;
			_disp   = disp;
		}
		
		override protected function _defaultStopped():void {
			_end();
		}
		
		override protected function _start():void {
			_checkFirst();
		}
		
		//---------------------------------------
		// check
		//---------------------------------------
		protected function _checkFirst():void {
			if (_stream.bytesTotal && _stream.bytesTotal !== uint.MAX_VALUE) {
				_loaded = _stream.bytesLoaded;
				_total  = _stream.bytesTotal;
				_dispatch();
				_check();
			} else {
				sleep("1", _checkFirst);
			}
		}
		protected function _check():void {
			if (_loaded !== _stream.bytesLoaded) {
				_loaded = _stream.bytesLoaded;
				_dispatch();
			}
			
			if (_loaded === _total) {
				// _end();
			} else {
				sleep("1", _check);
			}
		}
		
		//---------------------------------------
		// shortcut
		//---------------------------------------
		protected function _dispatch():void {
			_disp.dispatchEvent(new ProgressEvent(
				ProgressEvent.PROGRESS,
				false,
				false,
				_loaded,
				_total
			));
		}
	}
}