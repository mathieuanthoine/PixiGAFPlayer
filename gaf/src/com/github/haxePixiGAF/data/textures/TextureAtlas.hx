package com.github.haxePixiGAF.data.textures;

import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.Texture;

/**
 * AS3 Conversion of Starling TextureAtlas class
 * @author Mathieu Anthoine
 */

/** A texture atlas is a collection of many smaller textures in one big image. This class
 *  is used to access textures from such an atlas.
 *  
 *<p>Using a texture atlas for your textures solves two problems:</p>
 *  
 *<ul>
 *	<li>Whenever you switch between textures, the batching of image objects is disrupted.</li>
 *	<li>Any Stage3D texture has to have side lengths that are powers of two. Starling hides 
 *		this limitation from you, but at the cost of additional graphics memory.</li>
 *</ul>
 *  
 *<p>By using a texture atlas, you avoid both texture switches and the power-of-two 
 *  limitation. All textures are within one big "super-texture", and Starling takes care that 
 *  the correct part of this texture is displayed.</p>
 *  
 *<p>There are several ways to create a texture atlas. One is to use the atlas generator 
 *  script that is bundled with Starling's sibling, the<a href="http://www.sparrow-framework.org">
 *  Sparrow framework</a>. It was only tested in Mac OS X, though. A great multi-platform 
 *  alternative is the commercial tool<a href="http://www.texturepacker.com">
 *  Texture Packer</a>.</p>
 *  
 *<p>Whatever tool you use, Starling expects the following file format:</p>
 * 
 *<listing>
 * 	&lt;TextureAtlas imagePath='atlas.png'&gt;
 * 	  &lt;SubTexture name='texture_1' x='0'  y='0' width='50' height='50'/&gt;
 * 	  &lt;SubTexture name='texture_2' x='50' y='0' width='20' height='30'/&gt;
 * 	&lt;/TextureAtlas&gt;
 *</listing>
 *  
 *<strong>Texture Frame</strong>
 *
 *<p>If your images have transparent areas at their edges, you can make use of the 
 *<code>frame</code>property of the Texture class. Trim the texture by removing the 
 *  transparent edges and specify the original texture size like this:</p>
 * 
 *<listing>
 * 	&lt;SubTexture name='trimmed' x='0' y='0' height='10' width='10'
 * 		frameX='-10' frameY='-10' frameWidth='30' frameHeight='30'/&gt;
 *</listing>
 *
 *<strong>Texture Rotation</strong>
 *
 *<p>Some atlas generators can optionally rotate individual textures to optimize the texture
 *  distribution. This is supported via the boolean attribute "rotated". If it is set to
 *<code>true</code>for a certain subtexture, this means that the texture on the atlas
 *  has been rotated by 90 degrees, clockwise. Starling will undo that rotation by rotating
 *  it counter-clockwise.</p>
 *
 *<p>In this case, the positional coordinates(<code>x, y, width, height</code>)
 *  are expected to point at the subtexture as it is present on the atlas(in its rotated
 *  form), while the "frame" properties must describe the texture in its upright form.</p>
 *
 */
class TextureAtlas
{
	private var _atlasTexture:Texture;
	private var _subTextures:Map<String,SubTexture>;
	private var _subTextureNames:Array<String>;
	
	/** helper objects */
	private static var sNames:Array<String>=[];
	
	/** Create a texture atlas from a texture by parsing the regions from an XML file. */
	public function new(texture:Texture)
	{
		_subTextures=new Map<String,SubTexture>();
		_atlasTexture=texture;
	}
	
	/** Disposes the atlas texture. */
	public function dispose():Void
	{
		//_atlasTexture.dispose();
		_atlasTexture.destroy();
	}
	
	/** Retrieves a SubTexture by name. Returns<code>null</code>if it is not found. */
	public function getTexture(name:String):Texture
	{
		return _subTextures[name];
	}
	
	/** Returns all textures that start with a certain string, sorted alphabetically
	 *(especially useful for "MovieClip"). */
	public function getTextures(prefix:String="", ?out:Array<Texture>  ):Array<Texture>
	{
		if (out == null) out = new Array<Texture>();
		for (name in getNames(prefix, sNames)) out[out.length] = getTexture(name);// avoid 'push'
		
		//sNames.length=0;
		sNames=[];
		return out;
	}
	
	/** Returns all texture names that start with a certain string, sorted alphabetically. */
	public function getNames(prefix:String="", ?out:Array<String>):Array<String>
	{
		if (out == null) out = new Array<String>();
		var name:String;
		
		if(_subTextureNames==null)
		{
			// optimization:store sorted list of texture names
			_subTextureNames=[];
			for(name in _subTextures.keys())_subTextureNames[_subTextureNames.length]=name;
			_subTextureNames.sort(function (pA:String,pB:String):Int { return pA.toLowerCase()<pB.toLowerCase() ? -1 : 1;});
		}

		for(name in _subTextureNames) {
			if(name.indexOf(prefix)==0) out[out.length]=name;
		}
		
		return out;
	}
	
	/** Returns the region rectangle associated with a specific name, or<code>null</code>
	 *  if no region with that name has been registered. */
	public function getRegion(name:String):Rectangle
	{
		var subTexture:SubTexture=_subTextures[name];
		return subTexture!=null ? subTexture.region:null;
	}
	
	/** Returns the frame rectangle of a specific region, or<code>null</code>if that region 
	 *  has no frame. */
	public function getFrame(name:String):Rectangle
	{
		var subTexture:SubTexture=_subTextures[name];
		return subTexture!=null ? subTexture.frame:null;
	}
	
	/** If true, the specified region in the atlas is rotated by 90 degrees(clockwise). The
	 *  SubTexture is thus rotated counter-clockwise to cancel out that transformation. */
	public function getRotation(name:String):Bool
	{
		var subTexture:SubTexture=_subTextures[name];
		return subTexture!=null ? subTexture.rotated:false;
	}

	/** Adds a named region for a SubTexture(described by rectangle with coordinates in
	 *  points)with an optional frame. */
	public function addRegion(name:String, region:Rectangle, frame:Rectangle=null, rotated:Bool=false):Void
	{
		_subTextures[name]=new SubTexture(_atlasTexture, region, false, frame, rotated);
		_subTextureNames=null;
	}
	
	/** Removes a region with a certain name. */
	public function removeRegion(name:String):Void
	{
		var subTexture:SubTexture=_subTextures[name];
		//if(subTexture) subTexture.dispose();
		if(subTexture!=null) subTexture.destroy();
		_subTextures.remove(name);
		_subTextureNames=null;
	}
	
	/** The base texture that makes up the atlas. */
	public var texture(get_texture, null):Texture;
 	private function get_texture():Texture { return _atlasTexture;}
	
	// utility methods

	private static function parseBool(value:String):Bool
	{
		return value.toLowerCase()=="true";
	}
}