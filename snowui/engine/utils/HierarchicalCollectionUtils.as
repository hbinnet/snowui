package snowui.engine.utils 
{
	import feathers.data.HierarchicalCollection;
	import starling.events.Event;
	import starling.utils.AssetManager;
	/**
	 * 用于将XML解析成HierarchicalCollection的工具
	 * @author snow
	 */
	public class HierarchicalCollectionUtils 
	{
		protected var data:XML;
		protected var dataProvider:HierarchicalCollection;
		public function HierarchicalCollectionUtils(data:XML,dataProvider:HierarchicalCollection,assetManager:AssetManager=null) 
		{
			this.data = data;
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
			var xml:XML = XML(e.data.res);
			getDataProvider(xml.children());
		}
		private function getDataProvider(xmllist:XMLList):void 
		{
			var length:int = xmllist.length();
			var clength:int = 0;
			var childrenXMLlist:XMLList = null;
			for (var i:int = 0; i <length; i++)
			{
				var headerItem:Object = { };
				XMLUtil.attributesToObject(xmllist[i], headerItem)
				childrenXMLlist = xmllist[i].children();
				clength = childrenXMLlist.length();
				var children:Array = new Array() 
				headerItem.children = children;
				for (var j:int = 0; j <clength; j++) 
				{
					var item:Object = { };
					XMLUtil.attributesToObject(childrenXMLlist[j],item);
					XMLUtil.xmlToObject(childrenXMLlist[j],item);
					children.push(item)
				}
				dataProvider.addItemAt(headerItem, i);
			}
		}
		public static function loadData(xml:XML,datas:HierarchicalCollection=null):HierarchicalCollection
		{
			datas = datas || new HierarchicalCollection();
			new HierarchicalCollectionUtils(xml,datas)
			return datas;
		}
		
	}

}