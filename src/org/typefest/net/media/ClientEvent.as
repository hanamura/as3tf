/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/
package org.typefest.net.media {
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ClientEvent extends Event {
		static public const META_DATA:String   = "onMetaData";
		static public const PLAY_STATUS:String = "onPlayStatus";
		static public const XMP_DATA:String    = "onXMPData";
		static public const BW_DONE:String     = "onBWDone";
		
		static private function __objectify(x:*):* {
			var _:* = {};
			for (var key:String in x) {
				_[key] = x[key];
			}
			return _;
		}
		static private function __clone(x:*):* {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(x);
			ba.position = 0;
			return ba.readObject();
		}
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _args:Array = null;
		
		public function get args():Array {
			return _args ? _args.concat() : [];
		}
		
		public function get info():Object {
			if (_args && _args.length) {
				return __clone(__objectify(_args[0]));
			} else {
				return null;
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function ClientEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			args:Array         = null
		) {
			super(type, bubbles, cancelable);
			
			_args = args;
		}
		
		override public function clone():Event {
			return new ClientEvent(type, bubbles, cancelable, _args);
		}
	}
}