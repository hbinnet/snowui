/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package snowui.engine.style
{
	import feathers.skins.StyleProviderRegistry;
	import starling.events.EventDispatcher;

	/**
	 * Base class for themes that pass a <code>StyleNameFunctionStyleProvider</code>
	 * to each component class.
	 *
	 * @see feathers.skins.StyleNameFunctionStyleProvider
	 * @see ../../../help/skinning.html Skinning Feathers components
	 * @see ../../../help/custom-themes.html Creating custom Feathers themes
	 */
	public class BandDataStyleNameFunctionTheme extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function BandDataStyleNameFunctionTheme()
		{
			this.createRegistry();
		}
		/**
		 * @private
		 */
		protected var _registry:StyleProviderRegistry;

		/**
		 * Disposes the theme.
		 */
		public function dispose():void
		{
			if(this._registry)
			{
				this._registry.dispose();
				this._registry = null;
			}
		}

		/**
		 * Returns a <code>StyleNameFunctionStyleProvider</code> to be passed to
		 * the specified class.
		 */
		public function getStyleProviderForClass(type:Class):BandDataStyleNameFunctionStyleProvider
		{
			return BandDataStyleNameFunctionStyleProvider(this._registry.getStyleProvider(type));
		}

		/**
		 * @private
		 */
		protected function createRegistry():void
		{
			this._registry = new StyleProviderRegistry(true,styleProviderFactory);
		}
		protected function styleProviderFactory():BandDataStyleNameFunctionStyleProvider
		{
          return new BandDataStyleNameFunctionStyleProvider();
		}
		
	}
}
