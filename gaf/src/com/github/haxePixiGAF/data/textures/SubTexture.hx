package com.github.haxePixiGAF.data.textures;

import com.github.haxePixiGAF.utils.MatrixUtility;
import js.Lib;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.BaseTexture;
import pixi.core.textures.Texture;

using com.github.haxePixiGAF.utils.MatrixUtility;

/**
 * TODO: check
 * AS3 Conversion of Starling SubTexture class
 * @author Mathieu Anthoine
 */

/** A SubTexture represents a section of another texture. This is achieved solely by
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *<p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */
class SubTexture extends TextureWrapper
{
	private var _parent:TextureWrapper;
	private var _ownsParent:Bool=false;
	private var _region:Rectangle;
	private var _rotated:Bool=false;
	private var _scale:Float;	
	private var _transformationMatrix:Matrix;
	private var _transformationMatrixToRoot:Matrix;


	/** Creates a new SubTexture containing the specified region of a parent texture.
	 *
	 *  @param parent	 The texture you want to create a SubTexture from.
	 *  @param region	 The region of the parent texture that the SubTexture will show
	 *					(in points). If<code>null</code>, the complete area of the parent.
	 *  @param ownsParent If<code>true</code>, the parent texture will be disposed
	 *					automatically when the SubTexture is disposed.
	 *  @param frame	  If the texture was trimmed, the frame rectangle can be used to restore
	 *					the trimmed area.
	 *  @param rotated	If true, the SubTexture will show the parent region rotated by
	 *					90 degrees(CCW).
	 *  @param scaleModifier  The scale factor of the SubTexture will be calculated by
	 *					multiplying the parent texture's scale factor with this value.
	 */
	public function new(pParent:TextureWrapper, pRegion:Rectangle=null, pOwnsParent:Bool=false, pFrame:Rectangle=null, pRotated:Bool=false, pScaleModifier:Float=1)
	{	
		
		super(pParent.baseTexture, pRegion,null,null,pRotated);
		setTo(pParent, pRegion, pOwnsParent, pFrame, pRotated, pScaleModifier);
		
	}
	
	override private function get_base ():BaseTexture {
		return _parent.baseTexture;
	}
	
	override private function get_frameHeight():Float 
	{
		return frame.height;
	}
	
	override private function get_frameWidth():Float 
	{
		return frame.width;
	}
	
	override private function get_mipMapping():Bool 
	{
		return _parent.mipMapping;
	}
	
	override private function get_nativeHeight():Float 
	{
		return height * _scale;
	}
	
	override private function get_nativeWidth():Float 
	{
		return width * _scale;
	}
	
	override private function get_format():String 
	{
		return _parent.format;
	}
	
	override private function get_premultipliedAlpha():Bool 
	{
		return _parent.premultipliedAlpha;
	}
	
	override private function get_root():TextureWrapper 
	{
		return _parent.root;
	}
	
	override private function get_scale():Float 
	{
		return _scale;
	}
	
	override private function get_transformationMatrix():Matrix 
	{
		return _transformationMatrix;
	}
	
	override private function get_transformationMatrixToRoot():Matrix 
	{
		return _transformationMatrixToRoot;
	}
	
	/** @private
	 *
	 *<p>Textures are supposed to be immutable, and Starling uses this assumption for
	 *  optimizations and simplifications all over the place. However, in some situations where
	 *  the texture is not accessible to the outside, this can be overruled in order to avoid
	 *  allocations.</p>
	 */
	public function setTo(pParent:TextureWrapper, pRegion:Rectangle=null, pOwnsParent:Bool=false, pFrame:Rectangle=null, pRotated:Bool=false, pScaleModifier:Float=1):Void
	{
		if(_region==null) _region=new Rectangle(0,0,0,0);
		if (pRegion!=null) {
			_region.x = pRegion.x;
			_region.y = pRegion.y;
			_region.width = pRegion.width;
			_region.height = pRegion.height;
		} else {
			_region.x = 0;
			_region.y = 0;
			_region.width = pParent.width;
			_region.height = pParent.height;
		}

		//if(pFrame!=null)
		//{
			//if (frame!=null) {
				//frame.x=pFrame.x;
				//frame.y=pFrame.y;
				//frame.width=pFrame.width;
				//frame.height=pFrame.height;
			//}
			//else frame=pFrame.clone();
		//}
		//else frame=null;

		_parent=pParent;
		_ownsParent=pOwnsParent;
		_rotated=pRotated;
		
		if (frame!=null) {
			frame.width=(pRotated ? _region.height:_region.width)/ pScaleModifier;
			frame.height=(pRotated ? _region.width:_region.height)/ pScaleModifier;
		}
		
		_scale = (_parent!=null ? _parent.scale : 1) * pScaleModifier;

		//if(frame!=null &&(frame.x>0 || frame.y>0 ||
			//frame.x+frame.width<width || frame.y+frame.height<height))
		//{
			//trace("[Starling] Warning:frames inside the texture's region are unsupported.");
		//}

		updateMatrices();
	}

	private function updateMatrices():Void
	{
		if (_transformationMatrix != null) _transformationMatrix.identity();
		else _transformationMatrix=new Matrix();

		if(_transformationMatrixToRoot!=null) _transformationMatrixToRoot.identity();
		else _transformationMatrixToRoot=new Matrix();

		if(_rotated)
		{
			_transformationMatrix.translate(0, -1);
			_transformationMatrix.rotate(Math.PI / 2.0);
		}

		_transformationMatrix.scale(_region.width  / _parent.width, _region.height / _parent.height);
		_transformationMatrix.translate(_region.x  / _parent.width, _region.y  / _parent.height);

		var texture:SubTexture=this;
		while(texture!=null)
		{
			_transformationMatrixToRoot.concat(texture._transformationMatrix);
			
			if (Std.is(texture.parent,SubTexture)) texture=cast(texture.parent,SubTexture);
			else texture = null;
		}
	}
	
	/** Disposes the parent texture if this texture owns it. */
	public override function destroy(?destroyBase:Bool):Void
	{
		if (_ownsParent) {
			_parent.destroy();
		}
		super.destroy(destroyBase);
	}

	/** The texture which the SubTexture is based on. */
	public var parent(get_parent, null):TextureWrapper;
 	private function get_parent():TextureWrapper { return _parent;}
	
	/** Indicates if the parent texture is disposed when this object is disposed. */
	public var ownsParent(get_ownsParent, null):Bool;
 	private function get_ownsParent():Bool { return _ownsParent;}
	
	/** If true, the SubTexture will show the parent region rotated by 90 degrees(CCW). */
	public var rotated(get_rotated, null):Bool;
 	private function get_rotated():Bool { return _rotated;}

	/** The region of the parent texture that the SubTexture is showing(in points).
	 *
	 *<p>CAUTION:not a copy, but the actual object! Do not modify!</p>*/
	public var region(get_region, null):Rectangle;
 	private function get_region():Rectangle { 
		return _region;
	}	
	
}