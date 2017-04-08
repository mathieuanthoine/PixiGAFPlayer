package com.github.haxePixiGAF.data.textures;

import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.BaseTexture;
import pixi.core.textures.Texture;

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
class SubTexture extends Texture
{
	private var _parent:SubTexture;
	private var _ownsParent:Bool;
	private var _region:Rectangle;
	private var _rotated:Bool;
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
	public function new(pParent:SubTexture, pRegion:Rectangle=null, pOwnsParent:Bool=false, pFrame:Rectangle=null, pRotated:Bool=false, pScaleModifier:Float=1)
	{	
		//starling_internal::setTo(parent, region, ownsParent, frame, rotated, scaleModifier);
		super(pParent.baseTexture,pFrame,pRegion);
		setTo(pParent, pRegion, pOwnsParent, pFrame, pRotated, pScaleModifier);
		
	}

	public var base (get_base, null):BaseTexture;
	private function get_base ():BaseTexture {
		if (_parent != null) return _parent.baseTexture;
		return baseTexture;
	}
	
	/// The Context3DTextureFormat of the underlying texture data.
	public var format(get_format, null) :  String;
	private function get_format(): String
	{
		//if (_parent != null) return _parent.format;
		//TODO ?
		return "bgra";
	}
	
	public var frameHeight(get_frameHeight, null):Float;
	private function get_frameHeight():Float 
	{
		return frame.height;
	}
	
	public var frameWidth(get_frameWidth, null):Float;
	private function get_frameWidth():Float 
	{
		return frame.width;
	}
	
	public static var maxSize(get_maxSize, null) : Int;
	private static function get_maxSize():Int 
	{
		//TODO ?
		return 0;
	}
	
	public var mipMapping(get_mipMapping, null): Bool;
	private function get_mipMapping():Bool 
	{
		return null;
		//TODO: return _parent.mipMapping;
	}
	
	public var nativeHeight(get_nativeHeight, null):Float;
	private function get_nativeHeight():Float 
	{
		return height * _scale;
	}
	
	public var nativeWidth(get_nativeWidth, null):Float;
	private function get_nativeWidth():Float 
	{
		return width * _scale;
	}
	
	public var premultipliedAlpha(get_premultipliedAlpha, null):Bool;
	private function get_premultipliedAlpha():Bool 
	{
		if (_parent != null) return _parent.premultipliedAlpha;
		return false;
	}
	
	public var root(get_root, null): BaseTexture;
	private function get_root():BaseTexture 
	{
		//if (_parent != null) return _parent.baseTexture;
		return baseTexture;
	}
	
	public var scale(get_scale, null):Float;
	private function get_scale():Float 
	{
		return _scale;
	}
	
	public var transformationMatrix(get_transformationMatrix, null) :Matrix;
	private function get_transformationMatrix():Matrix 
	{
		return _transformationMatrix;
	}
	
	public var transformationMatrixToRoot(get_transformationMatrixToRoot, null) :Matrix;
	private function get_transformationMatrixToRoot():Matrix 
	{
		return _transformationMatrixToRoot;
	}
	
	public static function empty (width:Float=0, height:Float=0, premultipliedAlpha:Bool = true, mipMapping:Bool = false, optimizeForRenderToTexture:Bool = false, scale:Float =-1, format:String = "bgra", forcePotTexture:Bool = false) : Texture {
		return Texture.EMPTY;
	}
	
	/** @private
	 *
	 *<p>Textures are supposed to be immutable, and Starling uses this assumption for
	 *  optimizations and simplifications all over the place. However, in some situations where
	 *  the texture is not accessible to the outside, this can be overruled in order to avoid
	 *  allocations.</p>
	 */
	/*starling_private*/ public function setTo(pParent:SubTexture, pRegion:Rectangle=null, pOwnsParent:Bool=false, pFrame:Rectangle=null, pRotated:Bool=false, pScaleModifier:Float=1):Void
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

		if(pFrame!=null)
		{
			if (frame!=null) {
				frame.x=pFrame.x;
				frame.y=pFrame.y;
				frame.width=pFrame.width;
				frame.height=pFrame.height;
			}
			else frame=pFrame.clone();
		}
		//else frame=null;

		_parent=pParent;
		_ownsParent=pOwnsParent;
		_rotated=pRotated;
		width=(pRotated!=null ? _region.height:_region.width)/ pScaleModifier;
		height=(pRotated!=null ? _region.width:_region.height)/ pScaleModifier;
		_scale = (_parent!=null ? _parent.scale : 1) * pScaleModifier;

		if(frame!=null &&(frame.x>0 || frame.y>0 ||
			frame.x+frame.width<width || frame.y+frame.height<height))
		{
			trace("[Starling] Warning:frames inside the texture's region are unsupported.");
		}

		updateMatrices();
	}

	private function updateMatrices():Void
	{
		if (_transformationMatrix != null) _transformationMatrix.identity();
		else _transformationMatrix=new Matrix();

		if(_transformationMatrixToRoot!=null) _transformationMatrixToRoot.identity();
		else _transformationMatrixToRoot=new Matrix();

		if(_rotated!=null)
		{
			_transformationMatrix.translate(0, -1);
			_transformationMatrix.rotate(Math.PI / 2.0);
		}

		_transformationMatrix.scale(_region.width  / _parent.width, _region.height / _parent.height);
		_transformationMatrix.translate(_region.x  / _parent.width, _region.y  / _parent.height);

		var texture:SubTexture=this;
		while(texture!=null)
		{
			//TODO: déterminer quelle est la formule équivalente pour la concatenation
			// Recheck dans tout le code AS3 ou il y a concat et ce que j'ai fait.
			//_transformationMatrixToRoot.concat(texture._transformationMatrix);
			_transformationMatrixToRoot.append(texture._transformationMatrix);
			
			texture=cast(texture.parent,SubTexture);
		}
	}
	
	/** Disposes the parent texture if this texture owns it. */
	//public override function dispose():Void
	public override function destroy(?destroyBase:Bool):Void
	{
		if (_ownsParent) {
			_parent.destroy();
		}
		super.destroy(destroyBase);
	}

	/** The texture which the SubTexture is based on. */
	public var parent(get_parent, null):SubTexture;
 	private function get_parent():SubTexture { return _parent;}
	
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
 	private function get_region():Rectangle { return _region;}	
	
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
	public static function fromTexture(texture:SubTexture, region:Rectangle=null,
									   frame:Rectangle=null, rotated:Bool=false,
									   scaleModifier:Float=1.0):SubTexture
	{
		return new SubTexture(texture, region, false, frame, rotated, scaleModifier);
	}
	
}