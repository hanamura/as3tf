/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.transitions.keytween {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	import org.typefest.data.AEvent;
	import org.typefest.data.ASet;
	import org.typefest.data.ASetChange;
	import org.typefest.data.Set;
	
	
	
	
	
	/*
	
	///// usage:
	
	///// make each tween for each key and pass to constructor
	var proxy:KeyTweenSet = new KeyTweenSet([
		new AsymptoticTween(target, "x", 0.1, 0.1),
		new AsymptoticTween(target, "y", 0.1, 0.1),
		new BetweenAS3Tween(target, "alpha", 1, Cubic.easeOut),
		new SyncTween(target, "visible")
	]);
	
	///// AsymptoticTween: approach every frame
	proxy["x"] = 100;
	proxy["y"] = 200;
	
	///// BetweenAS3Tween: using BetweenAS3
	///// (BetweenAS3 is needed: http://www.libspark.org/wiki/BetweenAS3/en)
	proxy["alpha"] = 0;
	
	///// SyncTween: immediately
	///// (non-numeral value is ok with SyncTween)
	proxy["visible"] = false;
	
	*/
	public class KeyTweenSet extends Proxy implements IEventDispatcher {
		///// get set synced
		static protected function _getSynced(set:*):Boolean {
			for each (var item:KeyTween in set) {
				if (!item.synced) { return false }
			}
			return true;
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// members
		protected var _items:ASet      = null;
		protected var _keys:Dictionary = null;
		
		public function get items():ASet { return _items }
		
		///// synced
		public function get synced():Boolean { return _getSynced(_items) }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function KeyTweenSet(init:* = null) {
			super();
			
			_init(init);
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init(init:*):void {
			_items = new ASet();
			_items.addEventListener(AEvent.CHANGE, _itemsChange);
			
			_keys = new Dictionary();
			
			for each (var item:* in init) {
				_items.add(item);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// tweens change
		//---------------------------------------
		protected function _itemsChange(e:AEvent):void {
			var change:ASetChange = e.change as ASetChange;
			var item:KeyTween;
			
			for each (item in change.removes) {
				delete _keys[item.key];
				item.removeEventListener(
					KeyTweenEvent.START, _itemStart, false
				);
				item.removeEventListener(
					KeyTweenEvent.END, _itemEnd, false
				);
				item.removeEventListener(
					KeyTweenEvent.UPDATE, dispatchEvent, false
				);
			}
			for each (item in change.adds) {
				_keys[item.key] = item;
				item.addEventListener(
					KeyTweenEvent.START, _itemStart, false, 0, true
				);
				item.addEventListener(
					KeyTweenEvent.END, _itemEnd, false, 0, true
				);
				item.addEventListener(
					KeyTweenEvent.UPDATE, dispatchEvent, false, 0, true
				);
			}
			
			///// check synced
			var prev:Set = new Set(_items);
			prev.remove.apply(null, change.adds);
			prev.add.apply(null, change.removes);
			var prevSynced:Boolean = _getSynced(prev);
			var currSynced:Boolean = synced;
			
			if (prevSynced !== currSynced) {
				if (prevSynced) {
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
				} else if (currSynced) {
					dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// item start / end
		//---------------------------------------
		protected function _itemStart(e:KeyTweenEvent):void {
			var set:Set = new Set(_items);
			set.remove(e.currentTarget);
			
			for each (var item:KeyTween in set) {
				if (!item.synced) { return }
			}
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.START));
		}
		protected function _itemEnd(e:KeyTweenEvent):void {
			var set:Set = new Set(_items);
			set.remove(e.currentTarget);
			
			for each (var item:KeyTween in set) {
				if (!item.synced) { return }
			}
			dispatchEvent(new KeyTweenEvent(KeyTweenEvent.END));
		}
		
		
		
		
		
		//---------------------------------------
		// sync
		//---------------------------------------
		public function sync():void {
			for each (var item:KeyTween in _items) {
				item.sync();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// get item
		//---------------------------------------
		public function getItem(key:*):KeyTween {
			for each (var item:KeyTween in _items) {
				if (item.key === key) {
					return item;
				}
			}
			return null;
		}
		
		
		
		
		
		//---------------------------------------
		// set / get
		//---------------------------------------
		member function set(name:*, value:*):void {
			_keys[String(name)].dest = value;
		}
		member function get(name:*):* {
			var key:String = String(name);
			
			return key in _keys ? _keys[key].dest : undefined;
		}
		member function has(name:*):* {
			return String(name) in _keys;
		}
		///// proxy
		override flash_proxy function setProperty(name:*, value:*):void {
			member::set(name, value);
		}
		override flash_proxy function getProperty(name:*):* {
			return member::get(name);
		}
		override flash_proxy function hasProperty(name:*):Boolean {
			return member::has(name);
		}
		
		
		
		
		
		//---------------------------------------
		// event dispatcher
		//---------------------------------------
		protected var __ed:EventDispatcher = null;
		protected function get _ed():EventDispatcher {
			return __ed ||= new EventDispatcher(this);
		}
		public function addEventListener(
			type:String,
			listener:Function,
			useCapture:Boolean       = false,
			priority:int             = 0,
			useWeakReference:Boolean = false
		):void {
			_ed.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeEventListener(
			type:String,
			listener:Function,
			useCapture:Boolean = false
		):void {
			_ed.removeEventListener(type, listener, useCapture);
		}
		public function dispatchEvent(e:Event):Boolean {
			return _ed.dispatchEvent(e);
		}
		public function hasEventListener(type:String):Boolean {
			return _ed.hasEventListener(type);
		}
		public function willTrigger(type:String):Boolean {
			return _ed.willTrigger(type);
		}
	}
}