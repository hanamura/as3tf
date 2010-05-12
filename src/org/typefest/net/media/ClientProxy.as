/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.media {
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class ClientProxy extends Proxy {
		protected var _listener:Function = null;
		
		public function ClientProxy(listener:Function) {
			super();
			
			_listener = listener;
		}
		
		override flash_proxy function getProperty(name:*):* {
			return function(...args:Array):void {
				_listener.apply(null, [String(name)].concat(args))
			}
		}
	}
}