package snowui.engine 
{
	import feathers.controls.renderers.*;
	import feathers.controls.text.*;
	import feathers.core.IFeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.LocalAutoCompleteSource;
	import feathers.skins.ImageSkin;
	import feathers.text.FontStylesSet;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.utils.ByteArray;
	import snowui.engine.data.Binding;
	import snowui.engine.utils.HierarchicalCollectionUtils;
	import snowui.engine.utils.ListCollectionUtils;
	import feathers.controls.popups.*;
	import feathers.core.FeathersControl;
	import feathers.text.BitmapFontTextFormat;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import starling.display.DisplayObjectContainer;
	import feathers.data.HierarchicalCollection;
	import feathers.data.ListCollection;
	import feathers.media.*;
	import feathers.controls.*;
	import feathers.core.ToggleGroup;
	import feathers.layout.*;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite3D;
	import starling.geom.Polygon;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * UI解析类
	 * @author 游骑兵
	 */
	public class UIBuilder 
	{
		public static const controlTabel:Object = {
			//controls
			"FeathersControl":FeathersControl,
			"Alert":Alert,
			"AutoComplete":AutoComplete,
			"BasicButton":BasicButton,
			"Button":Button,
			"ButtonGroup":ButtonGroup,
			"ColorPickerPanel":ColorPickerPanel,
			"Callout":Callout,
			"Check":Check,
			"DateTimeSpinner":DateTimeSpinner,
			"GroupedList":GroupedList,
			"Header":Header,
			"ImageLoader":ImageLoader,
			"Label":Label,
			"List":List,
			"MessagePrompt":MessagePrompt,
			
			"NumericStepper":NumericStepper,
			"PageIndicator":PageIndicator,
			"PickerList":PickerList,
			"ProgressBar":ProgressBar,
			"Radio":Radio,
			"ScrollBar":ScrollBar,
			"ScrollText":ScrollText,
			"Slider":Slider,
			"SpinnerList":SpinnerList,
			"TextArea":TextArea,
			"TextCallout":TextCallout,
			"TextInput":TextInput,
			"ToggleButton":ToggleButton,
			"ToggleSwitch":ToggleSwitch,	
			
			"TextFieldTextRenderer":TextFieldTextRenderer,
			"TextFieldTextEditorViewPort":TextFieldTextEditorViewPort,
			"TextFieldTextEditor":TextFieldTextEditor,
			"TextBlockTextRenderer":TextBlockTextRenderer,
			"TextBlockTextEditor":TextBlockTextEditor,
			"StageTextTextEditorViewPort":StageTextTextEditorViewPort,
			"StageTextTextEditor":StageTextTextEditor,
			"BitmapFontTextRenderer":BitmapFontTextRenderer,
			"BitmapFontTextEditor":BitmapFontTextEditor,	
			"BaseTextRenderer":BaseTextRenderer,
			
			
			"BaseDefaultItemRenderer":BaseDefaultItemRenderer,			
			"DefaultGroupedListHeaderOrFooterRenderer":DefaultGroupedListHeaderOrFooterRenderer,			
			"DefaultGroupedListItemRenderer":DefaultGroupedListItemRenderer,			
			"DefaultListItemRenderer":DefaultListItemRenderer,			
			"LayoutGroupGroupedListHeaderOrFooterRenderer":LayoutGroupGroupedListHeaderOrFooterRenderer,			
			"LayoutGroupGroupedListItemRenderer":LayoutGroupGroupedListItemRenderer,			
			"LayoutGroupListItemRenderer":LayoutGroupListItemRenderer,
			
			//layout
			"Drawers":Drawers,
			"LayoutGroup":LayoutGroup,
			"Panel":Panel,
			"PanelScreen":PanelScreen,
			"Screen":Screen,
			"ScreenNavigator":ScreenNavigator,
			"ScrollContainer":ScrollContainer,
			"Scroller":Scroller,
			"ScrollScreen":ScrollScreen,
			"SimpleScrollBar":SimpleScrollBar,
			"StackScreenNavigator":StackScreenNavigator,
			"TabBar":TabBar,
			"TabNavigator":TabNavigator,
			"TabNavigatorItem":TabNavigatorItem,
			"ToggleGroup":ToggleGroup,
			
			//display
			"Canvas":Canvas,
			"Image":Image,
			"ImageSkin":ImageSkin, 
			"MovieClip":MovieClip,
			"Quad":Quad,
			"Sprite3D":Sprite3D,
			
			//media
			"WebView":WebView,
			"WebViewCallJS":WebViewCallJS,
			"VideoPlayer":VideoPlayer,
			"VideoPlayer":SoundPlayer
		}
		public static const propertyObjectTable:Object = {
			
		    "PropertyProxy":PropertyProxy,
		    "ToggleGroup":ToggleGroup,
		    "Binding":Binding,
		    "BitmapData":BitmapData,
		    "Texture":Texture,
			"TextFormat":starling.text.TextFormat,
			"FlashTextFormat":flash.text.TextFormat,
			"FontStylesSet":FontStylesSet,
			"ElementFormat":ElementFormat,
			"FontDescription":FontDescription,
			"Rectangle":Rectangle,
			"BitmapFontTextFormat":BitmapFontTextFormat,			
			"BottomDrawerPopUpContentManager":BottomDrawerPopUpContentManager,
			"CalloutPopUpContentManager":CalloutPopUpContentManager,
			"DropDownPopUpContentManager":DropDownPopUpContentManager,
			"VerticalCenteredPopUpContentManager":VerticalCenteredPopUpContentManager,
			"AnchorLayout":AnchorLayout,
			"FlowLayout":FlowLayout,
			"HorizontalLayout":HorizontalLayout,
			"HorizontalSpinnerLayout":HorizontalSpinnerLayout,
			"TiledColumnsLayout":TiledColumnsLayout,
			"TiledRowsLayout":TiledRowsLayout,
			"VerticalLayout":VerticalLayout,
			"VerticalSpinnerLayout":VerticalSpinnerLayout,
			"WaterfallLayout":WaterfallLayout,
			
			"AnchorLayoutData":AnchorLayoutData,
			"HorizontalLayoutData":HorizontalLayoutData,
			"VerticalLayoutData":VerticalLayoutData,
			
			"ListCollection":ListCollection,
			"HierarchicalCollection":HierarchicalCollection,
			"LocalAutoCompleteSource":LocalAutoCompleteSource
		}
		public var addFactory:Function = null;
		protected var _assetManager:AssetManager
		private var targets:Dictionary;
		public var binds:Array = [];		
		public static const sizes:Array = ["bottom", "horizontalCenter", "left", "right", "top", "verticalCenter", "firstHorizontalGap", "gap", "horizontalGap", "lastHorizontalGap", "padding", "paddingBottom", "paddingLeft",
		                             "paddingRight", "paddingTop", "verticalGap", "firstGap", "lastGap", "typicalItemWidth", "typicalItemHeight", "x", "y", "width", "height", "size", "iconOffsetX", "iconOffsetY", "textureScale", "scaleX", "scaleY", "labelOffsetX",
									 "labelOffsetY","bottomArrowGap","leftArrowGap","rightArrowGap","topArrowGap","titleGap","textInputGap","buttonGap","minHeight","minWidth","fontSize"]
		public function UIBuilder() 
		{
			targets = new Dictionary();			
		}
		public function createUI(data:XML,ui:DisplayObject=null,parent:DisplayObjectContainer=null,addFactory:Function=null,dic:Dictionary=null):DisplayObject
		{
			dic = dic || targets;
			ui = ui || getUIinstance(data)
			if (ui == null) return null;
			if (parent) parent.addChild(ui);
			var ID:String = data.@id.toString();
			if (ID != "")
			{
				ui.name = ID;
				dic[ID] = ui;
			}
			if (addFactory != null)
			{
				addFactory(ui,ID)
			}
			var styleName:String = data.@styleName;
			if (styleName != "")
			{
				ui["styleName"] = styleName;	
				FeathersControl(ui).validate();
			}
/*			if (ui is IFeathersControl)
			{
				IFeathersControl(ui).validate();
			}*/
			for each (var attrs:XML in data.attributes()) 
			{
				var prop:String = attrs.name().toString();
				if (prop == "styleName"||prop == "scale9Grid" || prop == "tileGrid")
				{
					continue;
				}
				var value:String = attrs.toString();
				if (ui.hasOwnProperty(prop))
				{
					
					if (value.indexOf("class://") != -1)
					{
						value = value.replace("class://", "");
						ui[prop] = controlTabel[value];
						
					}else if (value.indexOf("@://")!= -1)
					{
						value = value.replace("@://", "");
						var tempValue:Object=Binding.getTargetPropValue(dic,value)
						if (tempValue) ui[prop] = tempValue;
						
					}else if (value.indexOf("ui://")!=-1)
					{
						value = value.replace("ui://", "");
						ui[prop] = dic[value];
						
					}else if (value.indexOf("bytes://")!=-1)
					{
						value = value.replace("bytes://", "");	
						var bytes:ByteArray = assetManager.getByteArray(value);
						if (bytes == null)bytes=openInstance().assetManager.getByteArray(value);
						ui[prop] = bytes;
						
					}else if (value.indexOf("globalTexture://")!=-1)
					{
						value = value.replace("globalTexture://", "");
						ui[prop] = openInstance().assetManager.getTexture(value);
							
					}else if (value.indexOf("texture://") !=-1)
					{
						value = value.replace("texture://", "");	
						var texture:Texture = assetManager.getTexture(value);
						if (texture == null)texture=openInstance().assetManager.getTexture(value);
						ui[prop] = texture;
							
					}else{	
						
						ui[prop] = (value== "true" ? true : (value == "false" ? false:value));
					}
				}
			}
			var childrenXML:XMLList=data.children();
			var length:int = childrenXML.length();
			var functionDis:Object = new Object();
			for (var i:int = 0; i <length;i++) 
			{
				var node:XML = childrenXML[i];
				var nodeName:String = node.name();
				var type:String = node.@type;
				var isChild:String = node.@isChild;
                if (controlTabel.hasOwnProperty(nodeName)) 
				{	
					//使用isChild属性来判断是否加入父级显示列表 false 不显示|true 显示
					if (isChild!= "false")
					{
						DisplayObjectContainer(ui).addChild(createUI(node, null, parent, addFactory, dic));
						
					}else
					{
						createUI(node, null, parent, addFactory, dic);
					}					
					
				}else if (ui.hasOwnProperty(nodeName))
				{
					if(type == "Function")
					{
						ui[nodeName]=getFunction(node);
						
					}if(ui[nodeName] is Function)
					{
						ui[nodeName]();	
						
					}else
					{
						if (nodeName == "leftItems" || nodeName == "centerItems" || nodeName == "rightItems")
						{
							ui[nodeName] = getDisplayObjects(node);
							
						}else
						{
						     ui[nodeName] = getPropertyObject(node, targets)
						}
					}					
				}
			}
			return ui;
		}
		protected function getDisplayObjects(node:XML,dic:Dictionary=null):Vector.<DisplayObject>
		{
			var xmllist:XMLList =node.children();
			var length:int = xmllist.length();
			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>
			var UIXML:XML = null;
			for (var i:int = 0; i <length; i++) 
			{
				UIXML = xmllist[i];
				var screen:DisplayObject = this.createUI(UIXML,null,null,null,dic);
				items.push(screen)
			}
			return items;			
		}
		public var rootURL:String = "";
		protected function getFunction(node:XML):Function
		{
			var source:String =node.@source;
			if (source != "")
			{
				var data:XML = assetManager.getXml(source);
				node = data;
			}else
			{
				node = XML(node.children());
			}
			var fun:Function = function():Object
			{
				var tempUIBuilder:UIBuilder = UIBuilder.getInstance();
				tempUIBuilder.assetManager = assetManager;
				return tempUIBuilder.createUI(node);
			}
			return fun;
		}
		protected function setUIProperty(data:XML, ui:Object,dic:Dictionary=null):void
		{
			var styleName:String = data.@styleName;
			if (styleName != "")
			{
				ui["styleName"] = styleName;
				IFeathersControl(ui).validate()
			}
/*			if (ui is IFeathersControl)
			{
				IFeathersControl(ui).validate()
			}*/
			for each (var attrs:XML in data.attributes()) 
			{
				var prop:String = attrs.name().toString();
				if (prop == "styleName"||prop == "scale9Grid" || prop == "tileGrid")
				{
					continue;
				}
				var value:String = attrs.toString();
				if (ui is PropertyProxy)
				{
					ui[prop] = (value== "true" ? true : (value == "false" ? false:value));	
					
				}else
				{
					if (ui.hasOwnProperty(prop)) {	
						
						if (value.indexOf("class://") != -1)
						{
							value = value.replace("class://", "");
							ui[prop] = controlTabel[value];
							
						}else if (value.indexOf("@://") != -1)
						{
							value = value.replace("@://", "");
							
						}else if (value.indexOf("ui://")!=-1)
						{
							value = value.replace("ui://", "");
							ui[prop] = dic[value];
							
						}else if (value.indexOf("globalTexture://")!=-1)
						{
							value = value.replace("globalTexture://", "");
							ui[prop] = openInstance().assetManager.getTexture(value);
								
						}else if (value.indexOf("texture://") !=-1)
						{
							value = value.replace("texture://", "");
							var texture:Texture = assetManager.getTexture(value);
							if (texture == null)texture=openInstance().assetManager.getTexture(value);
							ui[prop] = texture
								
						}else{
							
							ui[prop] = (value== "true" ? true : (value == "false" ? false:value));	
						}					
					}
				}
			}
			var childrenXML:XMLList = data.children();
			var length:int = childrenXML.length();
			for (var i:int = 0; i <length;i++) 
			{
				var node:XML = childrenXML[i];
				var nodeName:String = node.name();
				var type:String = node.@type;
				if (controlTabel.hasOwnProperty(nodeName)) 
				{	
					DisplayObjectContainer(ui).addChild(createUI(node,null,null,null,dic));
					
				}else if (node.toString()!="")
				{
					if (type == "Function")
					{
						ui[nodeName]=getFunction(node);
						
					}else if (type=="DataFunction")
					{
						
					}else
					{
						if (nodeName == "leftItems" || nodeName == "centerItems" || nodeName=="rightItems")
						{
							ui[nodeName]=getDisplayObjects(node,dic);
							
						}else
						{
							ui[nodeName]=getPropertyObject(node,dic)
						}
						
					}
				}
			}
		}
		public function getPropertyObject(node:XML,dic:Dictionary=null):Object
		{
			var objectXML:XML = XML(node.children());
			var child:Object = getUIinstance(objectXML, dic)
			var ID:String = objectXML.@id.toString();
			if (child!=null)
			{
				if (ID != "")
				{
					if(dic!=null)dic[ID] = child;
				}
				setUIProperty(objectXML, child,dic);
				return child;
			}
			child = getPropinstance(objectXML,dic)
			if (child != null)
			{
				if (ID != "")
				{
					if(dic!=null)dic[ID] = child;
				}
				if (child is ListCollection) {
					
					new ListCollectionUtils(objectXML,ListCollection(child),_assetManager)
					
				}else if (child is HierarchicalCollection) {
					
					new HierarchicalCollectionUtils(objectXML, HierarchicalCollection(child),_assetManager)
					
				}else if (child is Binding) {	
					
					Binding.dataParse(objectXML, Binding(child))
					
				}else {
					
				   setUIProperty(objectXML,child,dic);
				}
				return child;
			}
			return null;
		}
		private function getPropinstance(data:XML,dic:Dictionary=null):Object
		{
			var className:String = data.name();
			var name:String = data.@name;
			var UIClass:Class = propertyObjectTable[className]
			if (className == "BitmapFontTextFormat")
			{
				//var bitmapFont:BitmapFont = _osassetManager.getBitmapFont(name);
				return new BitmapFontTextFormat(TextField.getBitmapFont(name))
			}
			if (className == "Binding")
			{
				return new Binding(dic);
			}
			if (className == "BitmapData")
			{
				var bitmapData:BitmapData = _assetManager.getBitmapData(name);
				return bitmapData;
			}			
			if (className == "Rectangle")
			{
				var x:Number = data.@x;
				var y:Number = data.@y;
				var width:Number = data.@width;
				var height:Number = data.@height;
				var rectangle:Rectangle = new Rectangle(x,y,width,height);
				return rectangle
			}
			return UIClass ? new UIClass():null;
		}
		private function getUIinstance(data:XML,dic:Dictionary=null):DisplayObject
		{
			var className:String = data.name();
			var UIClass:Class = controlTabel[className];
			var name:String = data.@name;
			
			var w:Number = Number(data.@width) || 10;
			var h:Number = Number(data.@height) || 10;
			var color:uint = uint(data.@color);
			var type:String = data.@type;
			var textures:Texture;
			var isGlobal:Boolean = false;
			if (name.indexOf("global://") !=-1)
			{
				isGlobal = true;
				name= name.replace("global://", "");
			}
			if (className == "ImageSkin")
			{
				if (isGlobal) 
				    textures = openInstance().assetManager.getTexture(name);
				else
					textures = _assetManager.getTexture(name) || openInstance().assetManager.getTexture(name);
				return new ImageSkin(textures);
				
			}else if (className=="Image")
			{
				if (isGlobal)
					textures = openInstance().assetManager.getTexture(name);
			    else
					textures = _assetManager.getTexture(name) || openInstance().assetManager.getTexture(name);
					
				var scale9Grid:String = data.@scale9Grid;				
				var tileGrid:String = data.@tileGrid;				
				var image:Image = new Image(textures);				
				if (scale9Grid&&scale9Grid != "")
				{
					var scale9Grids:Array = scale9Grid.split(",");
					image.scale9Grid = new Rectangle(scale9Grids[0]/assetManager.scaleFactor, scale9Grids[1] / assetManager.scaleFactor, scale9Grids[2] / assetManager.scaleFactor, scale9Grids[3] / assetManager.scaleFactor);
				}
				if (tileGrid&&tileGrid!="")
				{
					var tileGrids:Array = tileGrid.split(",");
					image.tileGrid = new Rectangle(tileGrids[0]/assetManager.scaleFactor, tileGrids[1] / assetManager.scaleFactor, tileGrids[2] / assetManager.scaleFactor, tileGrids[3] / assetManager.scaleFactor);
				}				
				return image
				
			}else if (className == "Quad")
			{
				return new Quad(w, h, color);
				
			}else if (className == "Canvas")
			{
				var canvas:Canvas = new Canvas()
				canvas.beginFill(color)
				if (type=="Circle")
				{
				   var radius:Number = data.@radius;
				   canvas.drawCircle(0, 0, radius);
				   
				}else if (type == "Ellipse")
				{
				   canvas.drawEllipse(0, 0, w, h);
				   
				}else if (type == "Rectangle")
				{
					canvas.drawRectangle(0, 0, w, h);
					
				}else if (type == "Polygon")
				{
					var datas:String = data.@datas;
					var vertices:Array = datas.split(",");
					trace("vertices::"+vertices)
				    var polygon:Polygon = new Polygon(vertices);	
					canvas.drawPolygon(polygon);
				}
				canvas.endFill()
				return canvas;
				
			}else if (className == "ScreenNavigator")
			{
				var screenNavigator:ScreenNavigator = new ScreenNavigator();
				var defaultID:String = data.@screenID
				var xmllist:XMLList = data.child("ScreenNavigatorItem");
				addScreen(screenNavigator, xmllist, defaultID)
				return screenNavigator		
				
			}else if (className == "StackScreenNavigator")
			{
				var stackScreenNavigator:StackScreenNavigator = new StackScreenNavigator();
				var stackdefaultID:String = data.@screenID
				var stackXMLlist:XMLList = data.child("StackScreenNavigatorItem");
				addStackScreen(stackScreenNavigator, stackXMLlist, stackdefaultID)
				return stackScreenNavigator		
			}
			return UIClass ? new UIClass():null;
		}
		protected function addScreen(screenNavigator:ScreenNavigator,xmllist:XMLList,defaultID:String):void
		{
			if (xmllist.toXMLString() == "") return;
			var length:int = xmllist.length();
			var screenID:String = ""
			var source:String = "";
			var UIXML:XML = null;
			for (var i:int = 0; i <length; i++) 
			{
				screenID = "" + xmllist[i].@id;
				source = xmllist[i].@source;
				if (source && source != "")
				{
					var assetName:String = source.replace("asset://", "");
					UIXML = assetManager.getXml(assetName);
					
				}else
				{
				    UIXML = XML(xmllist[i].children());
				}
				var screen:DisplayObject = this.createUI(UIXML);
				screenNavigator.addScreen(screenID,new ScreenNavigatorItem(screen))
			}
			if (defaultID != "") 
			{
				screenNavigator.showScreen(defaultID);
			}
		}	
		protected function addStackScreen(screenNavigator:StackScreenNavigator,xmllist:XMLList,defaultID:String):void
		{
			if (xmllist.toXMLString() == "") return;
			var length:int = xmllist.length();
			var screenID:String = ""
			var source:String = "";
			var UIXML:XML = null;
			for (var i:int = 0; i <length; i++) 
			{
				screenID = "" + xmllist[i].@id;
				source = xmllist[i].@source;
				if (source && source != "")
				{
					var assetName:String = source.replace("asset://", "");
					UIXML = assetManager.getXml(assetName);
					
				}else
				{
				    UIXML = XML(xmllist[i].children());
				}
				var screen:DisplayObject = this.createUI(UIXML);
				screenNavigator.addScreen(screenID, new StackScreenNavigatorItem(screen))
			}
			if (defaultID != "") 
			{
				screenNavigator.rootScreenID = defaultID;
			}
		}
		/**
		 * 通过id获取组件
		 * @param	id
		 * @return
		 */
		public function getChildByID(id:String):DisplayObject
		{
			return targets[id] as DisplayObject
		}
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			assetManager = null;
		}
		/**
		 * 获取实例
		 * @return
		 */
		public static function getInstance():UIBuilder {
			
			var instance:UIBuilder = new UIBuilder();
			return instance;
		}
		protected static var oinstance:UIBuilder = null
		/**
		 * 全局共公实例
		 * @return
		 */
		public static function openInstance():UIBuilder
		{
			if (oinstance) return oinstance;
			oinstance = new UIBuilder();
			return oinstance;
		}	
		/**
		 * 资源管理器
		 */
		public function get assetManager():AssetManager 
		{
			return _assetManager;
		}		
		public function set assetManager(value:AssetManager):void 
		{
			_assetManager = value;
		}
	}

}