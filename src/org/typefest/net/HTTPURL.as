/*
as3tf
http://code.google.com/p/as3tf/

Licensed under the MIT License

Copyright (c) 2008 Taro Hanamura

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

// referred to http://www.din.or.jp/~ohzaki/perl.htm#httpURL
package org.typefest.net {
	public class HTTPURL {
		public static const HTTP_URL_EXP:RegExp = /^(https?|shttp):\/\/(?:((?:[-_.!~*'()a-zA-Z0-9;:&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)@)?((?:[a-zA-Z0-9](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\.)*[a-zA-Z](?:[-a-zA-Z0-9]*[a-zA-Z0-9])?\.?|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?::([0-9]*))?(\/(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*(?:\/(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*(?:;(?:[-_.!~*'()a-zA-Z0-9:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*)*)*)?(?:\?((?:[-_.!~*'()a-zA-Z0-9;\/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*))?(?:#((?:[-_.!~*'()a-zA-Z0-9;\/?:@&=+$,]|%[0-9A-Fa-f][0-9A-Fa-f])*))?$/;
		/*'*/
		
		/*
		*	var url:String = "http://typefest.org/one/two/three/file.html";
		*	
		*	trace(HTTPURL.root(url));
		*	// -> http://typefest.org/
		*	
		*	*/
		public static function root(url:String):String {
			return new HTTPURL(url).root;
		}
		
		/*
		*	var url:String = "http://typefest.org/one/two/three/file.html";
		*	
		*	trace(HTTPURL.join(url, "document.html"));
		*	// -> http://typefest.org/one/two/three/document.html
		*	
		*	trace(HTTPURL.join(url, "/top.html"));
		*	// -> http://typefest.org/top.html
		*	
		*	trace(HTTPURL.join(url, "../../another_two/another_three/another_file.html"));
		*	// -> http://typefest.org/one/another_two/another_three/another_file.html
		*	
		*	trace(HTTPURL.join(url, "http://www.google.com/"));
		*	// -> http://www.google.com/
		*	
		*	*/
		public static function join(url:String, ref:String):String {
			return new HTTPURL(url).join(ref);
		}
		
		/*
		*	HTTPURL.directory("http://typefest.org/one/two/three/file.html");
		*	// -> http://typefest.org/one/two/three/
		*	
		*	HTTPURL.directory("http://typefest.org/top.html");
		*	// -> http://typefest.org/
		*	
		*	*/
		public static function directory(url:String):String {
			return new HTTPURL(url).directory;
		}
		
		public static function valid(url:String):Boolean {
			return HTTP_URL_EXP.test(url);
		}
		
		protected static function _queryToObject(query:String):Object {
			var obj:Object = null;
			var qs:Array   = query.split("&");
			var i:int;
			var key:String;
			var value:String;
			for each(var q:String in qs) {
				i = q.indexOf("=");
				if(i > 0) {
					if(obj === null) {
						obj = {};
					}
					key   = q.substr(0, i);
					value = q.substr(i + 1);
					if(key in obj) {
						if(obj[key] is Array) {
							obj[key].push(value);
						} else {
							obj[key] = [obj[key], value];
						}
					} else {
						obj[key] = value;
					}
				}
			}
			return obj;
		}
		
		protected static const _REF_EXP:RegExp = /^([^\/]*)(\/?)(.*)/;
		
		protected static function _join(httpurl:HTTPURL, ref:String):String {
			var $:* = _REF_EXP.exec(ref);
			
			if($[1] === "") {
				if($[2] === "/") {
					return arguments.callee(new HTTPURL(httpurl.root), $[3]);
				} else {
					return httpurl.url;
				}
			} else if($[1] === ".") {
				return arguments.callee(new HTTPURL(httpurl.directory), $[3]);
			} else if($[1] === "..") {
				var dirs:Array = httpurl.directories;
				if(dirs.length < 2) {
					return arguments.callee(new HTTPURL(httpurl.root), $[3]);
				} else {
					return arguments.callee(
						new HTTPURL(
							httpurl.root +
							dirs.slice(0, dirs.length - 1).join("/") +
							"/"
						),
						$[3]
					);
				}
			} else {
				return arguments.callee(
					new HTTPURL(httpurl.directory + $[1] + $[2]), $[3]
				);
			}
		}
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _originalURL:String = null;
		protected var _url:String         = null;
		protected var _scheme:String      = null;
		protected var _userinfo:String    = null;
		protected var _host:String        = null;
		protected var _port:String        = null;
		protected var _path:String        = null;
		protected var _query:String       = null;
		protected var _fragment:String    = null;
		
		protected var _root:String       = null;
		protected var _username:String   = null;
		protected var _password:String   = null;
		protected var _portNumber:int    = -1;
		protected var _directories:Array = null;
		protected var _basename:String   = null;
		protected var _extension:String  = null;
		protected var _queryItems:Object = null;
		
		public function get originalURL():String {
			return this._originalURL;
		}
		
		public function get url():String {
			return this._url;
		}
		
		public function get scheme():String {
			return this._scheme;
		}
		
		public function get userinfo():String {
			return this._userinfo;
		}
		
		public function get host():String {
			return this._host;
		}
		
		public function get port():String {
			return this._port;
		}
		
		public function get path():String {
			return this._path;
		}
		
		public function get query():String {
			return this._query;
		}
		
		public function get fragment():String {
			return this._fragment;
		}
		
		public function get root():String {
			return this._root;
		}
		
		public function get username():String {
			return this._username;
		}
		
		public function get password():String {
			return this._password;
		}
		
		public function get portNumber():int {
			return this._portNumber;
		}
		
		public function get directories():Array {
			return this._directories.concat();
		}
		
		public function get basename():String {
			return this._basename;
		}
		
		public function get extension():String {
			return this._extension;
		}
		
		public function get queryItems():Object {
			if(this._queryItems === null) {
				return null;
			} else {
				var r:Object = {};
				var value:*;
				for(var key:String in this._queryItems) {
					value = this._queryItems[key];
					if(value is Array) {
						r[key] = value.concat();
					} else {
						r[key] = value;
					}
				}
				return r;
			}
		}
		
		public function get directory():String {
			if(this._directories.length > 0) {
				return this._root + this._directories.join("/") + "/";
			} else {
				return this._root;
			}
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function HTTPURL(url:String) {
			this._originalURL = url;
			
			url = decodeURI(url);
			
			var $:* = url.match(HTTP_URL_EXP);
			
			if($) {
				this._url = $[0];
				
				this._scheme = $[1];
				
				if($[2] !== undefined) {
					this._userinfo = $[2];
					
					var uii:int = this._userinfo.indexOf(":");
					if(uii > 0) {
						this._username = this._userinfo.substr(0, uii);
						this._password = this._userinfo.substr(uii + 1);
					}
				}
				
				this._host = $[3];
				
				if($[4] !== undefined) {
					this._port = $[4];
					
					this._portNumber = parseInt(this._port);
				}
				
				if($[5] === undefined) {
					this._path = "/";
					this._directories = [];
				} else {
					this._path = $[5];
					this._directories = [];
					
					var direxp:RegExp = /\/([^\/]+)(?=\/)/g;
					var $d:*;
					while($d = direxp.exec(this._path)) {
						this._directories.push($d[1]);
					}
					
					var index:int       = this._path.lastIndexOf("/");
					var basename:String = this._path.substr(index + 1);
					if(basename.length !== 0) {
						this._basename = basename;
						
						var extindex:int = basename.lastIndexOf(".");
						if(extindex > 0 && extindex < basename.length - 1) {
							this._extension = basename.substr(extindex + 1);
						}
					}
				}
				
				if($[6] !== undefined) {
					this._query = $[6];
					this._queryItems = _queryToObject(this._query);
				}
				
				if($[7] !== undefined) {
					this._fragment = $[7];
				}
				
				// make root
				this._root = this._scheme + "://";
				if(this._userinfo !== null) {
					this._root += this._userinfo + "@";
				}
				this._root += this._host;
				if(this._port !== null) {
					this._root += ":" + this._port;
				}
				this._root += "/";
				
				// add slash
				if(this._url.length < this._root.length) {
					this._url = this._root;
				}
			} else {
				throw new ArgumentError("HTTPURL: URL is not valid");
			}
		}
		
		public function join(ref:String):String {
			try {
				return new HTTPURL(ref).url;
			} catch(e:ArgumentError) {
				return _join(this, ref);
			}
			return null;
		}
		
		public function toString():String {
			return this._url;
		}
	}
}