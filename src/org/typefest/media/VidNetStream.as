/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	
	import org.typefest.net.media.EventfulNetStream;
	
	public class VidNetStream extends EventfulNetStream {
		protected var _disp:IEventDispatcher = null;
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function VidNetStream(
			connection:NetConnection,
			disp:IEventDispatcher
		) {
			super(connection);
			
			_disp = disp;
		}
		
		override public function dispatchEvent(e:Event):Boolean {
			var _:Boolean = super.dispatchEvent(e);
			_disp.dispatchEvent(e);
			return _;
		}
	}
}