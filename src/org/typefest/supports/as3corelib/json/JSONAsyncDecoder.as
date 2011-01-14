/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.supports.as3corelib.json {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.adobe.serialization.json.JSONParseError;
	
	import org.typefest.errors.StopIteration;
	
	
	
	
	
	public class JSONAsyncDecoder extends EventDispatcher {
		///// data
		protected var _data:String = null;
		protected var _steps:int   = 0;
		
		public function get data():String {
			return _data;
		}
		public function get steps():int {
			return _steps;
		}
		
		
		
		///// decoder
		protected var _decoder:JSONStepDecoder = null;
		protected var _engine:IEventDispatcher = null;
		
		
		
		///// object
		public function get object():* {
			return _decoder && _decoder.object;
		}
		
		
		
		///// decoding, decoded
		public function get decoding():Boolean {
			return !!_engine;
		}
		public function get decoded():Boolean {
			return !!_decoder && !!_decoder.object;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function JSONAsyncDecoder(data:String, steps:int = 100) {
			super();
			
			if (steps <= 0) {
				throw new ArgumentError();
			}
			
			_data  = data;
			_steps = steps;
		}
		
		
		
		
		
		//---------------------------------------
		// decode & cancel
		//---------------------------------------
		public function decode():void {
			if (!decoding && !decoded) {
				_decoder = new JSONStepDecoder(_data);
				
				_engine = new Bitmap();
				_engine.addEventListener(Event.ENTER_FRAME, _step);
			}
		}
		public function cancel():void {
			if (decoding) {
				_engine.removeEventListener(Event.ENTER_FRAME, _step);
				_engine = null;
				
				_decoder = null;
			} else if (decoded) {
				_decoder = null;
			}
		}
		
		
		
		
		
		//---------------------------------------
		// step
		//---------------------------------------
		protected function _step(e:Event):void {
			try {
				var steps:int = _steps;
				while (steps--) { _decoder.step() }
			} catch (e:StopIteration) {
				_engine.removeEventListener(Event.ENTER_FRAME, _step);
				_engine = null;
				
				dispatchEvent(new Event(Event.COMPLETE));
			} catch (e:JSONParseError) {
				_engine.removeEventListener(Event.ENTER_FRAME, _step);
				_engine = null;
				
				dispatchEvent(new JSONParseErrorEvent(JSONParseErrorEvent.PARSE_ERROR));
			}
		}
	}
}