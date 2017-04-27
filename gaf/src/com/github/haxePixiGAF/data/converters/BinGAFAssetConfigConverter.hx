package com.github.haxePixiGAF.data.converters;

import com.github.haxePixiGAF.data.GAFAssetConfig;
import com.github.haxePixiGAF.data.config.CAnimationFrame;
import com.github.haxePixiGAF.data.config.CAnimationFrameInstance;
import com.github.haxePixiGAF.data.config.CAnimationObject;
import com.github.haxePixiGAF.data.config.CAnimationSequence;
import com.github.haxePixiGAF.data.config.CBlurFilterData;
import com.github.haxePixiGAF.data.config.CFilter;
import com.github.haxePixiGAF.data.config.CFrameAction;
import com.github.haxePixiGAF.data.config.CSound;
import com.github.haxePixiGAF.data.config.CStage;
import com.github.haxePixiGAF.data.config.CTextFieldObject;
import com.github.haxePixiGAF.data.config.CTextureAtlasCSF;
import com.github.haxePixiGAF.data.config.CTextureAtlasElement;
import com.github.haxePixiGAF.data.config.CTextureAtlasElements;
import com.github.haxePixiGAF.data.config.CTextureAtlasScale;
import com.github.haxePixiGAF.data.config.CTextureAtlasSource;
import com.github.haxePixiGAF.data.converters.ErrorConstants.ErrorConstants;
import com.github.haxePixiGAF.events.GAFEvent;
import com.github.haxePixiGAF.text.TextFormatAlign;
import com.github.haxePixiGAF.utils.GAFBytesInput;
import com.github.haxePixiGAF.utils.MathUtility;
import haxe.Json;
import haxe.io.Bytes;
import pixi.core.math.Matrix;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.text.TextStyle;
import pixi.interaction.EventEmitter;

using com.github.haxePixiGAF.utils.MatrixUtility;
using com.github.haxePixiGAF.utils.RectangleUtility;
using com.github.haxePixiGAF.utils.EventEmitterUtility;

/**
 * TODO
 * @author Mathieu Anthoine
 */
class BinGAFAssetConfigConverter extends EventEmitter
{

	private static inline var SIGNATURE_GAC:Int=0x00474143;	
	
	//tags
	private static inline var TAG_END:Int=0;
	private static inline var TAG_DEFINE_ATLAS:Int=1;
	private static inline var TAG_DEFINE_ANIMATION_MASKS:Int=2;
	private static inline var TAG_DEFINE_ANIMATION_OBJECTS:Int=3;
	private static inline var TAG_DEFINE_ANIMATION_FRAMES:Int=4;
	private static inline var TAG_DEFINE_NAMED_PARTS:Int=5;
	private static inline var TAG_DEFINE_SEQUENCES:Int=6;
	private static inline var TAG_DEFINE_TEXT_FIELDS:Int=7;// v4.0
	private static inline var TAG_DEFINE_ATLAS2:Int=8;// v4.0
	private static inline var TAG_DEFINE_STAGE:Int=9;
	private static inline var TAG_DEFINE_ANIMATION_OBJECTS2:Int=10;// v4.0
	private static inline var TAG_DEFINE_ANIMATION_MASKS2:Int=11;// v4.0
	private static inline var TAG_DEFINE_ANIMATION_FRAMES2:Int=12;// v4.0
	private static inline var TAG_DEFINE_TIMELINE:Int=13;// v4.0
	private static inline var TAG_DEFINE_SOUNDS:Int=14;// v5.0
	private static inline var TAG_DEFINE_ATLAS3:Int=15;// v5.0

	//filters
	private static inline var FILTER_DROP_SHADOW:Int=0;
	private static inline var FILTER_BLUR:Int=1;
	private static inline var FILTER_GLOW:Int=2;
	private static inline var FILTER_COLOR_MATRIX:Int=6;	
	
	private static var sHelperRectangle:Rectangle=new Rectangle(0,0,0,0);
	private static var sHelperMatrix:Matrix=new Matrix();	
	
	private var _assetID:String;
	private var _bytes:GAFBytesInput;
	private var _defaultScale:Float;
	private var _defaultContentScaleFactor:Float;
	private var _config:GAFAssetConfig;
	private var _textureElementSizes:Array<Rectangle>;// Point by texture element id


	private var _isTimeline:Bool=false;
	private var _currentTimeline:GAFTimelineConfig;
	private var _async:Bool=false;
	private var _ignoreSounds:Bool=false;
	
	// --------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	public function new(assetID:String, bytes:GAFBytesInput)
	{
		super();
		
		_bytes=bytes;
		_assetID=assetID;
		_textureElementSizes=[];
	}
	
	public function convert(async:Bool=false):Void
	{
		if(async)
		{
			trace ("TODO asynchrone conversion");
		}
		else
		{
			parseStart();
		}
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function parseStart():Void
	{
		
		_bytes.bigEndian = false;
		
		_config=new GAFAssetConfig(_assetID);
		_config.compression=_bytes.readInt();
		_config.versionMajor=_bytes.readSByte();
		_config.versionMinor = _bytes.readSByte();
		_config.fileLength = _bytes.readUnsignedInt();	
		
		if(_config.versionMajor>GAFAssetConfig.MAX_VERSION)
		{
			//TODO: verifier le systeme de diffusion de message (qui les écoute, les centralise)
			emit(GAFEvent.ERROR,WarningConstants.UNSUPPORTED_FILE + "Library version:" + GAFAssetConfig.MAX_VERSION + ", file version:" + _config.versionMajor);
			//dispatchEvent(new DynamicEvent(ErrorEvent.ERROR, false, false, WarningConstants.UNSUPPORTED_FILE + "Library version:" + GAFAssetConfig.MAX_VERSION + ", file version:" + _config.versionMajor));
			return;
		}

		switch(_config.compression)
		{
			// TODO
			case SIGNATURE_GAC: 
				throw "HaxePixiGAF: GAF compressed format not supported yet";
				//decompressConfig();
		}

		if(_config.versionMajor<4)
		{
			_currentTimeline=new GAFTimelineConfig(_config.versionMajor + "." + _config.versionMinor);
			_currentTimeline.id="0";
			_currentTimeline.assetID=_assetID;
			_currentTimeline.framesCount=_bytes.readShort();
			_currentTimeline.bounds=new Rectangle(_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat());
			_currentTimeline.pivot=new Point(_bytes.readFloat(), _bytes.readFloat());
			_config.timelines.push(_currentTimeline);
		}
		else
		{
		
			var i:Int=0;
			var l:UInt = _bytes.readUnsignedInt();
			for(i in 0...l)
			{
				_config.scaleValues.push(_bytes.readFloat());					
			}
			
			l = _bytes.readUnsignedInt();

			for(i in 0...l)
			{
				_config.csfValues.push(_bytes.readFloat());
			}
		}

		readNextTag();
	}
	
	private function checkForMissedRegions(timelineConfig:GAFTimelineConfig):Void
	{
		if(timelineConfig.textureAtlas!=null && timelineConfig.textureAtlas.contentScaleFactor.elements!=null)
		{
			for(ao in timelineConfig.animationObjects.animationObjectsDictionary)
			{
				if(ao.type==CAnimationObject.TYPE_TEXTURE && timelineConfig.textureAtlas.contentScaleFactor.elements.getElement(ao.regionID)==null)
				{
					timelineConfig.addWarning(WarningConstants.REGION_NOT_FOUND);
					break;
				}
			}
		}
	}
	
	private function readNextTag():Void
	{
		
		var tagID:Int=_bytes.readShort();
		var tagLength:Int=_bytes.readUnsignedInt();
		
		switch(tagID)
		{
			case BinGAFAssetConfigConverter.TAG_DEFINE_STAGE:
				readStageConfig(_bytes, _config);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS:
				readTextureAtlasConfig(tagID);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2:
				readTextureAtlasConfig(tagID);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3:
				readTextureAtlasConfig(tagID);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS:
				readAnimationMasks(tagID, _bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS2:
				readAnimationMasks(tagID, _bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS:
				readAnimationObjects(tagID, _bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS2:
				readAnimationObjects(tagID, _bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES:
				readAnimationFrames(tagID);
				return;
			case BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES2:
				readAnimationFrames(tagID);
				return;
			case BinGAFAssetConfigConverter.TAG_DEFINE_NAMED_PARTS:
				readNamedParts(_bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_SEQUENCES:
				readAnimationSequences(_bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_TEXT_FIELDS:
				readTextFields(_bytes, _currentTimeline);
			case BinGAFAssetConfigConverter.TAG_DEFINE_SOUNDS:
				//TODO TAG_DEFINE_SOUNDS
				trace ("TODO TAG_DEFINE_SOUNDS");
				if(!_ignoreSounds)
				{
					//readSounds(_bytes, _config);
				}
				else
				{
					_bytes.position +=tagLength;
				}
			case BinGAFAssetConfigConverter.TAG_DEFINE_TIMELINE:
				_currentTimeline=readTimeline();
			case BinGAFAssetConfigConverter.TAG_END:
				if(_isTimeline)
				{
					_isTimeline=false;
				}
				else
				{
					_bytes.position=_bytes.length;
					endParsing();
					return;
				}
			default:
				trace(WarningConstants.UNSUPPORTED_TAG);
				_bytes.position +=tagLength;
		}

		delayedReadNextTag();
	}

	private function delayedReadNextTag():Void
	{
		if(_async)
		{
			trace ("TODO asynchrone delayedReadNextTag");
		}
		else
		{
			readNextTag();
		}
	}
	
	private function readTimeline():GAFTimelineConfig
	{
		var timelineConfig:GAFTimelineConfig=new GAFTimelineConfig(_config.versionMajor + "." + _config.versionMinor);
		timelineConfig.id = Std.string(_bytes.readUnsignedInt());
		timelineConfig.assetID=_config.id;
		timelineConfig.framesCount=_bytes.readUnsignedInt();
		timelineConfig.bounds=new Rectangle(_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat());
		timelineConfig.pivot=new Point(_bytes.readFloat(), _bytes.readFloat());
		
		var hasLinkage:Bool = _bytes.readBoolean();
		
		if(hasLinkage)
		{
			timelineConfig.linkage = _bytes.readUTF();			
		}

		_config.timelines.push(timelineConfig);

		_isTimeline=true;

		return timelineConfig;
	}
	
	private function readTextureAtlasConfig(tagID:Int):Void
	{
		var i:Int=0;
		var j:Int=0;

		var scale:Float = _bytes.readFloat();
		
		if(_config.scaleValues.indexOf(scale)==-1)
		{
			_config.scaleValues.push(scale);
		}

		var textureAtlas:CTextureAtlasScale=getTextureAtlasScale(scale);

		/////////////////////

		var contentScaleFactor:CTextureAtlasCSF=null;
		var atlasLength:Int = _bytes.readSByte();
		
		var atlasID:Int=0;
		var sourceLength:Int=0;
		var csf:Float;
		var source:String;

		var elements:CTextureAtlasElements=null;
		if(textureAtlas.allContentScaleFactors.length>0)
		{
			elements=textureAtlas.allContentScaleFactors[0].elements;
		}

		if(elements==null)
		{
			elements=new CTextureAtlasElements();
		}

		for(i in 0...atlasLength)
		{
			atlasID = _bytes.readUnsignedInt();
			
			sourceLength = _bytes.readSByte();
			
			for(j in 0...sourceLength)
			{
				source = _bytes.readUTF();

				csf = _bytes.readFloat();

				if(_config.csfValues.indexOf(csf)==-1)
				{
					_config.csfValues.push(csf);
				}

				contentScaleFactor = getTextureAtlasCSF(scale, csf);

				updateTextureAtlasSources(contentScaleFactor, Std.string(atlasID), source);
				if(contentScaleFactor.elements==null)
				{
					contentScaleFactor.elements=elements;
				}
			}
		}
	
		/////////////////////
		
		var elementsLength:Int = _bytes.readUnsignedInt();
		
		var element:CTextureAtlasElement;
		var hasScale9Grid:Bool=false;
		var scale9Grid:Rectangle=null;
		var pivot:Point;
		var topLeft:Point;
		var elementScaleX:Float=0;
		var elementScaleY:Float=0;
		var elementWidth:Float;
		var elementHeight:Float;
		var elementAtlasID:Int=0;
		var rotation:Bool=false;
		var linkageName:String="";

		for(i in 0...elementsLength)
		{
			
			pivot = new Point(_bytes.readFloat(), _bytes.readFloat());	
			topLeft = new Point(_bytes.readFloat(), _bytes.readFloat());
			
			if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS || tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2)
			{			
				elementScaleX = elementScaleY = _bytes.readFloat();
			}

			elementWidth = _bytes.readFloat();			
			elementHeight = _bytes.readFloat();
			atlasID = _bytes.readUnsignedInt();
			elementAtlasID = _bytes.readUnsignedInt();

			if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS2
			|| tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3)
			{
				hasScale9Grid=_bytes.readBoolean();
				if(hasScale9Grid)
				{
					scale9Grid=new Rectangle(
							_bytes.readFloat(), _bytes.readFloat(),
							_bytes.readFloat(), _bytes.readFloat()
					);
				}
				else
				{
					scale9Grid=null;
				}
			}

			if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ATLAS3)
			{
				elementScaleX=_bytes.readFloat();
				elementScaleY=_bytes.readFloat();
				rotation=_bytes.readBoolean();
				linkageName=_bytes.readUTF();
			}
			
			if(elements.getElement(Std.string(elementAtlasID))==null)
			{
				element=new CTextureAtlasElement(Std.string(elementAtlasID), Std.string(atlasID));
				element.region=new Rectangle(Std.int(topLeft.x), Std.int(topLeft.y), elementWidth, elementHeight);
				element.pivotMatrix = new Matrix(1 / elementScaleX, 0, 0, 1 / elementScaleY, -pivot.x / elementScaleX, -pivot.y / elementScaleY);
				element.scale9Grid=scale9Grid;
				element.linkage=linkageName;
				element.rotated=rotation;
				elements.addElement(element);

				if(element.rotated)
				{
					sHelperRectangle.x = 0;
					sHelperRectangle.y = 0;
					sHelperRectangle.width = elementHeight;
					sHelperRectangle.height = elementWidth;
				}
				else
				{
					sHelperRectangle.x = 0;
					sHelperRectangle.y = 0;
					sHelperRectangle.width = elementWidth;
					sHelperRectangle.height = elementHeight;
				}
				sHelperMatrix.copyFrom(element.pivotMatrix);
				var invertScale:Float=1 / scale;
				sHelperMatrix.scale(invertScale, invertScale);
				// TODO RectangleUtil.getBounds
				//RectangleUtil.getBounds(sHelperRectangle, sHelperMatrix, sHelperRectangle);

				if(_textureElementSizes[elementAtlasID]==null)
				{
					_textureElementSizes[elementAtlasID]=sHelperRectangle.clone();
				}
				else
				{
					_textureElementSizes[elementAtlasID]=_textureElementSizes[elementAtlasID].union(sHelperRectangle);
				}
			}
		}
	}
	
	private function getTextureAtlasScale(scale:Float):CTextureAtlasScale
	{
		var textureAtlasScale:CTextureAtlasScale=null;
		var textureAtlasScales:Array<CTextureAtlasScale>=_config.allTextureAtlases;

		var l:Int = textureAtlasScales.length;
		
		for(i in 0...l)
		{
			if(MathUtility.equals(textureAtlasScales[i].scale, scale))
			{
				textureAtlasScale=textureAtlasScales[i];
				break;
			}
		}

		if(textureAtlasScale==null)
		{
			textureAtlasScale=new CTextureAtlasScale();
			textureAtlasScale.scale=scale;
			textureAtlasScales.push(textureAtlasScale);
		}

		return textureAtlasScale;
	}
	
	private function getTextureAtlasCSF(scale:Float, csf:Float):CTextureAtlasCSF
	{
		var textureAtlasScale:CTextureAtlasScale=getTextureAtlasScale(scale);
		var textureAtlasCSF:CTextureAtlasCSF=textureAtlasScale.getTextureAtlasForCSF(csf);
		if(textureAtlasCSF==null)
		{
			textureAtlasCSF=new CTextureAtlasCSF(csf, scale);
			textureAtlasScale.allContentScaleFactors.push(textureAtlasCSF);
		}

		return textureAtlasCSF;
	}

	private function updateTextureAtlasSources(textureAtlasCSF:CTextureAtlasCSF, atlasID:String, source:String):Void
	{
		var textureAtlasSource:CTextureAtlasSource=null;
		var textureAtlasSources:Array<CTextureAtlasSource>=textureAtlasCSF.sources;
		
		var l:Int = textureAtlasSources.length;
		
		for(i in 0...l)
		{
			if(textureAtlasSources[i].id==atlasID)
			{
				textureAtlasSource=textureAtlasSources[i];
				break;
			}
		}

		if(textureAtlasSource==null)
		{
			textureAtlasSource=new CTextureAtlasSource(atlasID, source);
			textureAtlasSources.push(textureAtlasSource);
		}
	}
	
	private static function readAnimationMasks(tagID:Int, tagContent:GAFBytesInput, timelineConfig:GAFTimelineConfig):Void
	{
		var length:Int=tagContent.readUnsignedInt();
		var objectID:Int=0;
		var regionID:Int=0;
		var type:String;

		for(i in 0...length)
		{
			objectID=tagContent.readUnsignedInt();
			regionID=tagContent.readUnsignedInt();
			if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS)
			{
				type=CAnimationObject.TYPE_TEXTURE;
			}
			else // BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_MASKS2
			{
				type=getAnimationObjectTypeString(tagContent.readUnsignedShort());
			}
			timelineConfig.animationObjects.addAnimationObject(new CAnimationObject(objectID + "", regionID + "", type, true));
		}
	}
	
	private static function getAnimationObjectTypeString(type:Int):String
	{
		var typeString:String=CAnimationObject.TYPE_TEXTURE;
		switch(type)
		{
			case 0:
				typeString=CAnimationObject.TYPE_TEXTURE;
			case 1:
				typeString=CAnimationObject.TYPE_TEXTFIELD;
			case 2:
				typeString=CAnimationObject.TYPE_TIMELINE;
		}

		return typeString;
	}

	private static function readAnimationObjects(tagID:Int, tagContent:GAFBytesInput, timelineConfig:GAFTimelineConfig):Void
	{
		var length:Int=tagContent.readUnsignedInt();
		var objectID:Int=0;
		var regionID:Int=0;
		var type:String;

		for(i in 0...length)
		{
			objectID=tagContent.readUnsignedInt();
			regionID=tagContent.readUnsignedInt();
			if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_OBJECTS)
			{
				type=CAnimationObject.TYPE_TEXTURE;
			}
			else
			{
				type=getAnimationObjectTypeString(tagContent.readUnsignedShort());
			}
			timelineConfig.animationObjects.addAnimationObject(new CAnimationObject(objectID + "", regionID + "", type, false));
		}
	}
	
	private static function readAnimationSequences(tagContent:GAFBytesInput, timelineConfig:GAFTimelineConfig):Void
	{
		var length:Int=tagContent.readUnsignedInt();
		var sequenceID:String;
		var startFrameNo:Int;
		var endFrameNo:Int;

		for(i in 0...length)
		{
			sequenceID=tagContent.readUTF();
			startFrameNo=tagContent.readShort();
			endFrameNo=tagContent.readShort();
			timelineConfig.animationSequences.addSequence(new CAnimationSequence(sequenceID, startFrameNo, endFrameNo));
		}
	}
	
	private static function readNamedParts(tagContent:GAFBytesInput, timelineConfig:GAFTimelineConfig):Void
	{
		timelineConfig.namedParts=new Map<String,String>();

		var length:Int=tagContent.readUnsignedInt();
		var partID:Int=0;
		for(i in 0...length)
		{
			partID=tagContent.readUnsignedInt();
			timelineConfig.namedParts[Std.string(partID)]=tagContent.readUTF();
		}
	}
	
	private static function readTextFields(tagContent:GAFBytesInput, timelineConfig:GAFTimelineConfig):Void
	{
		var length:Int=tagContent.readUnsignedInt();
		var pivotX:Float;
		var pivotY:Float;
		var textFieldID:Int=0;
		var width:Float;
		var height:Float;
		var text:String;
		var embedFonts:Bool;
		var multiline:Bool;
		var wordWrap:Bool;
		var restrict:String=null;
		var editable:Bool;
		var selectable:Bool;
		var displayAsPassword:Bool;
		var maxChars:Int=0;

		var textFormat:TextStyle;

		for(i in 0...length)
		{
			textFieldID=tagContent.readUnsignedInt();
			pivotX=tagContent.readFloat();
			pivotY=tagContent.readFloat();
			width=tagContent.readFloat();
			height=tagContent.readFloat();

			text=tagContent.readUTF();

			embedFonts=tagContent.readBoolean();
			multiline=tagContent.readBoolean();
			wordWrap=tagContent.readBoolean();

			var hasRestrict:Bool=tagContent.readBoolean();
			if(hasRestrict)
			{
				restrict=tagContent.readUTF();
			}

			editable=tagContent.readBoolean();
			selectable=tagContent.readBoolean();
			displayAsPassword=tagContent.readBoolean();
			maxChars=tagContent.readUnsignedInt();

			// read textFormat
			var alignFlag:Int=tagContent.readUnsignedInt();
			var align:String=null;
			switch(alignFlag)
			{
				case 0:
					align=TextFormatAlign.LEFT;
				case 1:
					align=TextFormatAlign.RIGHT;
				case 2:
					align=TextFormatAlign.CENTER;
				case 3:
					align=TextFormatAlign.JUSTIFY;
				case 4:
					align=TextFormatAlign.START;
				case 5:
					align=TextFormatAlign.END;
			}

			var blockIndent:Float=tagContent.readUnsignedInt();
			var bold:Bool=tagContent.readBoolean();
			var bullet:Bool=tagContent.readBoolean();
			var color:Int=tagContent.readUnsignedInt();

			var font:String=tagContent.readUTF();
			var indent:Int=tagContent.readUnsignedInt();
			var italic:Bool=tagContent.readBoolean();
			var kerning:Bool=tagContent.readBoolean();
			var leading:Int=tagContent.readUnsignedInt();
			var leftMargin:Float=tagContent.readUnsignedInt();
			var letterSpacing:Float=tagContent.readFloat();
			var rightMargin:Float=tagContent.readUnsignedInt();
			var size:Int=tagContent.readUnsignedInt();

			var l:Int=tagContent.readUnsignedInt();
			var tabStops:Array<Dynamic>=[];
			for(j in 0...l)
			{
				tabStops.push(tagContent.readUnsignedInt());
			}

			var target:String=tagContent.readUTF();
			var underline:Bool=tagContent.readBoolean();
			var url:String=tagContent.readUTF();

			/* var display:String=tagContent.readUTF();*/

			textFormat = new TextStyle();
			textFormat.fontFamily = font;
			textFormat.fontSize = size;
			textFormat.fill = color;
			textFormat.fontWeight = bold ? "bold" : "normal";
			textFormat.fontStyle = italic ? "italic" : "normal";
			//textFormat. = underline;
			//textFormat. = url;
			//textFormat. = target;
			textFormat.align = align;
			//textFormat. = leftMargin;
			//textFormat. = rightMargin;
			//textFormat. = blockIndent;
			//textFormat. = leading;

			//textFormat.=bullet;
			//textFormat.=kerning;
			//textFormat.=display;
			textFormat.letterSpacing=letterSpacing;
			//textFormat.=tabStops;
			//textFormat.=indent;

			var textFieldObject:CTextFieldObject=new CTextFieldObject(Std.string(textFieldID), text, textFormat,width, height);
			textFieldObject.pivotPoint.x=-pivotX;
			textFieldObject.pivotPoint.y=-pivotY;
			textFieldObject.embedFonts=embedFonts;
			textFieldObject.multiline=multiline;
			textFieldObject.wordWrap=wordWrap;
			textFieldObject.restrict=restrict;
			textFieldObject.editable=editable;
			textFieldObject.selectable=selectable;
			textFieldObject.displayAsPassword=displayAsPassword;
			textFieldObject.maxChars=maxChars;
			timelineConfig.textFields.addTextFieldObject(textFieldObject);
		}
	}
	
	private function readAnimationFrames(tagID:Int, startIndex:Int=0, ?framesCount:Int=-1, ?prevFrame:CAnimationFrame=null):Void
	{
		if(framesCount==-1)
		{
			framesCount=_bytes.readUnsignedInt();
		}
		var missedFrameNumber:Int=0;
		var filterLength:Int=0;
		var frameNumber:Int=0;
		var statesCount:Int=0;
		var filterType:Int=0;
		var stateID:Int=0;
		var zIndex:Int=0;
		var alpha:Float;
		var matrix:Matrix;
		var maskID:String;
		var hasMask:Bool=false;
		var hasEffect:Bool=false;
		var hasActions:Bool=false;
		var hasColorTransform:Bool=false;
		var hasChangesInDisplayList:Bool=false;

		var timelineConfig:GAFTimelineConfig=_config.timelines[_config.timelines.length - 1];
		var instance:CAnimationFrameInstance;
		var currentFrame:CAnimationFrame;
		var blurFilter:CBlurFilterData;
		var blurFilters:Map<String,CBlurFilterData>= new Map<String,CBlurFilterData>();
		var filter:CFilter;

		if(framesCount!=-1)
		{
			for(i in startIndex...framesCount)
			{
				if(_async /*&&(getTimer()- cycleTime>=20)*/)
				{
					trace ("TODO asynchrone readAnimationFrames");
					return;
				}

				frameNumber=_bytes.readUnsignedInt();

				if(tagID==BinGAFAssetConfigConverter.TAG_DEFINE_ANIMATION_FRAMES)
				{
					hasChangesInDisplayList=true;
					hasActions=false;
				}
				else
				{
					hasChangesInDisplayList=_bytes.readBoolean();
					hasActions=_bytes.readBoolean();
				}

				if(prevFrame!=null)
				{
					currentFrame=prevFrame.clone(frameNumber);

					missedFrameNumber = prevFrame.frameNumber + 1;
					while (missedFrameNumber < currentFrame.frameNumber) {
						timelineConfig.animationConfigFrames.addFrame(prevFrame.clone(missedFrameNumber));
						missedFrameNumber++;
					}
				}
				else
				{
					currentFrame=new CAnimationFrame(frameNumber);

					if(currentFrame.frameNumber>1)
					{
						missedFrameNumber = 1;
						while (missedFrameNumber < currentFrame.frameNumber) {
							timelineConfig.animationConfigFrames.addFrame(new CAnimationFrame(missedFrameNumber));
							missedFrameNumber++;
						}
		
					}
				}

				if(hasChangesInDisplayList)
				{
					statesCount=_bytes.readUnsignedInt();

					for(j in 0...statesCount)
					{
						hasColorTransform=_bytes.readBoolean();
						hasMask=_bytes.readBoolean();
						hasEffect=_bytes.readBoolean();

						stateID=_bytes.readUnsignedInt();
						zIndex=_bytes.readInt();
						alpha=_bytes.readFloat();
						if(alpha==1)
						{
							alpha = GAF.maxAlpha;
						}
						matrix = new Matrix(_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat(),_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat());

						filter=null;

						if(hasColorTransform)
						{
							var params:Array<Float>=[
								_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat(),
								_bytes.readFloat(), _bytes.readFloat(), _bytes.readFloat(),
								_bytes.readFloat()];
							if (filter==null) filter=new CFilter();
							filter.addColorTransform(params);
						}

						if(hasEffect)
						{
							if (filter==null) filter=new CFilter();

							filterLength=_bytes.readSByte();
							for(k in 0...filterLength)
							{
								filterType=_bytes.readUnsignedInt();
								var warning:String=null;

								switch(filterType)
								{
									case BinGAFAssetConfigConverter.FILTER_DROP_SHADOW:
										warning=readDropShadowFilter(_bytes, filter);
									case BinGAFAssetConfigConverter.FILTER_BLUR:
										warning=readBlurFilter(_bytes, filter);
										blurFilter=cast(filter.filterConfigs[filter.filterConfigs.length - 1],CBlurFilterData);
										if(blurFilter.blurX>=2 && blurFilter.blurY>=2)
										{
											if (!blurFilters.exists(Std.string(stateID)))
											{
												blurFilters[Std.string(stateID)]=blurFilter;
											}
										}
										else
										{
											blurFilters[Std.string(stateID)]=null;
										}
									case BinGAFAssetConfigConverter.FILTER_GLOW:
										warning=readGlowFilter(_bytes, filter);
									case BinGAFAssetConfigConverter.FILTER_COLOR_MATRIX:
										warning=readColorMatrixFilter(_bytes, filter);
									default:
										trace(WarningConstants.UNSUPPORTED_FILTERS);
								}

								timelineConfig.addWarning(warning);
							}
						}

						if(hasMask)
						{
							maskID=_bytes.readUnsignedInt()+ "";
						}
						else
						{
							maskID="";
						}

						instance=new CAnimationFrameInstance(stateID + "");
						instance.update(zIndex, matrix, alpha, maskID, filter);

						if(maskID!=null && filter!=null)
						{
							timelineConfig.addWarning(WarningConstants.FILTERS_UNDER_MASK);
						}

						currentFrame.addInstance(instance);
					}

					currentFrame.sortInstances();
				}

				if(hasActions)
				{
					var data:Dynamic;
					var action:CFrameAction;
					var count:Int=_bytes.readUnsignedInt();
					for(a in 0...count)
					{
						action=new CFrameAction();
						action.type=_bytes.readUnsignedInt();
						action.scope=_bytes.readUTF();

						var paramsLength:Int=_bytes.readUnsignedInt();
						if(paramsLength>0)
						{
							var lBytes:Bytes = Bytes.alloc(paramsLength);
							_bytes.readBytes(lBytes, 0, paramsLength);
							var paramsBA:GAFBytesInput = new GAFBytesInput(lBytes);
							paramsBA.bigEndian = false;
							while(paramsBA.position<paramsBA.length)
							{
								action.params.push(paramsBA.readUTF());
							}
							paramsBA.close();
							paramsBA = null;
						}

						if(action.type==CFrameAction.DISPATCH_EVENT &&  action.params[0]==CSound.GAF_PLAY_SOUND &&  action.params.length>3)
						{
							if(_ignoreSounds)
							{
								continue;//do not add sound events if they're ignored
							}
							
							data=Json.parse(action.params[3]);
							//timelineConfig.addSound(data, frameNumber);
						}

						currentFrame.addAction(action);
					}
				}

				timelineConfig.animationConfigFrames.addFrame(currentFrame);

				prevFrame=currentFrame;
			} //end loop

			missedFrameNumber = prevFrame.frameNumber + 1;
			while (missedFrameNumber<=timelineConfig.framesCount) {
				timelineConfig.animationConfigFrames.addFrame(prevFrame.clone(missedFrameNumber));
				missedFrameNumber++;
			}

			for(currentFrame in timelineConfig.animationConfigFrames.frames)
			{
				for(instance in currentFrame.instances)
				{
					if(blurFilters[instance.id]!=null && instance.filter!=null)
					{
						blurFilter=instance.filter.getBlurFilter();
						if(blurFilter!=null && blurFilter.resolution==1)
						{
							blurFilter.blurX *=0.5;
							blurFilter.blurY *=0.5;
							blurFilter.resolution=0.75;
						}
					}
				}
			}
		} //end condition

		delayedReadNextTag();
	}
	
	private function readMaskMaxSizes():Void
	{
		for(timeline in _config.timelines)
		{
			for(frame in timeline.animationConfigFrames.frames)
			{
				for(frameInstance in frame.instances)
				{
					var animationObject:CAnimationObject=timeline.animationObjects.getAnimationObject(frameInstance.id);
					if(animationObject.mask)
					{
						if(animationObject.maxSize==null)
						{
							animationObject.maxSize=new Point();
						}

						var maxSize:Point=animationObject.maxSize;

						if(animationObject.type==CAnimationObject.TYPE_TEXTURE)
						{
							sHelperRectangle.copyFrom(_textureElementSizes[Std.parseInt(animationObject.regionID)]);
						}
						else if(animationObject.type==CAnimationObject.TYPE_TIMELINE)
						{
							var maskTimeline:GAFTimelineConfig=null;
							for(maskTimeline in _config.timelines)
							{
								if(maskTimeline.id==animationObject.regionID)
								{
									break;
								}
							}
							sHelperRectangle.copyFrom(maskTimeline.bounds);
						}
						else if(animationObject.type==CAnimationObject.TYPE_TEXTFIELD)
						{
							var textField:CTextFieldObject=timeline.textFields.textFieldObjectsDictionary[animationObject.regionID];
							sHelperRectangle.x =-textField.pivotPoint.x;
							sHelperRectangle.y =-textField.pivotPoint.y;
							sHelperRectangle.width = textField.width;
							sHelperRectangle.height = textField.height;
						}
						//TODO
						//RectangleUtil.getBounds(sHelperRectangle, frameInstance.matrix, sHelperRectangle);
						maxSize.set(
								Math.max(maxSize.x, Math.abs(sHelperRectangle.width)),
								Math.max(maxSize.y, Math.abs(sHelperRectangle.height)));
					}
				}
			}
		}
	}
	
	private function endParsing():Void
	{
		_bytes.close();
		_bytes=null;

		readMaskMaxSizes();

		var itemIndex:Int=0;
		
		if(Math.isNaN(_config.defaultScale))
		{
			
			if(!Math.isNaN(_defaultScale))
			{
				itemIndex=MathUtility.getItemIndex(_config.scaleValues, _defaultScale);
				if(itemIndex<0)
				{
					parseError(_defaultScale + ErrorConstants.SCALE_NOT_FOUND);
					return;
				}
			}
			_config.defaultScale=_config.scaleValues[itemIndex];
		}

		if(Math.isNaN(_config.defaultContentScaleFactor))
		{
			itemIndex=0;
			if(!Math.isNaN(_defaultContentScaleFactor))
			{
				itemIndex=MathUtility.getItemIndex(_config.csfValues, _defaultContentScaleFactor);
				if(itemIndex<0)
				{
					parseError(_defaultContentScaleFactor + ErrorConstants.CSF_NOT_FOUND);
					return;
				}
			}
			_config.defaultContentScaleFactor=_config.csfValues[itemIndex];
		}

		for(textureAtlasScale in _config.allTextureAtlases)
		{
			for(textureAtlasCSF in textureAtlasScale.allContentScaleFactors)
			{
				if(MathUtility.equals(_config.defaultContentScaleFactor, textureAtlasCSF.csf))
				{
					textureAtlasScale.contentScaleFactor=textureAtlasCSF;
					break;
				}
			}
		}

		for(timelineConfig in _config.timelines)
		{
			timelineConfig.allTextureAtlases=_config.allTextureAtlases;

			for(textureAtlasScale in _config.allTextureAtlases)
			{
				if(MathUtility.equals(_config.defaultScale, textureAtlasScale.scale))
				{
					timelineConfig.textureAtlas=textureAtlasScale;
				}
			}

			timelineConfig.stageConfig=_config.stageConfig;

			checkForMissedRegions(timelineConfig);
		}

		emit(GAFEvent.COMPLETE, {target:this});
	}
	
	private function parseError(message:String):Void
	{
		if(hasEventListener(GAFEvent.ERROR))
		{
			emit(GAFEvent.ERROR, {bubbles:false, cancelable:false, text:message});
		}
		else
		{
			throw message;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var config(get_config, null):GAFAssetConfig;
 	private function get_config():GAFAssetConfig
	{
		return _config;
	}

	public var assetID(get_assetID, null):String;
 	private function get_assetID():String
	{
		return _assetID;
	}

	public var ignoreSounds(null, set_ignoreSounds):Bool;
 	private function set_ignoreSounds(ignoreSounds:Bool)
	{
		return _ignoreSounds=ignoreSounds;
	}
	
	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------

	private static function readStageConfig(tagContent:GAFBytesInput, config:GAFAssetConfig):Void
	{
		var stageConfig:CStage=new CStage();

		stageConfig.fps = tagContent.readSByte();
		//stageConfig.color=tagContent.readInt();
		stageConfig.color=tagContent.readFloat();
		stageConfig.width=tagContent.readUnsignedShort();
		stageConfig.height=tagContent.readUnsignedShort();
		
		config.stageConfig=stageConfig;
	}
	
	private static function readDropShadowFilter(source:GAFBytesInput, filter:CFilter):String
	{
		var color:Array<Dynamic>=readColorValue(source);
		var blurX:Float=source.readFloat();
		var blurY:Float=source.readFloat();
		var angle:Float=source.readFloat();
		var distance:Float=source.readFloat();
		var strength:Float=source.readFloat();
		var inner:Bool=source.readBoolean();
		var knockout:Bool=source.readBoolean();

		return filter.addDropShadowFilter(blurX, blurY, color[1], color[0], angle, distance, strength, inner, knockout);
	}

	private static function readBlurFilter(source:GAFBytesInput, filter:CFilter):String
	{
		return filter.addBlurFilter(source.readFloat(), source.readFloat());
	}

	private static function readGlowFilter(source:GAFBytesInput, filter:CFilter):String
	{
		var color:Array<Dynamic>=readColorValue(source);
		var blurX:Float=source.readFloat();
		var blurY:Float=source.readFloat();
		var strength:Float=source.readFloat();
		var inner:Bool=source.readBoolean();
		var knockout:Bool=source.readBoolean();

		return filter.addGlowFilter(blurX, blurY, color[1], color[0], strength, inner, knockout);
	}

	private static function readColorMatrixFilter(source:GAFBytesInput, filter:CFilter):String
	{
		var matrix:Array<Float>=new Array<Float>();
		for(i in 0...20)
		{
			matrix[i]=source.readFloat();
		}

		return filter.addColorMatrixFilter(matrix);
	}

	private static function readColorValue(source:GAFBytesInput):Array<Float>
	{
		var argbValue:Int=source.readUnsignedInt();
		var alpha:Float=Std.int(((argbValue>>24)& 0xFF)* 100 / 255)/ 100;
		var color:Int=argbValue & 0xFFFFFF;

		return [alpha, color];
	}
	
	// -------------
	
	public var defaultScale(null, set_defaultScale):Float;
 	private function set_defaultScale(defaultScale:Float)
	{
		return _defaultScale=defaultScale;
	}

	public var defaultCSF(null, set_defaultCSF):Float;
 	private function set_defaultCSF(csf:Float)
	{
		return _defaultContentScaleFactor=csf;
	}
	
}