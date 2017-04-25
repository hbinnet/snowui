package snowui.engine.data 
{
	/**
	 * ...
	 * @author 游骑兵 
	 */
	public class BindData 
	{
		public var target:*;
		public var prop:String;
		public var bindProp:String;
		public function BindData(target:*,prop:String,bindProp:String) 
		{
			this.target=target
			this.prop=prop
			this.bindProp=bindProp
		}
		
	}

}