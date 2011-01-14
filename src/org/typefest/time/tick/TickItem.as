/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.time.tick {
	public class TickItem extends Object {
		protected var _time:Number = 0;
		protected var _data:*      = null;
		
		public function get time():Number { return _time }
		public function get data():* { return _data }
		
		public function TickItem(time:Number, data:* = null) {
			super();
			
			_time = time;
			_data = data;
		}
		
		public function clone():TickItem {
			return new TickItem(_time, _data);
		}
	}
}