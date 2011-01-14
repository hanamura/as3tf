/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.typefest.data.ASet;
	
	
	
	
	
	public class DocumentScanner extends ASet {
		///// store
		static protected var _store:Dictionary = new Dictionary(false);
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// display object
		protected var _target:DisplayObject = null;
		
		public function get target():DisplayObject { return _target }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function DocumentScanner(target:DisplayObject) {
			super();
			
			_target = target;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// override
		//---------------------------------------
		override public function add(...values:Array):void {
			throw new IllegalOperationError();
		}
		override public function remove(...values:Array):void {
			throw new IllegalOperationError();
		}
		override public function clear():void {
			throw new IllegalOperationError();
		}
		
		
		
		
		
		//---------------------------------------
		// retain / release
		//---------------------------------------
		public function retain():void { _store[this] = true }
		public function release():void { delete _store[this] }
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_target.addEventListener(Event.ADDED, _added, false, 0, true);
			_target.addEventListener(Event.REMOVED, _removed, false, 0, true);
			
			_listen(_target);
		}
		
		
		
		
		
		//---------------------------------------
		// added
		//---------------------------------------
		protected function _added(e:Event):void {
			_listen(e.target as DisplayObject);
		}
		
		
		
		
		
		//---------------------------------------
		// removed
		//---------------------------------------
		protected function _removed(e:Event):void {
			_unlisten(e.target as DisplayObject);
		}
		
		
		
		
		
		//---------------------------------------
		// listen
		//---------------------------------------
		protected function _listen(o:DisplayObject):void {
			super.add(o);
			
			var doc:DisplayObjectContainer = o as DisplayObjectContainer;
			
			if (doc) {
				var len:int = doc.numChildren;
				
				for (var i:int = 0; i < len; i++) {
					_listen(doc.getChildAt(i));
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// unlisten
		//---------------------------------------
		protected function _unlisten(o:DisplayObject):void {
			super.remove(o);
			
			var doc:DisplayObjectContainer = o as DisplayObjectContainer;
			
			if (doc) {
				var len:int = doc.numChildren;
				
				for (var i:int = 0; i < len; i++) {
					_unlisten(doc.getChildAt(i));
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// dispose
		//---------------------------------------
		public function dispose():void {
			_target.removeEventListener(Event.ADDED, _added, false);
			_target.removeEventListener(Event.REMOVED, _removed, false);
			
			_unlisten(_target);
		}
	}
}