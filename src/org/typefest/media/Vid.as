/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.media {
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	
	import org.typefest.display.containers.Container;
	import org.typefest.events.SilentErrorEvent;
	import org.typefest.layout.Layout;
	import org.typefest.net.media.EventfulNetConnection;
	import org.typefest.net.media.EventfulNetStream;
	import org.typefest.proc.ProcEvent;
	
	[Event(name="complete", type="flash.events.Event.COMPLETE")]
	[Event(name="init", type="flash.events.Event.INIT")]
	[Event(name="progress", type="flash.events.ProgressEvent.PROGRESS")]
	[Event(name="change", type="flash.events.Event.CHANGE")]
	[Event(
		name="SilentErrorEvent.IO_ERROR",
		type="org.typefest.events.SilentErrorEvent"
	)]
	public class Vid extends Container {
		protected var _request:*               = null;
		protected var _checkPolicyFile:Boolean = false;
		
		public function get request():* {
			return _request;
		}
		public function get checkPolicyFile():Boolean {
			return _checkPolicyFile;
		}
		
		protected var _connection:NetConnection = null;
		protected var _stream:EventfulNetStream = null;
		protected var _video:Video              = null;
		
		protected var _duration:VidDuration     = null;
		protected var _initialize:VidInitialize = null;
		protected var _progress:VidProgress     = null;
		
		//---------------------------------------
		// raw width / raw height
		//---------------------------------------
		public function get rawWidth():Number {
			if (initialized && "width" in _metaData) {
				return _metaData["width"];
			} else {
				return NaN;
			}
		}
		public function get rawHeight():Number {
			if (initialized && "height" in _metaData) {
				return _metaData["height"];
			} else {
				return NaN;
			}
		}
		
		//---------------------------------------
		// current / total
		//---------------------------------------
		public function get currentSeconds():Number {
			if (initialized) {
				return _stream.time;
			} else {
				return NaN;
			}
		}
		public function get totalSeconds():Number {
			if (initialized && "duration" in _metaData) {
				return _metaData["duration"];
			} else {
				return NaN;
			}
		}
		
		//---------------------------------------
		// loaded / total
		//---------------------------------------
		public function get bytesLoaded():Number {
			if (_stream) {
				return _stream.bytesLoaded;
			} else {
				return NaN;
			}
		}
		public function get bytesTotal():Number {
			if (_stream) {
				return _stream.bytesTotal;
			} else {
				return NaN;
			}
		}
		
		//---------------------------------------
		// meta data
		//---------------------------------------
		protected var _metaData:* = null;
		
		public function get metaData():* {
			return _metaData;
		}
		
		//---------------------------------------
		// initializing / initialized
		//---------------------------------------
		public function get initializing():Boolean {
			return !!_initialize;
		}
		public function get initialized():Boolean {
			return !!_stream && !_initialize;
		}
		//---------------------------------------
		// loading / loaded / error
		//---------------------------------------
		public function get loading():Boolean {
			return !!_progress;
		}
		public function get loaded():Boolean {
			return !!_stream && !_progress;
		}
		
		protected var _error:ErrorEvent = null;
		
		public function get error():ErrorEvent {
			return _error;
		}
		
		//---------------------------------------
		// playable
		//---------------------------------------
		protected var _playable:Boolean = false;
		
		public function get playable():Boolean {
			return _playable;
		}
		
		//---------------------------------------
		// sound
		//---------------------------------------
		protected var _volume:Number = 1;
		protected var _pan:Number    = 0;
		
		public function get volume():Number {
			return _volume;
		}
		public function set volume(num:Number):void {
			num = Math.max(Math.min(num, 1), 0);
			
			if (_volume !== num) {
				_volume = num;
				_updateSound();
			}
		}
		public function get pan():Number {
			return _pan;
		}
		public function set pan(num:Number):void {
			num = Math.max(Math.min(num, 1), -1);
			
			if (_pan !== num) {
				_pan = num;
				_updateSound();
			}
		}
		
		//---------------------------------------
		// video
		//---------------------------------------
		protected var _deblocking:int    = 0;
		protected var _smoothing:Boolean = false;
		
		public function get deblocking():int {
			return _deblocking;
		}
		public function set deblocking(num:int):void {
			if (_deblocking !== num) {
				_deblocking = num;
				_updateVideo();
			}
		}
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(bool:Boolean):void {
			if (_smoothing !== bool) {
				_smoothing = bool;
				_updateVideo();
			}
		}
		
		//---------------------------------------
		// mask
		//---------------------------------------
		protected var _maskEnabled:Boolean  = false;
		protected var _masker:DisplayObject = null;
		
		public function get maskEnabled():Boolean {
			return _maskEnabled;
		}
		public function set maskEnabled(bool:Boolean):void {
			if (_maskEnabled !== bool) {
				_maskEnabled = bool;
				_updateMask();
			}
		}
		
		//---------------------------------------
		// content layout
		//---------------------------------------
		protected var _contentLayout:Function  = Layout.exactFit;
		protected var _contentPositionX:Number = 0;
		protected var _contentPositionY:Number = 0;
		protected var _contentApply:Function   = Layout.apply;

		public function get contentLayout():Function {
			return _contentLayout;
		}
		public function set contentLayout(f:Function):void {
			if (_contentLayout !== f) {
				_contentLayout = f;
				_update();
			}
		}
		public function get contentPositionX():Number {
			return _contentPositionX;
		}
		public function set contentPositionX(num:Number):void {
			if (_contentPositionX !== num) {
				_contentPositionX = num;
				_update();
			}
		}
		public function get contentPositionY():Number {
			return _contentPositionY;
		}
		public function set contentPositionY(num:Number):void {
			if (_contentPositionY !== num) {
				_contentPositionY = num;
				_update();
			}
		}
		public function get contentApply():Function {
			return _contentApply;
		}
		public function set contentApply(f:Function):void {
			if (_contentApply !== f) {
				_contentApply = f;
				_update();
			}
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function Vid(request:*, checkPolicyFile:Boolean = false) {
			super();
			
			_request         = request;
			_checkPolicyFile = checkPolicyFile;
		}
		
		//---------------------------------------
		// load / unload
		//---------------------------------------
		public function load():void {
			if (!_stream) {
				if (_error) {
					_error = null;
				}
				
				_connection = new EventfulNetConnection();
				_connection.connect(null);
				
				_stream = new VidNetStream(_connection, this);
				_stream.checkPolicyFile = _checkPolicyFile;
				_stream.play(_request);
				_stream.pause();
				
				_initialize = new VidInitialize(_stream);
				_initialize.fire();
				
				_progress = new VidProgress(_stream, this);
				_progress.fire();
				
				_duration = new VidDuration(_stream, this);
				_duration.fire();
				
				_stream.addEventListener(IOErrorEvent.IO_ERROR, _streamError);
				_initialize.addEventListener(ProcEvent.END, _initializeEnd);
				_progress.addEventListener(ProcEvent.END, _progressEnd);
			}
		}
		public function unload():void {
			if (_initialize) {
				_initialize.removeEventListener(ProcEvent.END, _initializeEnd);
				_initialize.stop();
				_initialize = null;
			}
			
			if (_progress) {
				_progress.removeEventListener(ProcEvent.END, _progressEnd);
				_progress.stop();
				_progress = null;
			}
			
			if (_duration) {
				_duration.stop();
				_duration = null;
			}
			
			if (_stream) {
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, _streamError);

				try { _connection.close(); } catch (e:Error) {}
				try { _stream.close();     } catch (e:Error) {}

				_connection = null;
				_stream     = null;
			}
			
			if (_video) {
				removeChild(_video);
				_video = null;
			}
			
			_error    = null;
			_metaData = null;
			
			_updateMask();
		}
		
		//---------------------------------------
		// error
		//---------------------------------------
		protected function _streamError(e:IOErrorEvent):void {
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, _streamError);
			
			_error = e;
			
			_initialize.removeEventListener(ProcEvent.END, _initializeEnd);
			_initialize.stop();
			_initialize = null;
			
			_progress.removeEventListener(ProcEvent.END, _progressEnd);
			_progress.stop();
			_progress = null;
			
			_duration.stop();
			_duration = null;
			
			try { _connection.close(); } catch (e:Error) {}
			try { _stream.close();     } catch (e:Error) {}
			
			_connection = null;
			_stream     = null;
			
			dispatchEvent(new SilentErrorEvent(
				SilentErrorEvent.IO_ERROR,
				false,
				false,
				e.text
			));
		}
		
		//---------------------------------------
		// initialize end
		//---------------------------------------
		protected function _initializeEnd(e:ProcEvent):void {
			_initialize.removeEventListener(ProcEvent.END, _initializeEnd);
			
			_metaData   = _initialize.metaData;
			_initialize = null;
			
			_video = new Video();
			_video.attachNetStream(_stream);
			addChild(_video);
			
			_updateSound();
			_updateVideo();
			_update();
			_updateMask();
			
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, _streamError);
			_stream.seek(0);
			if (_playable) {
				_stream.resume();
			} else {
				_stream.pause();
			}
			
			dispatchEvent(new Event(Event.INIT));
			
			if (!_progress) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//---------------------------------------
		// progress end
		//---------------------------------------
		protected function _progressEnd(e:ProcEvent):void {
			_progress.removeEventListener(ProcEvent.END, _progressEnd);
			_progress = null;
			
			if (!_initialize) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//---------------------------------------
		// update
		//---------------------------------------
		protected function _updateMask():void {
			if (initialized && maskEnabled) {
				if (!_masker) {
					_masker = new Mask();
					addChild(_masker);
					
					_video.mask = _masker;
					
					_masker.width  = _width;
					_masker.height = _height;
				}
			} else {
				if (_masker) {
					removeChild(_masker);
					_masker = null;
				}
			}
		}
		protected function _updateSound():void {
			if (_stream) {
				_stream.soundTransform = new SoundTransform(_volume, _pan);
			}
		}
		protected function _updateVideo():void {
			if (_video) {
				_video.deblocking = _deblocking;
				_video.smoothing  = _smoothing;
			}
		}
		override protected function _onResize():void {
			_update();
		}
		protected function _update():void {
			if (_video) {
				var rect:Rectangle = _contentLayout(
					new Rectangle(0, 0, _width, _height),
					new Rectangle(0, 0, rawWidth, rawHeight),
					_contentPositionX,
					_contentPositionY
				);
				
				if (rect.width <= 0 || rect.height <= 0) {
					_video.visible = false;
				} else {
					_video.visible = true;
					_contentApply(rect, _video);
				}
			}
			if (_masker) {
				_masker.width  = _width;
				_masker.height = _height;
			}
		}
		
		//---------------------------------------
		// operations
		//---------------------------------------
		public function play():void {
			_playable = true;
			
			if (initialized) {
				_stream.resume();
			}
		}
		public function pause():void {
			_playable = false;
			
			if (initialized) {
				_stream.pause();
			}
		}
		public function toggle():void {
			_playable = !_playable;
			
			if (initialized) {
				if (_playable) {
					_stream.resume();
				} else {
					_stream.pause();
				}
			}
		}
		public function seek(offset:Number):void {
			if (initialized) {
				_stream.seek(offset);
			}
		}
	}
}