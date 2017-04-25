package snowui.engine.data 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import snow.utils.XMLUtil;
	/**
	 * ...
	 * @author 游骑兵
	 */
	public class Binding 
	{
		protected var items:Array = [];
		protected var targets:Dictionary
		public function Binding(targets:Dictionary) 
		{
			this.targets = targets;
		}
		public function addItem(item:Object):void
		{
			items.push(item)
		}	
		public function removeItem(item:Object):Object
		{
			var index:int = items.indexOf(item);
			if (index!=-1)
			{
				return items.removeAt(index)
			}
			return null;
		}
		public function getItemAt(index:int):Object
		{
			return items[index]
		}
		public function get length():int 
		{
			return items.length;
		}
		public function getChildByID(id:String):Object
		{
			return targets[id]
		}
		public static function dataParse(xml:XML, binding:Binding):void
		{
			var xmllist:XMLList = xml.children();
			var length:int = xmllist.length();
			for (var i:int = 0; i <length; i++) 
			{
				var item:Object = { };
				XMLUtil.attributesToObject(xmllist[i], item)
				binding.addItem(item)
			}
		}
		public static function getTargetPropValue(target:*,prop:String):*
		{
			
			var foo:RegExp =/\+|\-|\*|\//g
			var calculates:Array = prop.match(foo);
			if (calculates.length > 0)
			{
			   var calc:String = calculates[0];
			   var cns:Array = prop.split(calc);
			   var obj:Object =getTargetPropValue(target,cns[0])
			   for (var i:int =1; i <cns.length; i++) 
			   {
				   if (calc == "+")
				   {
				     obj = obj + getTargetPropValue(target, cns[i]);
					 
				   }else if (calc == "-")
				   {
					   obj =Number(obj)-getTargetPropValue(target, cns[i]);
					   
				   }else if (calc == "*")
				   {
					   obj =Number(obj)*getTargetPropValue(target, cns[i]);
					   
				   }else if (calc == "/")
				   {
					   obj = Number(obj)/getTargetPropValue(target, cns[i]);
				   }
			   }
			   return obj;
			}
			
			if (prop.indexOf("string:")!=-1)
			{
				prop = prop.replace("string:", "");
				return prop;
			}
			
			var array:Array = prop.split(".");
			var length:int = array.length;
			if (length== 1)
			{
				return target[array[0]];
				
			}else if (length == 2)
			{
				return target[array[0]][array[1]];
				
			}else if (length == 3)
			{
				return target[array[0]][array[1]][array[2]];
				
			}else if (length == 4)
			{
				return target[array[0]][array[1]][array[2]][array[3]];
				
			}else if (length == 5)
			{
				return target[array[0]][array[1]][array[2]][array[3]][array[4]];
			}
			return target[prop]
		}
	}

}