/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.dev {
	import flash.net.LocalConnection;
	
	public class Dev {
		
		// via http://www.gskinner.com/blog/archives/2006/08/as3_resource_ma_2.html
		public static function gc():void {
			try {
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			} catch(e:Error) {}
		}
	}
}