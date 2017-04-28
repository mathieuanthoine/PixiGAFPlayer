package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.GAF;
import com.github.haxePixiGAF.data.config.CFilter;
import com.github.haxePixiGAF.data.config.CTextFieldObject;
import com.github.haxePixiGAF.text.TextFormatAlign;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.graphics.Graphics;
import pixi.core.math.Matrix;
import pixi.core.math.Point;
import pixi.core.text.DefaultStyle;
import pixi.core.text.Text;
import haxe.extern.EitherType;
import pixi.core.text.TextStyle;

using com.github.haxePixiGAF.utils.MatrixUtility;

/**
 * GAFTextField is a text entry control that extends functionality of the<code>feathers.controls.TextInput</code>
 * for the GAF library needs.
 * All dynamic text fields(including input text fields)in GAF library are instances of the GAFTextField.
 */
/**
 * TODO
 * @author Mathieu Anthoine
 */
@:expose("GAF.GAFTextField")
class GAFTextField extends GAFContainer implements IGAFDebug
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

	private static var HELPER_POINT:Point=new Point();
	
	private var _scale:Float;
	private var _csf:Float;

	private var __debugOriginalAlpha:Float=null;

	private var _orientationChanged:Bool;

	private var _config:CTextFieldObject;
	
	private var textField:Text;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 * GAFTextField represents text field that is part of the<code>GAFMovieClip</code>
	 * @param config
	 * @param scale
	 * @param csf
	 */
	public function new(config:CTextFieldObject, scale:Float=1, csf:Float=1,?debug:Bool=false)
	{
		
		super();

		config.textFormat.wordWrap = true;
		config.textFormat.wordWrapWidth = config.width;
		
		textField = new Text(config.text, config.textFormat);
		
		if(Math.isNaN(scale))scale=1;
		if(Math.isNaN(csf))csf=1;
				
		_scale=scale;
		_csf=csf;
		
		if (config.textFormat.align == TextFormatAlign.CENTER) {
			textField.anchor.x = 0.5;
			textField.x = config.width / 2;
		}
		else if (config.textFormat.align == TextFormatAlign.RIGHT) {
			textField.anchor.x = 1;
			textField.x = config.width;
		}
		
		if (debug) {
			var lGraph:Graphics = new Graphics();
			lGraph.beginFill(0x00FFFF);
			lGraph.drawRect(0,0, config.width, config.height);
			lGraph.endFill();
			lGraph.alpha = 0.5;
			addChild(lGraph);
		}
		
		//TODO: Input text ?
		//restrict=config.restrict;
		//isEditable=config.editable;
		//isEnabled=isEditable || config.selectable;// editable text must be selectable anyway
		//displayAsPassword=config.displayAsPassword;
		//maxChars=config.maxChars;
		//verticalAlign=TextInput.VERTICAL_ALIGN_TOP;

		//textEditorProperties.textFormat=cloneTextFormat(config.textFormat);
		//textEditorProperties.embedFonts=GAF.useDeviceFonts ? false:config.embedFonts;
		//textEditorProperties.multiline=config.multiline;
		//textEditorProperties.wordWrap=config.wordWrap;
		//textEditorFactory=function():ITextEditor
		//{
			//return new GAFTextFieldTextEditor(_scale, _csf);
		//};

		addChild(textField);
		
		invalidateSize();

		_config=config;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new instance of GAFTextField.
	 */
	public function copy():GAFTextField
	{
		var clone:GAFTextField=new GAFTextField(_config, _scale, _csf);
		clone.alpha=alpha;
		clone.visible=visible;
		clone.transformationMatrix=transformationMatrix;
		//TODO
		//clone.textEditorFactory=textEditorFactory;
		clone.setFilterConfig(_filterConfig, _filterScale);

		return clone;
	}

	/**
	 * @private
	 * We need to update the textField size after the textInput was transformed
	 */
	public function invalidateSize():Void
	{
		//if(textEditor && textEditor is TextFieldTextEditor)
		//{
			//(textEditor as TextFieldTextEditor).invalidate(INVALIDATION_FLAG_SIZE);
		//}
		//invalidate(INVALIDATION_FLAG_SIZE);
	}

	public var debugColors(null, set_debugColors):Array<Int>;
 	private function set_debugColors(value:Array<Int>):Array<Int>
	{
		//var t:Texture=Texture.fromColor(1, 1, DebugUtility.RENDERING_NEUTRAL_COLOR, 1, true);
		//var bgImage:Image=new Image(t);
		//var alpha0:Float;
		//var alpha1:Float;
//
		//switch(value.length)
		//{
			//case 1:
				//bgImage.color=value[0];
				//bgImage.alpha=(value[0]>>>24)/ 255;
				//break;
			//case 2:
				//bgImage.setVertexColor(0, value[0]);
				//bgImage.setVertexColor(1, value[0]);
				//bgImage.setVertexColor(2, value[1]);
				//bgImage.setVertexColor(3, value[1]);
//
				//alpha0=(value[0]>>>24)/ 255;
				//alpha1=(value[1]>>>24)/ 255;
				//bgImage.setVertexAlpha(0, alpha0);
				//bgImage.setVertexAlpha(1, alpha0);
				//bgImage.setVertexAlpha(2, alpha1);
				//bgImage.setVertexAlpha(3, alpha1);
				//break;
			//case 3:
				//bgImage.setVertexColor(0, value[0]);
				//bgImage.setVertexColor(1, value[0]);
				//bgImage.setVertexColor(2, value[1]);
				//bgImage.setVertexColor(3, value[2]);
//
				//alpha0=(value[0]>>>24)/ 255;
				//bgImage.setVertexAlpha(0, alpha0);
				//bgImage.setVertexAlpha(1, alpha0);
				//bgImage.setVertexAlpha(2,(value[1]>>>24)/ 255);
				//bgImage.setVertexAlpha(3,(value[2]>>>24)/ 255);
				//break;
			//case 4:
				//bgImage.setVertexColor(0, value[0]);
				//bgImage.setVertexColor(1, value[1]);
				//bgImage.setVertexColor(2, value[2]);
				//bgImage.setVertexColor(3, value[3]);
//
				//bgImage.setVertexAlpha(0,(value[0]>>>24)/ 255);
				//bgImage.setVertexAlpha(1,(value[1]>>>24)/ 255);
				//bgImage.setVertexAlpha(2,(value[2]>>>24)/ 255);
				//bgImage.setVertexAlpha(3,(value[3]>>>24)/ 255);
				//break;
		//}
//
		//return backgroundSkin=bgImage;
		return null;
	}

	override public function setFilterConfig(value:CFilter, scale:Float=1):Void
	{
		if(_filterConfig !=value || _filterScale !=scale)
		{
			if(value!=null)
			{
				_filterConfig=value;
				_filterScale=scale;
			}
			else
			{
				_filterConfig=null;
				_filterScale=null;
			}

			applyFilter();
		}
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function applyFilter():Void
	{
		//if(textEditor)
		//{
			//if(textEditor is GAFTextFieldTextEditor)
			//{
				//(textEditor as GAFTextFieldTextEditor).setFilterConfig(_filterConfig, _filterScale);
			//}
			//else if(_filterConfig && !Math.isNaN(_filterScale))
			//{
				//if(_filterChain)
				//{
					//_filterChain.dispose();
				//}
				//else
				//{
					//_filterChain=new GAFFilterChain();
				//}
//
				//_filterChain.setFilterData(_filterConfig);
				//filter=_filterChain;
			//}
			//else if(filter)
			//{
				//filter.dispose();
				//filter=null;
//
				//_filterChain=null;
			//}
		//}
	}

	private function __debugHighlight():Void
	{
		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=1;
	}

	private function __debugLowlight():Void
	{
		if(Math.isNaN(__debugOriginalAlpha))
		{
			__debugOriginalAlpha=alpha;
		}
		alpha=.05;
	}

	private function __debugResetLight():Void
	{
		if(!Math.isNaN(__debugOriginalAlpha))
		{
			alpha=__debugOriginalAlpha;
			__debugOriginalAlpha=null;
		}
	}

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	//override private function createTextEditor():Void
	//{
		//super.createTextEditor();
//
		//applyFilter();
	//}

	override public function destroy(?options:EitherType<Bool, DestroyOptions>):Void
	{
		super.destroy(options);
		_config=null;
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

	/**
	 * The width of the text in pixels.
	 * @return {Number}
	 */
	public var textWidth(get_textWidth, null):Float;
 	private function get_textWidth():Float
	{
		//validate();
		//textEditor.measureText(HELPER_POINT);

		return HELPER_POINT.x;
	}

	/**
	 * The height of the text in pixels.
	 * @return {Number}
	 */
	public var textHeight(get_textHeight, null):Float;
 	private function get_textHeight():Float
	{
		//validate();
		//textEditor.measureText(HELPER_POINT);

		return HELPER_POINT.y;
	}
	
	public var text (get, set):String;
	
	private function get_text ():String {
		return textField.text;
	}
	
	private function set_text (pText:String):String {
		return textField.text = pText;
	}
	
	public var style (get_style, null):TextStyle;
	
	private function get_style ():TextStyle {
		return cast(textField.style,TextStyle);
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------

	/** @private */
	private function cloneTextFormat(textFormat:TextStyle):TextStyle
	{
		if (textFormat==null) throw "Argument \"textFormat\" must be not null.";

		var result:TextStyle = new TextStyle();
		result.fontFamily=textFormat.fontFamily;
		result.fontSize=textFormat.fontSize;
		result.fill = textFormat.fill;
		result.fontWeight=textFormat.fontWeight;
		result.fontStyle=textFormat.fontStyle;
		//textFormat. = underline;
		//textFormat. = url;
		//textFormat. = target;
		result.align=textFormat.align;
		//textFormat. = leftMargin;
		//textFormat. = rightMargin;
		//textFormat. = blockIndent;
		//textFormat. = leading;

		return result;
	}
}