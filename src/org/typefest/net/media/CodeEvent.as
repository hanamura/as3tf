/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.media {
	import flash.events.Event;
	
	public class CodeEvent extends Event {
		static public const NetStream_Buffer_Empty:String               = "NetStream.Buffer.Empty";
		static public const NetStream_Buffer_Full:String                = "NetStream.Buffer.Full";
		static public const NetStream_Buffer_Flush:String               = "NetStream.Buffer.Flush";
		static public const NetStream_Failed:String                     = "NetStream.Failed";
		static public const NetStream_Publish_Start:String              = "NetStream.Publish.Start";
		static public const NetStream_Publish_BadName:String            = "NetStream.Publish.BadName";
		static public const NetStream_Publish_Idle:String               = "NetStream.Publish.Idle";
		static public const NetStream_Unpublish_Success:String          = "NetStream.Unpublish.Success";
		static public const NetStream_Play_Start:String                 = "NetStream.Play.Start";
		static public const NetStream_Play_Stop:String                  = "NetStream.Play.Stop";
		static public const NetStream_Play_Failed:String                = "NetStream.Play.Failed";
		static public const NetStream_Play_StreamNotFound:String        = "NetStream.Play.StreamNotFound";
		static public const NetStream_Play_Reset:String                 = "NetStream.Play.Reset";
		static public const NetStream_Play_PublishNotify:String         = "NetStream.Play.PublishNotify";
		static public const NetStream_Play_UnpublishNotify:String       = "NetStream.Play.UnpublishNotify";
		static public const NetStream_Play_InsufficientBW:String        = "NetStream.Play.InsufficientBW";
		static public const NetStream_Play_FileStructureInvalid:String  = "NetStream.Play.FileStructureInvalid";
		static public const NetStream_Play_NoSupportedTrackFound:String = "NetStream.Play.NoSupportedTrackFound";
		static public const NetStream_Play_Transition:String            = "NetStream.Play.Transition";
		static public const NetStream_Pause_Notify:String               = "NetStream.Pause.Notify";
		static public const NetStream_Unpause_Notify:String             = "NetStream.Unpause.Notify";
		static public const NetStream_Record_Start:String               = "NetStream.Record.Start";
		static public const NetStream_Record_NoAccess:String            = "NetStream.Record.NoAccess";
		static public const NetStream_Record_Stop:String                = "NetStream.Record.Stop";
		static public const NetStream_Record_Failed:String              = "NetStream.Record.Failed";
		static public const NetStream_Seek_Failed:String                = "NetStream.Seek.Failed";
		static public const NetStream_Seek_InvalidTime:String           = "NetStream.Seek.InvalidTime";
		static public const NetStream_Seek_Notify:String                = "NetStream.Seek.Notify";
		static public const NetConnection_Call_BadVersion:String        = "NetConnection.Call.BadVersion";
		static public const NetConnection_Call_Failed:String            = "NetConnection.Call.Failed";
		static public const NetConnection_Call_Prohibited:String        = "NetConnection.Call.Prohibited";
		static public const NetConnection_Connect_Closed:String         = "NetConnection.Connect.Closed";
		static public const NetConnection_Connect_Failed:String         = "NetConnection.Connect.Failed";
		static public const NetConnection_Connect_Success:String        = "NetConnection.Connect.Success";
		static public const NetConnection_Connect_Rejected:String       = "NetConnection.Connect.Rejected";
		static public const NetStream_Connect_Closed:String             = "NetStream.Connect.Closed";
		static public const NetStream_Connect_Failed:String             = "NetStream.Connect.Failed";
		static public const NetStream_Connect_Success:String            = "NetStream.Connect.Success";
		static public const NetStream_Connect_Rejected:String           = "NetStream.Connect.Rejected";
		static public const NetConnection_Connect_AppShutdown:String    = "NetConnection.Connect.AppShutdown";
		static public const NetConnection_Connect_InvalidApp:String     = "NetConnection.Connect.InvalidApp";
		static public const SharedObject_Flush_Success:String           = "SharedObject.Flush.Success";
		static public const SharedObject_Flush_Failed:String            = "SharedObject.Flush.Failed";
		static public const SharedObject_BadPersistence:String          = "SharedObject.BadPersistence";
		static public const SharedObject_UriMismatch:String             = "SharedObject.UriMismatch";
		
		static public const NETSTREAM_BUFFER_EMPTY:String               = "NetStream.Buffer.Empty";
		static public const NETSTREAM_BUFFER_FULL:String                = "NetStream.Buffer.Full";
		static public const NETSTREAM_BUFFER_FLUSH:String               = "NetStream.Buffer.Flush";
		static public const NETSTREAM_FAILED:String                     = "NetStream.Failed";
		static public const NETSTREAM_PUBLISH_START:String              = "NetStream.Publish.Start";
		static public const NETSTREAM_PUBLISH_BADNAME:String            = "NetStream.Publish.BadName";
		static public const NETSTREAM_PUBLISH_IDLE:String               = "NetStream.Publish.Idle";
		static public const NETSTREAM_UNPUBLISH_SUCCESS:String          = "NetStream.Unpublish.Success";
		static public const NETSTREAM_PLAY_START:String                 = "NetStream.Play.Start";
		static public const NETSTREAM_PLAY_STOP:String                  = "NetStream.Play.Stop";
		static public const NETSTREAM_PLAY_FAILED:String                = "NetStream.Play.Failed";
		static public const NETSTREAM_PLAY_STREAMNOTFOUND:String        = "NetStream.Play.StreamNotFound";
		static public const NETSTREAM_PLAY_RESET:String                 = "NetStream.Play.Reset";
		static public const NETSTREAM_PLAY_PUBLISHNOTIFY:String         = "NetStream.Play.PublishNotify";
		static public const NETSTREAM_PLAY_UNPUBLISHNOTIFY:String       = "NetStream.Play.UnpublishNotify";
		static public const NETSTREAM_PLAY_INSUFFICIENTBW:String        = "NetStream.Play.InsufficientBW";
		static public const NETSTREAM_PLAY_FILESTRUCTUREINVALID:String  = "NetStream.Play.FileStructureInvalid";
		static public const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "NetStream.Play.NoSupportedTrackFound";
		static public const NETSTREAM_PLAY_TRANSITION:String            = "NetStream.Play.Transition";
		static public const NETSTREAM_PAUSE_NOTIFY:String               = "NetStream.Pause.Notify";
		static public const NETSTREAM_UNPAUSE_NOTIFY:String             = "NetStream.Unpause.Notify";
		static public const NETSTREAM_RECORD_START:String               = "NetStream.Record.Start";
		static public const NETSTREAM_RECORD_NOACCESS:String            = "NetStream.Record.NoAccess";
		static public const NETSTREAM_RECORD_STOP:String                = "NetStream.Record.Stop";
		static public const NETSTREAM_RECORD_FAILED:String              = "NetStream.Record.Failed";
		static public const NETSTREAM_SEEK_FAILED:String                = "NetStream.Seek.Failed";
		static public const NETSTREAM_SEEK_INVALIDTIME:String           = "NetStream.Seek.InvalidTime";
		static public const NETSTREAM_SEEK_NOTIFY:String                = "NetStream.Seek.Notify";
		static public const NETCONNECTION_CALL_BADVERSION:String        = "NetConnection.Call.BadVersion";
		static public const NETCONNECTION_CALL_FAILED:String            = "NetConnection.Call.Failed";
		static public const NETCONNECTION_CALL_PROHIBITED:String        = "NetConnection.Call.Prohibited";
		static public const NETCONNECTION_CONNECT_CLOSED:String         = "NetConnection.Connect.Closed";
		static public const NETCONNECTION_CONNECT_FAILED:String         = "NetConnection.Connect.Failed";
		static public const NETCONNECTION_CONNECT_SUCCESS:String        = "NetConnection.Connect.Success";
		static public const NETCONNECTION_CONNECT_REJECTED:String       = "NetConnection.Connect.Rejected";
		static public const NETSTREAM_CONNECT_CLOSED:String             = "NetStream.Connect.Closed";
		static public const NETSTREAM_CONNECT_FAILED:String             = "NetStream.Connect.Failed";
		static public const NETSTREAM_CONNECT_SUCCESS:String            = "NetStream.Connect.Success";
		static public const NETSTREAM_CONNECT_REJECTED:String           = "NetStream.Connect.Rejected";
		static public const NETCONNECTION_CONNECT_APPSHUTDOWN:String    = "NetConnection.Connect.AppShutdown";
		static public const NETCONNECTION_CONNECT_INVALIDAPP:String     = "NetConnection.Connect.InvalidApp";
		static public const SHAREDOBJECT_FLUSH_SUCCESS:String           = "SharedObject.Flush.Success";
		static public const SHAREDOBJECT_FLUSH_FAILED:String            = "SharedObject.Flush.Failed";
		static public const SHAREDOBJECT_BADPERSISTENCE:String          = "SharedObject.BadPersistence";
		static public const SHAREDOBJECT_URIMISMATCH:String             = "SharedObject.UriMismatch";
		
		//---------------------------------------
		// instance
		//---------------------------------------
		protected var _event:Event = null;

		public function get event():Event {
			return _event;
		}
		
		public function get code():String {
			return type;
		}
		public function get level():String {
			return CodeInfo.level(type);
		}
		public function get meaning():String {
			return CodeInfo.meaning(type);
		}
		
		//---------------------------------------
		// Constructor
		//---------------------------------------
		public function CodeEvent(
			type:String,
			bubbles:Boolean    = false,
			cancelable:Boolean = false,
			event:Event        = null
		) {
			super(type, bubbles, cancelable);
			
			_event = event;
		}
		
		override public function clone():Event {
			return new CodeEvent(type, bubbles, cancelable, _event);
		}
	}
}