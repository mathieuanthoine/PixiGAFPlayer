package com.github.haxePixiGAF.utils;
import com.github.haxePixiGAF.data.GAF;
import com.github.haxePixiGAF.data.config.CAnimationFrameInstance;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class DebugUtility
{
	public static var RENDERING_DEBUG:Bool=false;

	public static inline var RENDERING_NEUTRAL_COLOR:Int=0xCCCCCCCC;
	public static inline var RENDERING_FILTER_COLOR:Int=0xFF00FFFF;
	public static inline var RENDERING_MASK_COLOR:Int=0xFFFF0000;
	public static inline var RENDERING_ALPHA_COLOR:Int=0xFFFFFF00;

	private static var cHR:Array<Int>=[255, 255, 0, 0, 0, 255, 255];
	private static var cHG:Array<Int>=[0, 255, 255, 255, 0, 0, 0];
	private static var cHB:Array<Int>=[0, 0, 0, 255, 255, 255, 0];

	private static var aryRGB:Array<Array<Int>>=[cHR, cHG, cHB];

	public static function getRenderingDifficultyColor(instance:CAnimationFrameInstance,
													   alphaLess1:Bool=false, masked:Bool=false,
													   hasFilter:Bool=false):Array<Int>
	{
		var colors:Array<Int>=[];
		if(instance.maskID!=null || masked)
		{
			colors.push(RENDERING_MASK_COLOR);
		}
		if(instance.filter!=null || hasFilter)
		{
			colors.push(RENDERING_FILTER_COLOR);
		}
		if(instance.alpha<GAF.maxAlpha || alphaLess1)
		{
			colors.push(RENDERING_ALPHA_COLOR);
		}
		if(colors.length==0)
		{
			colors.push(RENDERING_NEUTRAL_COLOR);
		}

		return colors;
	}

	/**
	 * Returns color that objects would be painted
	 * @param difficulty value from 0 to 255
	 * @return color in ARGB format(from green to red)
	 */
	private static function getColor(difficulty:Int):Int
	{
		if(difficulty>255)
		{
			difficulty=255;
		}

		var colorArr:Array<Int>=getRGB(Math.floor(120 - 120 /(255 / difficulty)));

		var color:Int=(((difficulty>>1)+ 0x7F)<<24)| colorArr[0]<<16 | colorArr[1]<<8;

		return color;
	}

	// return RGB color from hue circle rotation
	// [0]=R, [1]=G, [2]=B
	private static function getRGB(rot:Int):Array<Int>
	{
		var retVal:Array<Int>=[];
		var aryNum:Int;
		// 0 ~ 360
		while(rot<0 || rot>360)
		{
			rot +=(rot<0)? 360:-360;
		}
		aryNum=Math.floor(rot / 60);
		// get color
		retVal=getH(rot, aryNum);
		return retVal;
	}

	// rotation　=>hue
	private static function getH(rot:Int, aryNum:Int):Array<Int>
	{
		var retVal:Array<Int>=[0, 0, 0];
		var nextNum:Int=aryNum + 1;
		for(i in 0...3)
		{
			retVal[i]=getHP(aryRGB[i], rot, aryNum, nextNum);
		}
		return retVal;
	}

	private static function getHP(_P:Array<Int>, rot:Int, aryNum:Int, nextNum:Int):Int
	{
		var retVal:Int;
		var aryC:Int;
		var nextC:Int;
		var rH:Int;
		var rotR:Float;
		aryC=_P[aryNum];
		nextC=_P[nextNum];
		rotR=(aryC + nextC)/ 60 *(rot - 60 * aryNum);
		rH=Math.floor((_P[nextNum]==0)? aryC - rotR:aryC + rotR);
		retVal=Math.round(Math.min(255, Math.abs(rH)));
		return retVal;
	}

	public static function getObjectMemoryHash(obj:Dynamic):String
	{
		var memoryHash:String=null;

		try
		{
			//TODO FakeClass
			trace ("TODO: FakeClass");
			//FakeClass(obj);
		}
		catch(e:Dynamic)
		{
			//TODO memoryHash
			trace ("TODO: memoryHash");
			memoryHash = "TODO: memoryHash";// Std.string(e).replace(/.*([@|\$].*?)to .*$/gi, '$1');
		}

		return memoryHash;
	}
}

/*
class FakeClass
{
}
*/
