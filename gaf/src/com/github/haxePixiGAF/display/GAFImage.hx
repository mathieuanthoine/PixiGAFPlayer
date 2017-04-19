package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.config.CFilter;
import com.github.haxePixiGAF.utils.MatrixUtils;
import pixi.core.display.DisplayObject;
import pixi.core.math.Matrix;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import haxe.extern.EitherType;


/**
 * TODO : check doublons (scale, scaleX, pivot, pivotX) et supprimer ce qui est en trop
 * @author Mathieu Anthoine
 */
/**
 * GAFImage represents static GAF display object that is part of the<code>GAFMovieClip</code>.
 */
class GAFImage extends Sprite implements IGAFImage implements IMaxSize implements IGAFDebug
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	//private static inline var V_DATA_ATTR:String="position";

	//private static var HELPER_POINT:Point=new Point();
	//private static var HELPER_POINT_3D:Vector3D=new Vector3D();
	private static var HELPER_MATRIX:Matrix=new Matrix();
	//private static var HELPER_MATRIX_3D:Matrix3D=new Matrix3D();

	private var _assetTexture:IGAFTexture;

	//private var _filterChain:GAFFilterChain;
	//private var _filterConfig:CFilter;
	//private var _filterScale:Float;

	private var _maxSize:Point;

	private var _pivotChanged:Bool=false;

	/** @private */
	//gaf_private var __debugOriginalAlpha:Float=NaN;
	public var __debugOriginalAlpha:Float=null;

	private var _orientationChanged:Bool=false;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new<code>GAFImage</code>instance.
	 * @param assetTexture<code>IGAFTexture</code>from which it will be created.
	 */
	public function new(assetTexture:IGAFTexture)
	{
		_assetTexture=assetTexture.clone();

		super(_assetTexture.texture);
		
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new instance of GAFImage.
	 */
	public function copy():GAFImage
	{
		return new GAFImage(_assetTexture);
	}

	/** @private */
	public function invalidateOrientation():Void
	{
		_orientationChanged = true;
	}

	/** @private */
	public var debugColors(null, set_debugColors):Array<Int>;
 	private function set_debugColors(value:Array<Int>):Array<Int>
	{
		return null;
		
		/*var alpha0:Float;
		var alpha1:Float;

		switch(value.length)
		{
			case 1:
				color=value[0];
				alpha=(value[0]>>>24)/ 255;
				break;
			case 2:
				setVertexColor(0, value[0]);
				setVertexColor(1, value[0]);
				setVertexColor(2, value[1]);
				setVertexColor(3, value[1]);

				alpha0=(value[0]>>>24)/ 255;
				alpha1=(value[1]>>>24)/ 255;
				setVertexAlpha(0, alpha0);
				setVertexAlpha(1, alpha0);
				setVertexAlpha(2, alpha1);
				setVertexAlpha(3, alpha1);
				break;
			case 3:
				setVertexColor(0, value[0]);
				setVertexColor(1, value[0]);
				setVertexColor(2, value[1]);
				setVertexColor(3, value[2]);

				alpha0=(value[0]>>>24)/ 255;
				setVertexAlpha(0, alpha0);
				setVertexAlpha(1, alpha0);
				setVertexAlpha(2,(value[1]>>>24)/ 255);
				setVertexAlpha(3,(value[2]>>>24)/ 255);
				break;
			case 4:
				setVertexColor(0, value[0]);
				setVertexColor(1, value[1]);
				setVertexColor(2, value[2]);
				setVertexColor(3, value[3]);

				setVertexAlpha(0,(value[0]>>>24)/ 255);
				setVertexAlpha(1,(value[1]>>>24)/ 255);
				setVertexAlpha(2,(value[2]>>>24)/ 255);
				setVertexAlpha(3,(value[3]>>>24)/ 255);
				break;
		}*/
			
	}

	/**
	 * Change the texture of the<code>GAFImage</code>to a new one.
	 * @param newTexture the new<code>IGAFTexture</code>which will be used to replace existing one.
	 */
	public function changeTexture(newTexture:IGAFTexture):Void
	{
		texture=newTexture.texture;
		//readjustSize();
		_assetTexture.copyFrom(newTexture);
	}

	/** @private */
	public function setFilterConfig(value:CFilter, scale:Float=1):Void
	{
		//trace ("setFilterConfig: TODO");
		
		/*if(!Starling.current.contextValid)
		{
			return;
		}

		if(_filterConfig !=value || _filterScale !=scale)
		{
			if(value)
			{
				_filterConfig=value;
				_filterScale=scale;

				if(_filterChain)
				{
					_filterChain.dispose();
				}
				else
				{
					_filterChain=new GAFFilterChain();
				}

				_filterChain.setFilterData(_filterConfig);

				filter=_filterChain;
			}
			else
			{
				if(filter)
				{
					filter.dispose();
					filter=null;
				}

				_filterChain=null;
				_filterConfig=null;
				_filterScale=NaN;
			}
		}*/
	}



	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	/** @private */
	//gaf_private function __debugHighlight():Void
	public function __debugHighlight():Void
	{
		//use namespace gaf_internal;

		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=1;
	}

	/** @private */
	//gaf_private function __debugLowlight():Void
	public function __debugLowlight():Void
	{
		//use namespace gaf_internal;

		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=.05;
	}

	/** @private */
	//gaf_private function __debugResetLight():Void
	public function __debugResetLight():Void
	{
		//use namespace gaf_internal;

		if(!Math.isNaN(__debugOriginalAlpha))
		{
			alpha=__debugOriginalAlpha;
			__debugOriginalAlpha=null;
		}
	}

	//[Inline]
	//private final function updateTransformMatrix():Void
	private function updateTransformMatrix():Void
	{
		if(_orientationChanged)
		{
			transformationMatrix=transformationMatrix;
			_orientationChanged=false;
		}
	}

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	/**
	 * Disposes all resources of the display object.
	 */
	override public function destroy(?options:EitherType<Bool, DestroyOptions>):Void
	{
		//if(filter!=null)
		//{
			//filter.dispose();
			//filter=null;
		//}
		_assetTexture=null;
		//_filterConfig=null;

		//super.dispose();
		super.destroy(options);
	}

	
	//TODO: getGAFGetbounds
	
	//override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
	//{
		//if(!resultRect)resultRect=new Rectangle(0,0,0,0);
//
		//if(targetSpace==this)// optimization
		//{
			//vertexData.getPoint(3,V_DATA_ATTR, HELPER_POINT);
			//resultRect.setTo(0.0, 0.0, HELPER_POINT.x, HELPER_POINT.y);
		//}
		//else if(targetSpace==parent && rotation==0.0 && isEquivalent(skewX, skewY))// optimization
		//{
			//var scaleX:Float=scaleX;
			//var scaleY:Float=scaleY;
			//vertexData.getPoint(3,V_DATA_ATTR, HELPER_POINT);
			//resultRect.setTo(x - pivotX * scaleX,	  y - pivotY * scaleY,
					//HELPER_POINT.x * scaleX, HELPER_POINT.y * scaleY);
			//if(scaleX<0){ resultRect.width  *=-1;resultRect.x -=resultRect.width;}
			//if(scaleY<0){ resultRect.height *=-1;resultRect.y -=resultRect.height;}
		//}
		//else if(is3D && stage)
		//{
			//stage.getCameraPosition(targetSpace, HELPER_POINT_3D);
			//getTransformationMatrix3D(targetSpace, HELPER_MATRIX_3D);
			//vertexData.getBoundsProjected(V_DATA_ATTR,HELPER_MATRIX_3D, HELPER_POINT_3D, 0, 4, resultRect);
		//}
		//else
		//{
			//getTransformationMatrix(targetSpace, HELPER_MATRIX);
			//vertexData.getBounds(V_DATA_ATTR,HELPER_MATRIX, 0, 4, resultRect);
		//}
//
		//return resultRect;
	//}

	private function isEquivalent(a:Float, b:Float, epsilon:Float=0.0001):Bool
	{
		return(a - epsilon<b)&&(a + epsilon>b);
	}

	/** @private */
	public var pivotX(null, set_pivotX):Float;
 	private function set_pivotX(value:Float):Float
	{
		_pivotChanged = true;
		return pivot.x = value;
	}

	/** @private */
	public var pivotY(null, set_pivotY):Float;
 	private function set_pivotY(value:Float):Float
	{
		_pivotChanged=true;
		return pivot.y=value;
	}

	/** @private */
	//override public function get x():Float
	//{
		//updateTransformMatrix();
		//return super.x;
	//}

	/** @private */
	//override public function get y():Float
	//{
		//updateTransformMatrix();
		//return super.y;
	//}

	/** @private */
	//override public var rotation(get_rotation, set_rotation):Float;
 	//private function get_rotation():Float
	//{
		//updateTransformMatrix();
		//return super.rotation;
	//}

	/** @private */
	public var scaleX(get_scaleX, null):Float;
 	private function get_scaleX():Float
	{
		updateTransformMatrix();
		return scale.x;
	}

	/** @private */
	public var scaleY(get_scaleY, null):Float;
 	private function get_scaleY():Float
	{
		updateTransformMatrix();
		return scale.y;
	}

	/** @private */
	public var skewX(get_skewX, null):Float;
 	private function get_skewX():Float
	{
		updateTransformMatrix();
		return skew.x;
	}

	/** @private */
	public var skewY(get_skewY, null):Float;
 	private function get_skewY():Float
	{
		updateTransformMatrix();
		return skew.y;
	}

	//--------------------------------------------------------------------------
	//
	//  EVENT HANDLERS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	/** @private */
	public var maxSize(get_maxSize, set_maxSize):Point;
 	private function get_maxSize():Point
	{
		return _maxSize;
	}

	/** @private */
	private function set_maxSize(value:Point):Point
	{
		return _maxSize=value;
	}


	/**
	 * Returns current<code>IGAFTexture</code>.
	 * @return current<code>IGAFTexture</code>
	 */
	public var assetTexture(get_assetTexture, null):IGAFTexture;
 	private function get_assetTexture():IGAFTexture
	{
		return _assetTexture;
	}
//
	///** @private */
	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		_assetTexture.pivotMatrix.copy(HELPER_MATRIX);

		if(_pivotChanged)
		{
			HELPER_MATRIX.tx=pivotX;
			HELPER_MATRIX.ty=pivotY;
		}
		
		return HELPER_MATRIX;
	}
	
	public var transformationMatrix(get_transformationMatrix,set_transformationMatrix):Matrix;
	private function get_transformationMatrix():Matrix {
		
		//if(_orientationChanged)
		//{
			//_orientationChanged=false;
			//
			//if(skew.x==0.0 && skew.y==0.0)
			//{
				//// optimization:no skewing / rotation simplifies the matrix math
				//
				//if(rotation==0.0)
				//{
					//worldTransform.a = scale.x;
					//worldTransform.b = 0;
					//worldTransform.c = 0;
					//worldTransform.d = scale.y;
					//worldTransform.tx = x - pivot.x * scale.x;
					//worldTransform.ty = y - pivot.y * scale.y;
					////.setTo(scale.x, 0.0, 0.0, scale.y,x - pivot.x * scale.x, y - pivot.y * scale.y);
				//}
				//else
				//{
					//var cos:Float=Math.cos(rotation);
					//var sin:Float=Math.sin(rotation);
					//var a:Float=scale.x *  cos;
					//var b:Float=scale.x *  sin;
					//var c:Float=scale.y * -sin;
					//var d:Float=scale.y *  cos;
					//var tx:Float=x - pivot.x * a - pivot.y * c;
					//var ty:Float=y - pivot.x * b - pivot.y * d;
					//
					////worldTransform.setTo(a, b, c, d, tx, ty);
					//
					//worldTransform.a = a;
					//worldTransform.b = b;
					//worldTransform.c = c;
					//worldTransform.d = d;
					//worldTransform.tx = tx;
					//worldTransform.ty = ty;
//
				//}
			//}
			//else
			//{
				//worldTransform.identity();
				//worldTransform.scale(scale.x, scale.y);
				////TODO : MatrixUtil.skew(worldTransform, skew.x, skew.y);
				//worldTransform.rotate(rotation);
				//worldTransform.translate(x, y);
				//
				//if(pivot.x !=0.0 || pivot.y !=0.0)
				//{
					//// prepend pivot transformation
					//worldTransform.tx=x - worldTransform.a * pivot.x
												  //- worldTransform.c * pivot.y;
					//worldTransform.ty=y - worldTransform.b * pivot.x
												  //- worldTransform.d * pivot.y;
				//}
			//}
		//}
		
		return localTransform;
		
	}
	private function set_transformationMatrix(matrix:Matrix):Matrix {
		return localTransform=matrix;
	}
	
}