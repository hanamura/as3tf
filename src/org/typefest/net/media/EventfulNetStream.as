/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.media {
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class EventfulNetStream extends NetStream {
		static protected function _objectify(x:*):* {
			var _:* = {};
			for (var key:String in x) {
				_[key] = x[key];
			}
			return _;
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _client:Object = null;
		
		override public function get client():Object {
			return _client;
		}
		override public function set client(x:Object):void {
			if (!x) {
				throw new TypeError();
			}
			_client = x;
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function EventfulNetStream(connection:NetConnection) {
			super(connection);
			
			_client = this;
			
			super.client = new ClientProxy(_clientListener);
			
			addEventListener(NetStatusEvent.NET_STATUS, _netStatus);
		}
		
		protected function _clientListener(key:String, ...args:Array):void {
			dispatchEvent(new ClientEvent(key, false, false, args));
		}
		
		protected function _netStatus(e:NetStatusEvent):void {
			dispatchEvent(new CodeEvent(e.info.code, false, false, e));
		}
	}
}