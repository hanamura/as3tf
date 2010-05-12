/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import org.typefest.net.media.ClientEvent;
	import org.typefest.net.media.CodeEvent;
	import org.typefest.net.media.EventfulNetStream;
	import org.typefest.proc.Proc;
	
	public class VidInitialize extends Proc {
		protected var _stream:EventfulNetStream = null;
		protected var _metaData:*               = null;
		
		public function get metaData():* {
			return _metaData;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function VidInitialize(stream:EventfulNetStream) {
			super();
			
			_stream = stream;
		}
		
		override protected function _defaultStopped():void {
			_end();
		}
		
		override protected function _start():void {
			listen(_stream, ClientEvent.META_DATA, _streamMetaData);
			listen(_stream, CodeEvent.NETSTREAM_PLAY_START, _streamPlayStart);
		}
		
		//---------------------------------------
		// listeners
		//---------------------------------------
		protected function _streamMetaData(e:ClientEvent):void {
			_metaData = e.info;
			listen(_stream, CodeEvent.NETSTREAM_PLAY_START, _streamPlayStart);
		}
		protected function _streamPlayStart(e:CodeEvent):void {
			if (_metaData) {
				_end();
			} else {
				listen(_stream, ClientEvent.META_DATA, _streamMetaDataGo);
			}
		}
		protected function _streamMetaDataGo(e:ClientEvent):void {
			_metaData = e.info;
			_end();
		}
	}
}