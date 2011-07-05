package org.friendlytalk.utils
{
	import flash.system.Capabilities;

	public class RuntimeUtil
	{
		/** */
		public static function newerThan(major:uint, minor:uint=0, build:uint=0):Boolean
		{
			var version:Array = Capabilities.version.match(/\d+/g);
			
			if (major > Number(version[0]) || 
				minor > Number(version[1]) || 
				build > Number(version[2]))
			{
				return false;
			}
			
			return true;
		}
	}
}