package com.github.haxePixiGAF.data.textures;

import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.BaseTexture;
import pixi.core.textures.Texture;

/**
 * ...
 * @author Mathieu Anthoine
 */
class TextureWrapper extends Texture
{
	
	public function new(?pBaseTexture:BaseTexture, ?pFrame:Rectangle, ?pCrop:Rectangle, ?pTrim:Rectangle, ?pRotate:Bool) 
	{
		super(pBaseTexture,pFrame,pCrop,pTrim,pRotate);		
	}
	
	public var base (get_base, null):BaseTexture;
	private function get_base ():BaseTexture {
		return null;
		//return baseTexture;
	}
	
	/// The Context3DTextureFormat of the underlying texture data.
	public var format(get_format, null) :  String;
	private function get_format(): String
	{
		//TODO
		return "bgra";
	}
	
	public var frameHeight(get_frameHeight, null):Float;
	private function get_frameHeight():Float 
	{
		return frame!=null ? frame.height : height;
	}
	
	public var frameWidth(get_frameWidth, null):Float;
	private function get_frameWidth():Float 
	{
		return frame!=null ? frame.width : width;
	}
	
	public var mipMapping(get_mipMapping, null): Bool;
	private function get_mipMapping():Bool 
	{
		return false;
	}
	
	public var nativeHeight(get_nativeHeight, null):Float;
	private function get_nativeHeight():Float 
	{
		return 0;
	}
	
	public var nativeWidth(get_nativeWidth, null):Float;
	private function get_nativeWidth():Float 
	{
		return 0;
	}
	
	public var premultipliedAlpha(get_premultipliedAlpha, null):Bool;
	private function get_premultipliedAlpha():Bool 
	{
		return false;
	}
	
	public var root(get_root, null): TextureWrapper;
	private function get_root():TextureWrapper 
	{
		return null;
	}
	
	public var scale(get_scale, null):Float;
	private function get_scale():Float 
	{
		return 1;
	}
	
	public var transformationMatrix(get_transformationMatrix, null) :Matrix;
	private function get_transformationMatrix():Matrix 
	{
		return null;
	}
	
	public var transformationMatrixToRoot(get_transformationMatrixToRoot, null) :Matrix;
	private function get_transformationMatrixToRoot():Matrix 
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  STATIC
	//
	//--------------------------------------------------------------------------
	
	//public static function empty (width:Float=0, height:Float=0, premultipliedAlpha:Bool = true, mipMapping:Bool = false, optimizeForRenderToTexture:Bool = false, scale:Float =-1, format:String = "bgra", forcePotTexture:Bool = false) : Texture {
		//
		//trace ("EMPTY");
		//return Texture.EMPTY;
	//}
	
	/** Creates a texture that contains a region (in pixels) of another texture. The new
	 *  texture will reference the base texture; no data is duplicated.
	 *
	 *  @param texture  The texture you want to create a SubTexture from.
	 *  @param region   The region of the parent texture that the SubTexture will show
	 *                  (in points).
	 *  @param frame    If the texture was trimmed, the frame rectangle can be used to restore
	 *                  the trimmed area.
	 *  @param rotated  If true, the SubTexture will show the parent region rotated by
	 *                  90 degrees (CCW).
	 *  @param scaleModifier  The scale factor of the new texture will be calculated by
	 *                  multiplying the parent texture's scale factor with this value.
	 */
	public static function fromTexture(texture:TextureWrapper, region:Rectangle=null,
									   frame:Rectangle=null, rotated:Bool=false,
									   scaleModifier:Float=1.0):TextureWrapper
	{
		return new SubTexture(texture, region, false, frame, rotated, scaleModifier);
	}
	
	public static var maxSize(get_maxSize, null) : Int;
	private static function get_maxSize():Int 
	{
		//var target:Starling = Starling.current;
		//var profile:String = target ? target.profile : "baseline";

		//if (profile == "baseline" || profile == "baselineConstrained")
			//return 2048;
		//else
			//return 4096;
		
		return 4096;
	}
	
}