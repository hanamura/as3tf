/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.loader {
	import flash.events.IEventDispatcher;
	
	public interface ILoader extends IEventDispatcher {
		function get loaded():Boolean;
		function get loading():Boolean;
		function get data():*;
		
		function load():void;
		function unload():void;
	}
}