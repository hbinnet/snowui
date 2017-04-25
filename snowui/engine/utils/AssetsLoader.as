package snowui.engine.utils 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import ghostcat.text.FilePath;
	
	import ghostcat.text.FilePath
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * ...
		库中    res://resID
		组件    ui://URL;
	 * @author 游骑兵
	 */
	public class AssetsLoader extends EventDispatcher 
	{
		protected var extList:String = "jpg,JPG,PNG,png,SWF,swf,flv,FLV,MP4,mp4"
		protected var _source:String;
		protected var loader:Loader
		protected var dataLoader:URLLoader
		protected var extension:String = "";
		public function AssetsLoader() 
		{
			super()
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,onLoaderComplete)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoaderIOError)
			
			dataLoader = new URLLoader();
			dataLoader.addEventListener(flash.events.Event.COMPLETE, onDataComplete)
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, onDataIOError)
		}		
		private function onDataIOError(e:IOErrorEvent):void 
		{
			dispose()
		}		
		private function onDataComplete(e:flash.events.Event):void 
		{
			var data:Object = { };
			data.source = _source;
			data.res = e.target.data;
			extension=extension.toLocaleLowerCase()
			data["extension"] =extension;
			this.dispatchEventWith(starling.events.Event.COMPLETE, false, data)
			dispose()
		}
		private function onLoaderIOError(e:IOErrorEvent):void 
		{
			dispose()
		}
		private function onLoaderComplete(e:flash.events.Event):void 
		{
			var data:Object = { };
			data.source = _source;
			data.res = e.target.content;
			data["extension"] =extension;
			this.dispatchEventWith(starling.events.Event.COMPLETE, false, data)
			dispose()
		}
		public function get source():String 
		{
			return _source;
		}	
		public function set source(value:String):void 
		{
			_source = value;
			if (_source.indexOf("http://") != -1)
			{
				var last:int = _source.lastIndexOf(".")
				if (last != -1)
				{
					extension = _source.substr(last+1,_source.length);
				}
				
			}else
			{
				var filePath:FilePath = new FilePath(_source)
				extension = filePath.extension
			}
			if (extList.indexOf(extension) >= 0)
			 {
				 loader.load(new URLRequest(_source))
			 }else
			 {
				 dataLoader.load(new URLRequest(_source))
			 }
		}
		public function dispose():void
		{
			loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,onLoaderComplete)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderIOError)
			
			dataLoader.removeEventListener(flash.events.Event.COMPLETE, onDataComplete)
			dataLoader.removeEventListener(IOErrorEvent.IO_ERROR, onDataIOError)
			
			loader.unloadAndStop()
			loader=null
			dataLoader=null
		}
		
	}

}