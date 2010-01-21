/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.media {
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	public class EventfulNetConnection extends NetConnection {
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
		public function EventfulNetConnection() {
			super();
			
			_client = this;
			
			super.client = new ClientProxy(_clientListener);
			
			addEventListener(NetStatusEvent.NET_STATUS, _netStatus);
		}
		
		protected function _clientListener(key:String, ...args:Array):void {
			dispatchEvent(new ClientEvent(key, false, false, args));
		}
		
		//---------------------------------------
		// net status
		//---------------------------------------
		protected function _netStatus(e:NetStatusEvent):void {
			dispatchEvent(new CodeEvent(e.info.code, false, false, e));
		}
	}
}