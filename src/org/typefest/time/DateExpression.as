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

package org.typefest.time {
	import flash.utils.Dictionary;
	
	public class DateExpression {
		// http://www.python.jp/doc/release/lib/module-time.html
		
		protected static var _as:Dictionary = new Dictionary();
		_as[0] = "Sun";
		_as[1] = "Mon";
		_as[2] = "Tue";
		_as[3] = "Wed";
		_as[4] = "Thu";
		_as[5] = "Fri";
		_as[6] = "Sat";
		protected static var _As:Dictionary = new Dictionary();
		_As[0] = "Sunday";
		_As[1] = "Monday";
		_As[2] = "Tuesday";
		_As[3] = "Wednesday";
		_As[4] = "Thursday";
		_As[5] = "Friday";
		_As[6] = "Saturday";
		protected static var _bs:Dictionary = new Dictionary();
		_bs[0]  = "Jan";
		_bs[1]  = "Feb";
		_bs[2]  = "Mar";
		_bs[3]  = "Apr";
		_bs[4]  = "May";
		_bs[5]  = "Jun";
		_bs[6]  = "Jul";
		_bs[7]  = "Aug";
		_bs[8]  = "Sep";
		_bs[9]  = "Oct";
		_bs[10] = "Nov";
		_bs[11] = "Dec";
		protected static var _Bs:Dictionary = new Dictionary();
		_Bs[0]  = "January";
		_Bs[1]  = "February";
		_Bs[2]  = "March";
		_Bs[3]  = "April";
		_Bs[4]  = "May";
		_Bs[5]  = "June";
		_Bs[6]  = "July";
		_Bs[7]  = "August";
		_Bs[8]  = "September";
		_Bs[9]  = "October";
		_Bs[10] = "November";
		_Bs[11] = "December";
		
		/* ============ */
		/* = Instance = */
		/* ============ */
		protected var _date:Date = null;
		
		public function get a():String {
			return _as[this._date.day];
		}
		
		public function get A():String {
			return _As[this._date.day];
		}

		public function get b():String {
			return _bs[this._date.month];
		}

		public function get B():String {
			return _Bs[this._date.month];
		}

		public function get c():String {
			// not yet
			return null;
		}
		
		public function get d():String {
			// not yet
			return null;
		}
		
		public function get H():String {
			// not yet
			return null;
		}
		
		public function get I():String {
			// not yet
			return null;
		}
		
		public function get j():String {
			// not yet
			return null;
		}
		
		public function get m():String {
			// not yet
			return null;
		}
		
		public function get M():String {
			// not yet
			return null;
		}
		
		public function get p():String {
			// not yet
			return null;
		}
		
		public function get S():String {
			// not yet
			return null;
		}
		
		public function get U():String {
			// not yet
			return null;
		}
		
		public function get w():String {
			// not yet
			return null;
		}
		
		public function get W():String {
			// not yet
			return null;
		}
		
		public function get x():String {
			// not yet
			return null;
		}
		
		public function get X():String {
			// not yet
			return null;
		}
		
		public function get y():String {
			// not yet
			return null;
		}
		
		public function get Y():String {
			// not yet
			return null;
		}
		
		public function get Z():String {
			// not yet
			return null;
		}
		
		public function DateExpression(date:Date = null) {
			this._date = (date === null) ? new Date() : new Date(date.time);
		}
	}
}