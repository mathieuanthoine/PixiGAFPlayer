package com.github.mathieuanthoine.gaf;

import com.github.haxePixiGAF.core.GAFLoader;
import com.github.haxePixiGAF.core.ZipToGAFAssetConverter;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFGFXData;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFImage;
import com.github.haxePixiGAF.display.GAFMovieClip;
import com.github.haxePixiGAF.display.GAFTextField;
import com.github.haxePixiGAF.display.GAFTexture;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.events.GAFEvent;
import haxe.Timer;
import haxe.ds.ObjectMap;
import js.Browser;
import js.Lib;
import js.html.CanvasElement;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.InteractionEvent;
import pixi.loaders.LoaderOptions;

/**
 * @author Mathieu Anthoine
 */

class Main
{

	private var renderer:WebGLRenderer;
	private var stage:Container;
	
	private var mc: GAFMovieClip;
	private var swapBtn: GAFMovieClip;
	
	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(400, 300, {backgroundColor : 0x29213B});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onConverted);		
		converter.convert("text_field_demo/text_field_demo.gaf");
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var bundle:GAFBundle = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle;
		var timeline: GAFTimeline = bundle.getGAFTimeline("text_field_demo", "rootTimeline");
		
		mc = new GAFMovieClip(timeline);
		swapBtn = cast (mc.getChildByName("swapBtn"), GAFMovieClip);
		
		stage.addChild(mc);
		
		swapBtn.interactive = true;		
		swapBtn.on("mousedown", onMouseDown);
		swapBtn.on("mouseup", onMouseUp);
		
		Browser.window.requestAnimationFrame(gameLoop);
		
	}

	private function onMouseDown(pEvent: MouseEvent): Void
	{	
		swapBtn.gotoAndStop("Down");
	}
	
	private function onMouseUp(pEvent: MouseEvent): Void
	{	
		swapBtn.gotoAndStop("Up");
		cast(mc.getChildByName("dynamic_txt"),GAFTextField).text = cast(mc.getChildByName("input_txt"),GAFTextField).text + "\n";
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}