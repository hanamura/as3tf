/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.net.media {
	public class CodeInfo extends Object {
		static protected const __INFO__:* = {};
		__INFO__["NetStream.Buffer.Empty"]               = {code:"NetStream.Buffer.Empty",               level:"status",  meaning:"Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again."};
		__INFO__["NetStream.Buffer.Full"]                = {code:"NetStream.Buffer.Full",                level:"status",  meaning:"The buffer is full and the stream will begin playing."};
		__INFO__["NetStream.Buffer.Flush"]               = {code:"NetStream.Buffer.Flush",               level:"status",  meaning:"Data has finished streaming, and the remaining buffer will be emptied."};
		__INFO__["NetStream.Failed"]                     = {code:"NetStream.Failed",                     level:"error",   meaning:"Flash Media Server only. An error has occurred for a reason other than those listed in other event codes."};
		__INFO__["NetStream.Publish.Start"]              = {code:"NetStream.Publish.Start",              level:"status",  meaning:"Publish was successful."};
		__INFO__["NetStream.Publish.BadName"]            = {code:"NetStream.Publish.BadName",            level:"error",   meaning:"Attempt to publish a stream which is already being published by someone else."};
		__INFO__["NetStream.Publish.Idle"]               = {code:"NetStream.Publish.Idle",               level:"status",  meaning:"The publisher of the stream is idle and not transmitting data."};
		__INFO__["NetStream.Unpublish.Success"]          = {code:"NetStream.Unpublish.Success",          level:"status",  meaning:"The unpublish operation was successfuul."};
		__INFO__["NetStream.Play.Start"]                 = {code:"NetStream.Play.Start",                 level:"status",  meaning:"Playback has started."};
		__INFO__["NetStream.Play.Stop"]                  = {code:"NetStream.Play.Stop",                  level:"status",  meaning:"Playback has stopped."};
		__INFO__["NetStream.Play.Failed"]                = {code:"NetStream.Play.Failed",                level:"error",   meaning:"An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access."};
		__INFO__["NetStream.Play.StreamNotFound"]        = {code:"NetStream.Play.StreamNotFound",        level:"error",   meaning:"The FLV passed to the play() method can't be found."};
		__INFO__["NetStream.Play.Reset"]                 = {code:"NetStream.Play.Reset",                 level:"status",  meaning:"Caused by a play list reset."};
		__INFO__["NetStream.Play.PublishNotify"]         = {code:"NetStream.Play.PublishNotify",         level:"status",  meaning:"The initial publish to a stream is sent to all subscribers."};
		__INFO__["NetStream.Play.UnpublishNotify"]       = {code:"NetStream.Play.UnpublishNotify",       level:"status",  meaning:"An unpublish from a stream is sent to all subscribers."};
		__INFO__["NetStream.Play.InsufficientBW"]        = {code:"NetStream.Play.InsufficientBW",        level:"warning", meaning:"Flash Media Server only. The client does not have sufficient bandwidth to play the data at normal speed."};
		__INFO__["NetStream.Play.FileStructureInvalid"]  = {code:"NetStream.Play.FileStructureInvalid",  level:"error",   meaning:"The application detects an invalid file structure and will not try to play this type of file. For AIR and for Flash Player 9.0.115.0 and later."};
		__INFO__["NetStream.Play.NoSupportedTrackFound"] = {code:"NetStream.Play.NoSupportedTrackFound", level:"error",   meaning:"The application does not detect any supported tracks (video, audio or data) and will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later."};
		__INFO__["NetStream.Play.Transition"]            = {code:"NetStream.Play.Transition",            level:"status",  meaning:"Flash Media Server only. The stream transitions to another as a result of bitrate stream switching. This code indicates a success status event for the NetStream.play2() call to initiate a stream switch. If the switch does not succeed, the server sends a NetStream.Play.Failed event instead. For Flash Player 10 and later."};
		// __INFO__["NetStream.Play.Transition"]            = {code:"NetStream.Play.Transition",            level:"status",  meaning:"Flash Media Server 3.5 and later only. The server received the command to transition to another stream as a result of bitrate stream switching. This code indicates a success status event for the NetStream.play2() call to initiate a stream switch. If the switch does not succeed, the server sends a NetStream.Play.Failed event instead. When the stream switch occurs, an onPlayStatus event with a code of \"NetStream.Play.TransitionComplete\" is dispatched. For Flash Player 10 and later."};
		__INFO__["NetStream.Pause.Notify"]               = {code:"NetStream.Pause.Notify",               level:"status",  meaning:"The stream is paused."};
		__INFO__["NetStream.Unpause.Notify"]             = {code:"NetStream.Unpause.Notify",             level:"status",  meaning:"The stream is resumed."};
		__INFO__["NetStream.Record.Start"]               = {code:"NetStream.Record.Start",               level:"status",  meaning:"Recording has started."};
		__INFO__["NetStream.Record.NoAccess"]            = {code:"NetStream.Record.NoAccess",            level:"error",   meaning:"Attempt to record a stream that is still playing or the client has no access right."};
		__INFO__["NetStream.Record.Stop"]                = {code:"NetStream.Record.Stop",                level:"status",  meaning:"Recording stopped."};
		__INFO__["NetStream.Record.Failed"]              = {code:"NetStream.Record.Failed",              level:"error",   meaning:"An attempt to record a stream failed."};
		__INFO__["NetStream.Seek.Failed"]                = {code:"NetStream.Seek.Failed",                level:"error",   meaning:"The seek fails, which happens if the stream is not seekable."};
		__INFO__["NetStream.Seek.InvalidTime"]           = {code:"NetStream.Seek.InvalidTime",           level:"error",   meaning:"For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The message.details property contains a time code that indicates the last valid position to which the user can seek."};
		__INFO__["NetStream.Seek.Notify"]                = {code:"NetStream.Seek.Notify",                level:"status",  meaning:"The seek operation is complete."};
		__INFO__["NetConnection.Call.BadVersion"]        = {code:"NetConnection.Call.BadVersion",        level:"error",   meaning:"Packet encoded in an unidentified format."};
		__INFO__["NetConnection.Call.Failed"]            = {code:"NetConnection.Call.Failed",            level:"error",   meaning:"The NetConnection.call method was not able to invoke the server-side method or command."};
		__INFO__["NetConnection.Call.Prohibited"]        = {code:"NetConnection.Call.Prohibited",        level:"error",   meaning:"An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the file containing the code calling the NetConnection.call() method, or the AMF server does not have a policy file that trusts the domain of the the file containing the code calling the NetConnection.call() method."};
		__INFO__["NetConnection.Connect.Closed"]         = {code:"NetConnection.Connect.Closed",         level:"status",  meaning:"The connection was closed successfully."};
		__INFO__["NetConnection.Connect.Failed"]         = {code:"NetConnection.Connect.Failed",         level:"error",   meaning:"The connection attempt failed."};
		__INFO__["NetConnection.Connect.Success"]        = {code:"NetConnection.Connect.Success",        level:"status",  meaning:"The connection attempt succeeded."};
		__INFO__["NetConnection.Connect.Rejected"]       = {code:"NetConnection.Connect.Rejected",       level:"error",   meaning:"The connection attempt did not have permission to access the application."};
		__INFO__["NetStream.Connect.Closed"]             = {code:"NetStream.Connect.Closed",             level:"status",  meaning:"The P2P connection was closed successfully. The info.stream property indicates which stream has closed."};
		__INFO__["NetStream.Connect.Failed"]             = {code:"NetStream.Connect.Failed",             level:"error",   meaning:"The P2P connection attempt failed. The info.stream property indicates which stream has failed."};
		__INFO__["NetStream.Connect.Success"]            = {code:"NetStream.Connect.Success",            level:"status",  meaning:"The P2P connection attempt succeeded. The info.stream property indicates which stream has succeeded."};
		__INFO__["NetStream.Connect.Rejected"]           = {code:"NetStream.Connect.Rejected",           level:"error",   meaning:"The P2P connection attempt did not have permission to access the other peer. The info.stream property indicates which stream was rejected."};
		__INFO__["NetConnection.Connect.AppShutdown"]    = {code:"NetConnection.Connect.AppShutdown",    level:"error",   meaning:"The specified application is shutting down."};
		__INFO__["NetConnection.Connect.InvalidApp"]     = {code:"NetConnection.Connect.InvalidApp",     level:"error",   meaning:"The application name specified during connect is invalid."};
		__INFO__["SharedObject.Flush.Success"]           = {code:"SharedObject.Flush.Success",           level:"status",  meaning:"The \"pending\" status is resolved and the SharedObject.flush() call succeeded."};
		__INFO__["SharedObject.Flush.Failed"]            = {code:"SharedObject.Flush.Failed",            level:"error",   meaning:"The \"pending\" status is resolved, but the SharedObject.flush() failed."};
		__INFO__["SharedObject.BadPersistence"]          = {code:"SharedObject.BadPersistence",          level:"error",   meaning:"A request was made for a shared object with persistence flags, but the request cannot be granted because the object has already been created with different flags."};
		__INFO__["SharedObject.UriMismatch"]             = {code:"SharedObject.UriMismatch",             level:"error",   meaning:"An attempt was made to connect to a NetConnection object that has a different URI (URL) than the shared object."};
		
		static protected function _copy(info:*):* {
			return {
				code    : info["code"],
				level   : info["level"],
				meaning : info["meaning"]
			};
		}
		
		static public function get(code:String):* {
			return code in __INFO__ ? _copy(__INFO__[code]) : null;
		}
		static public function level(code:String):String {
			return code in __INFO__ ? __INFO__[code]["level"] : null;
		}
		static public function meaning(code:String):String {
			return code in __INFO__ ? __INFO__[code]["meaning"] : null;
		}
	}
}