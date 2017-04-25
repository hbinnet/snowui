package snowui.engine.style 
{
	import snowui.engine.UIBuilder;
	import feathers.controls.Button;
	import feathers.controls.text.BitmapFontTextEditor;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextBlockTextEditor;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.controls.ToggleButton;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * 样式解析器
	 * @author 游骑兵
	 */
	public class StyleBuilder 
	{
		protected var bandDataStyleNameTheme:BandDataStyleNameFunctionTheme;
		protected var uiBuilder:UIBuilder;
		public function StyleBuilder(uib:UIBuilder) 
		{
			uiBuilder = uib;
			bandDataStyleNameTheme = new BandDataStyleNameFunctionTheme();
		}
		public function createStyle(skin:XML):void
		{
			var xmllist:XMLList = skin.children();
			var length:int = xmllist.length();
			for (var i:int = 0; i <length; i++) 
			{
				var node:XML = xmllist[i];
				var nodeName:String = node.name();
				var className:Class = UIBuilder.controlTabel[nodeName];
				var styleName:String = node.@name;
				if (className != null) addStyle(className,styleName,node);
			}
		}
		public function addStyle(className:Class, styleName:String, data:Object):void
		{
			if (className == null) return;
			if (styleName == null) return;
			if (data == null) return;
			var bandDataStyleNameFunctionStyleProvider:BandDataStyleNameFunctionStyleProvider
			if (styleName == "default")
			{
				bandDataStyleNameFunctionStyleProvider = bandDataStyleNameTheme.getStyleProviderForClass(className)
				bandDataStyleNameFunctionStyleProvider.defaultStyleFunction = setTargetStyle;
				bandDataStyleNameFunctionStyleProvider.defaultStyleData = data;
				
			}else
			{
				bandDataStyleNameFunctionStyleProvider = bandDataStyleNameTheme.getStyleProviderForClass(className);
				bandDataStyleNameFunctionStyleProvider.setFunctionForStyleName(styleName, setTargetStyle, data);
			}			
		}
		protected function setTargetStyle(target:Object,data:Object):void
		{
			var child:DisplayObject=target as DisplayObject
			var xml:XML = data as XML;
			uiBuilder.createUI(xml,child)
		}
	}

}