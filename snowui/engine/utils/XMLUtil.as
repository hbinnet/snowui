package snowui.engine.utils
{
	import flash.utils.ByteArray;

	/**
	 * XML辅助类 
	 */
	public final class XMLUtil
	{
		public static function createFrom(source:*):XML
		{
			if (source is Class)
				source = new source();
			
			if (source is ByteArray)
			{
				try
				{
					(source as ByteArray).uncompress();
				}
				catch (e:Error)
				{}
				source = source.toString();
			}
			
			if (source is String)
			{
				//去掉额外的文件首字符
				while (source.substr(0,1) != "<")
					source = source.substr(1);
				return new XML(source);
			}
			return null;
		}
		
		public static function attributesToObject(xml:XML,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			
			for each (var item:XML in xml.attributes())
				result[item.name().toString()] = item.toString();
			return result;
		}
		public static function xmlToObject(data_XML:XML,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			for each (var xml:XML in data_XML.children())
			{
				var nodeName:String = xml.name();
				var item:Object= new Object();
				if (data_XML[nodeName].length() > 1)
				{
					if (!result.hasOwnProperty(nodeName))
					{
						result[nodeName] = new Array();
					}
					attributesToObject(xml, item);
					xmlToObject(xml, item);
					(result[nodeName] as Array).push(item);
					
				}else if (xml.attributes().length() > 0)
				{
					attributesToObject(xml, item);
					xmlToObject(xml, item);
					result[nodeName] = item;
					
				}else
				{
				    result[nodeName] = xml.toString();
				}
			}
			return result;
		}
		public static function objectToXML(obj:Object, result:XML=null,filter:Array=null):XML
		{
			if (!result)
				result = <xml/>;
			for (var key:String in obj)
			{
				if (filter)
				{
					if (filter.indexOf(key)==-1)
					{
					   result[key] = obj[key];	
					}
					
				}else {
					if (obj[key] is Array)
					{
						var array:Array = obj[key];
						for (var i:int = 0; i <array.length; i++) 
						{
							var xml:XML=XML("<"+key+"/>")
							result.appendChild(objectToXML(array[i],xml))
						}
						
					}else if (obj[key] is String || obj[key] is Number || obj[key] is uint || obj[key] is int || obj[key] is Boolean)
					{
						result["@"+key] = obj[key];	
					}else
					{
						xml=XML("<"+key+"/>")
						result.appendChild(objectToXML(obj[key],xml))
					}
					
				}
			}
			return result;
		}
		public static function objectToAttributes(obj:Object,result:XML = null,filter:Array=null):XML
		{
			if (!result)
				result = <xml/>;
			
			for (var key:String in obj)
			{
				if (filter)
				{
					if (filter.indexOf(key)==-1)
					{
					   result["@" + key] = obj[key];
					}
					
				}else
				{
					result["@" + key] = obj[key];
				}
			}
			
			return result;
		}
		
		public static function childrenToAttributes(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.children())
				result["@" + xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function attributesToChildren(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.attributes())
			{
				var child:XML = <xml/>
				child.setName(xml.name());
				child.appendChild(xml.toString());
				result.appendChild(child);
			}
			return result;
		}
	}
}