package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.textures.SubTexture;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.Texture;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
class GAFScale9Texture implements IGAFTexture
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

	/**
	 * @private
	 */
	private static inline var DIMENSIONS_ERROR:String="The width and height of the scale9Grid must be greater than zero.";
	/**
	 * @private
	 */
	private static var HELPER_RECTANGLE:Rectangle = new Rectangle(0, 0, 0, 0);

	private var _id:String;
	private var _texture:SubTexture;
	private var _pivotMatrix:Matrix;
	private var _scale9Grid:Rectangle;

	//private var _topLeft:Texture;
	//private var _topCenter:Texture;
	//private var _topRight:Texture;
	//private var _middleLeft:Texture;
	//private var _middleCenter:Texture;
	//private var _middleRight:Texture;
	//private var _bottomLeft:Texture;
	//private var _bottomCenter:Texture;
	//private var _bottomRight:Texture;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(id:String, texture:SubTexture, pivotMatrix:Matrix, scale9Grid:Rectangle)
	{
		_id=id;
		_pivotMatrix=pivotMatrix;

		//if(scale9Grid.width<=0 || scale9Grid.height<=0)
		//{
			//throw new ArgumentError(DIMENSIONS_ERROR);
		//}
		//_texture=texture;
		_scale9Grid=scale9Grid;
		initialize();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function copyFrom(newTexture:IGAFTexture):Void
	{
		if(Std.is(newTexture, GAFScale9Texture))
		{
			_id=newTexture.id;
			_texture=newTexture.texture;
			//_pivotMatrix.copyFrom(newTexture.pivotMatrix);
			newTexture.pivotMatrix.copy(_pivotMatrix);
			//_scale9Grid.copyFrom(cast(newTexture,GAFScale9Texture).scale9Grid);
			//_topLeft=(newTexture as GAFScale9Texture).topLeft;
			//_topCenter=(newTexture as GAFScale9Texture).topCenter;
			//_topRight=(newTexture as GAFScale9Texture).topRight;
			//_middleLeft=(newTexture as GAFScale9Texture).middleLeft;
			//_middleCenter=(newTexture as GAFScale9Texture).middleCenter;
			//_middleRight=(newTexture as GAFScale9Texture).middleRight;
			//_bottomLeft=(newTexture as GAFScale9Texture).bottomLeft;
			//_bottomCenter=(newTexture as GAFScale9Texture).bottomCenter;
			//_bottomRight=(newTexture as GAFScale9Texture).bottomRight;
		}
		else
		{
			throw "Incompatiable types GAFScale9Texture and "+Type.getClassName(Type.getClass(newTexture));
		}
	}
	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function initialize():Void
	{
		//var textureFrame:Rectangle=_texture.frame;
		//if(textureFrame==null)
		//{
			//textureFrame=HELPER_RECTANGLE;
			//textureFrame.setTo(0, 0, _texture.width, _texture.height);
		//}
		//var leftWidth:Float=_scale9Grid.left;
		//var centerWidth:Float=_scale9Grid.width;
		//var rightWidth:Float=textureFrame.width - _scale9Grid.width - _scale9Grid.x;
		//var topHeight:Float=_scale9Grid.y;
		//var middleHeight:Float=_scale9Grid.height;
		//var bottomHeight:Float=textureFrame.height - _scale9Grid.height - _scale9Grid.y;
//
		//var regionLeftWidth:Float=leftWidth + textureFrame.x;
		//var regionTopHeight:Float=topHeight + textureFrame.y;
		//var regionRightWidth:Float=rightWidth -(textureFrame.width - _texture.width)- textureFrame.x;
		//var regionBottomHeight:Float=bottomHeight -(textureFrame.height - _texture.height)- textureFrame.y;
//
		//var hasLeftFrame:Bool=regionLeftWidth !=leftWidth;
		//var hasTopFrame:Bool=regionTopHeight !=topHeight;
		//var hasRightFrame:Bool=regionRightWidth !=rightWidth;
		//var hasBottomFrame:Bool=regionBottomHeight !=bottomHeight;
//
		//var topLeftRegion:Rectangle=new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
		//var topLeftFrame:Rectangle=(hasLeftFrame || hasTopFrame)? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight):null;
		//_topLeft=Texture.fromTexture(_texture, topLeftRegion, topLeftFrame);
//
		//var topCenterRegion:Rectangle=new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
		//var topCenterFrame:Rectangle=hasTopFrame ? new Rectangle(0, textureFrame.y, centerWidth, topHeight):null;
		//_topCenter=Texture.fromTexture(_texture, topCenterRegion, topCenterFrame);
//
		//var topRightRegion:Rectangle=new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
		//var topRightFrame:Rectangle=(hasTopFrame || hasRightFrame)? new Rectangle(0, textureFrame.y, rightWidth, topHeight):null;
		//_topRight=Texture.fromTexture(_texture, topRightRegion, topRightFrame);
//
		//var middleLeftRegion:Rectangle=new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
		//var middleLeftFrame:Rectangle=hasLeftFrame ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight):null;
		//_middleLeft=Texture.fromTexture(_texture, middleLeftRegion, middleLeftFrame);
//
		//var middleCenterRegion:Rectangle=new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
		//_middleCenter=Texture.fromTexture(_texture, middleCenterRegion);
//
		//var middleRightRegion:Rectangle=new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
		//var middleRightFrame:Rectangle=hasRightFrame ? new Rectangle(0, 0, rightWidth, middleHeight):null;
		//_middleRight=Texture.fromTexture(_texture, middleRightRegion, middleRightFrame);
//
		//var bottomLeftRegion:Rectangle=new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
		//var bottomLeftFrame:Rectangle=(hasLeftFrame || hasBottomFrame)? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight):null;
		//_bottomLeft=Texture.fromTexture(_texture, bottomLeftRegion, bottomLeftFrame);
//
		//var bottomCenterRegion:Rectangle=new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
		//var bottomCenterFrame:Rectangle=hasBottomFrame ? new Rectangle(0, 0, centerWidth, bottomHeight):null;
		//_bottomCenter=Texture.fromTexture(_texture, bottomCenterRegion, bottomCenterFrame);
//
		//var bottomRightRegion:Rectangle=new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
		//var bottomRightFrame:Rectangle=(hasBottomFrame || hasRightFrame)? new Rectangle(0, 0, rightWidth, bottomHeight):null;
		//_bottomRight=Texture.fromTexture(_texture, bottomRightRegion, bottomRightFrame);
	}

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

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

	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _id;
	}

	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		return _pivotMatrix;
	}

	public var texture(get_texture, null):SubTexture;
 	private function get_texture():SubTexture
	{
		return _texture;
	}

	public var scale9Grid(get_scale9Grid, null):Rectangle;
 	private function get_scale9Grid():Rectangle
	{
		return _scale9Grid;
	}

	//public var topLeft(get_topLeft, null):Texture;
 	//private function get_topLeft():Texture
	//{
		//return _topLeft;
	//}
//
	//public var topCenter(get_topCenter, null):Texture;
 	//private function get_topCenter():Texture
	//{
		//return _topCenter;
	//}
//
	//public var topRight(get_topRight, null):Texture;
 	//private function get_topRight():Texture
	//{
		//return _topRight;
	//}
//
	//public var middleLeft(get_middleLeft, null):Texture;
 	//private function get_middleLeft():Texture
	//{
		//return _middleLeft;
	//}
//
	//public var middleCenter(get_middleCenter, null):Texture;
 	//private function get_middleCenter():Texture
	//{
		//return _middleCenter;
	//}
//
	//public var middleRight(get_middleRight, null):Texture;
 	//private function get_middleRight():Texture
	//{
		//return _middleRight;
	//}
//
	//public var bottomLeft(get_bottomLeft, null):Texture;
 	//private function get_bottomLeft():Texture
	//{
		//return _bottomLeft;
	//}
//
	//public var bottomCenter(get_bottomCenter, null):Texture;
 	//private function get_bottomCenter():Texture
	//{
		//return _bottomCenter;
	//}
//
	//public var bottomRight(get_bottomRight, null):Texture;
 	//private function get_bottomRight():Texture
	//{
		//return _bottomRight;
	//}

	public function clone():IGAFTexture
	{
		return null;// new GAFScale9Texture(_id, _texture, _pivotMatrix.clone(), _scale9Grid);
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------
}