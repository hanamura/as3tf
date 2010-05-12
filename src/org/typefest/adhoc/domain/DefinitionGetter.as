/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.adhoc.domain {
	import flash.display.Loader;
	import flash.utils.Dictionary;
	
	public class DefinitionGetter extends Object {
		/*
		
		// usage
		
		// give complete loader (SWF) object
		var getter:DefinitionGetter = new DefinitionGetter(loader);
		
		// get class
		var klass:Class = getter.get("packagename.ClassName");
		if (klass) {
			// ...
		}
		
		// get instance (with no arguments)
		var instance:* = getter.create("packagename.ClassName");
		if (instance) {
			// ...
		}
		
		*/
		
		protected var _loader:Loader          = null;
		protected var _definitions:Dictionary = null;
		
		public function DefinitionGetter(loader:Loader) {
			super();
			_loader      = loader;
			_definitions = new Dictionary(false);
		}
		
		public function get(name:String):* {
			if (!(name in _definitions)) {
				try {
					_definitions[name] = _loader.contentLoaderInfo
					                            .applicationDomain
					                            .getDefinition(name);
				} catch (e:ReferenceError) {
					_definitions[name] = null;
				}
			}
			
			return _definitions[name];
		}
		
		public function create(name:String):* {
			var definition:* = get(name);
			
			return definition ? (new definition()) : null;
		}
	}
}