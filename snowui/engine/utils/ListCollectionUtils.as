package snowui.engine.utils 
{
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	import starling.events.Event;
	import starling.utils.AssetManager;
	/**
	 * 用于将XML或JSON解析成ListCollection的工具
	 * @author snow
	 */
	public class ListCollectionUtils 
	{
		protected var data:XML;
		protected var dataProvider:ListCollection;
		protected var assetManager:AssetManager
		protected var dataComplete:Function
		public function ListCollectionUtils(data:*,dataProvider:ListCollection,assetManager:AssetManager=null,complete:Function=null) 
		{
			dataComplete = complete;
			this.data = XML(data);
			this.dataProvider = dataProvider;
			var source:String = data.@source;
			this.assetManager = assetManager;
			if (source!="")
			{
				if (source.indexOf("asset://")!=-1)
				{
					var assetName:String = source.replace("asset://", "");
					var xml:XML = assetManager.getXml(assetName)
					getDataProvider(xml.children());
					
				}else
				{
					var assetsLoader:AssetsLoader = new AssetsLoader();
					assetsLoader.addEventListener(Event.COMPLETE,onAssetsLoaderComplete)
					assetsLoader.source = source;
				}
				
			}else
			{
				getDataProvider(data.children());
			}
		}	
		public function loadConfig(data:*, dataProvider:ListCollection):void
		{
			this.data = XML(data);
			this.dataProvider = dataProvider;
			var source:String = data.@source;
			if (source!="")
			{
				if (source.indexOf("asset://")!=-1)
				{
					var assetName:String = source.replace("asset://", "");
					var xml:XML = assetManager.getXml(assetName)
					getDataProvider(xml.children());
					
				}else
				{
					var assetsLoader:AssetsLoader = new AssetsLoader();
					assetsLoader.addEventListener(Event.COMPLETE,onAssetsLoaderComplete)
					assetsLoader.source = source;
				}
				
			}else
			{
				getDataProvider(data.children());
			}
		}
		private function onAssetsLoaderComplete(e:Event):void 
		{
			if (e.data.extension == "json" || e.data.extension == "JSON")
			{
				
				var jsonStr:String = String(e.data.res);
				try
				{
					var array:Object = JSON.parse(jsonStr);
					getDataProviderToJSON(array);
					
				}catch (err:Error)
				{
					Alert.show("非法的JSON格式")
					return
				}
				
			}else
			{
				var xml:XML = XML(e.data.res);
				getDataProvider(xml.children());
			}
		}
		protected function getDataProviderToJSON(array:Object):void
		{
			this.dataProvider.data = array;
			 if (dataComplete != null) dataComplete();
		}
		protected function getDataProvider(xmllist:XMLList):void
		{
			var length:int = xmllist.length();
			var item:Object = null;
			for (var i:int = 0; i <length; i++) 
			{
				var node:XML = xmllist[i];
				var nodeName:String = node.name();
				if (nodeName == "String"||nodeName=="int"||nodeName=="Number")
				{
					this.dataProvider.addItem(node.toString())					
				}else
				{
					item = { };
					XMLUtil.attributesToObject(xmllist[i], item);
					XMLUtil.xmlToObject(xmllist[i],item);
					if (item.data)
					{
						item.data = new Object();
						XMLUtil.xmlToObject(XML(xmllist[i].data), item.data);
						XMLUtil.attributesToObject(XML(xmllist[i].data), item.data);
					}
					this.dataProvider.addItem(item)
				}
			}
		    if (dataComplete != null) dataComplete();
		}
		public static function load(url:String,onComplete:Function=null):ListCollection
		{
			var xml:XML = XML("<dataProvider/>");
			xml.@source = url;
			var dataProvider:ListCollection=new ListCollection()
			new ListCollectionUtils(xml,dataProvider,null,onComplete)
			return dataProvider;
		}
		public static function loadData(xml:XML,dataProvider:ListCollection=null):ListCollection
		{
			dataProvider = dataProvider || new ListCollection();
			new ListCollectionUtils(xml,dataProvider)
			return dataProvider;
		}
		public static function loadXMLList(xmllist:XMLList, dataProvider:ListCollection = null):ListCollection
		{
			dataProvider = dataProvider || new ListCollection();
			var xml:XML = XML("<dataProvider/>");
			xml.appendChild(xmllist)
			new ListCollectionUtils(xml, dataProvider);
			return dataProvider;
		}
	}

}