package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CTextureAtlasElements
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

	private var _elementsVector:Array<CTextureAtlasElement>;
	private var _elementsDictionary:Map<String,CTextureAtlasElement>;
	private var _elementsByLinkage:Map<String,CTextureAtlasElement>;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new():Void
	{
		_elementsVector=new Array<CTextureAtlasElement>();
		_elementsDictionary=new Map<String,CTextureAtlasElement>();
		_elementsByLinkage=new Map<String,CTextureAtlasElement>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function addElement(element:CTextureAtlasElement):Void
	{
		if(_elementsDictionary[element.id]==null)
		{
			_elementsDictionary[element.id]=element;

			_elementsVector.push(element);

			if(element.linkage!=null)
			{
				_elementsByLinkage[element.linkage]=element;
			}
		}
	}

	public function getElement(id:String):CTextureAtlasElement
	{
		if(_elementsDictionary[id]!=null)
		{
			return _elementsDictionary[id];
		}
		else
		{
			return null;
		}
	}

	public function getElementByLinkage(linkage:String):CTextureAtlasElement
	{
		if(_elementsByLinkage[linkage]!=null)
		{
			return _elementsByLinkage[linkage];
		}
		else
		{
			return null;
		}
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

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

	public var elementsVector(get_elementsVector, null):Array<CTextureAtlasElement>;
 	private function get_elementsVector():Array<CTextureAtlasElement>
	{
		return _elementsVector;
	}

}