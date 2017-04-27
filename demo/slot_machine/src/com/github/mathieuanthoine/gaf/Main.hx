package com.github.mathieuanthoine.gaf;

import com.github.haxePixiGAF.core.GAFLoader;
import com.github.haxePixiGAF.core.ZipToGAFAssetConverter;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFGFXData;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFImage;
import com.github.haxePixiGAF.display.GAFMovieClip;
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

	private var _machine:SlotMachine;
	
	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(432, 768, {backgroundColor : 0xFFFFFF});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onConverted);		
		converter.once(GAFEvent.ERROR, onConverted);		
		converter.convert("slot_machine_design/slot_machine_design.gaf");
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var timeline: GAFTimeline = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle.getGAFTimeline("slot_machine_design", "rootTimeline");
		
		_machine = new SlotMachine(timeline);

		stage.addChild(_machine);

		_machine.play();

		//_machine.getArm().addEventListener(TouchEvent.TOUCH, onArmTouched);
		//_machine.getSwitchMachineBtn().addEventListener(TouchEvent.TOUCH, onSwitchMachineBtnTouched);
		
		Browser.window.requestAnimationFrame(gameLoop);
		
	}
	
	//private function onArmTouched(event: TouchEvent): void
	//{
		//var touch: Touch = event.getTouch(_machine.getArm());
		//if (touch)
		//{
			//if (touch.phase == TouchPhase.ENDED)
			//{
				//_machine.start();
			//}
		//}
	//}
//
	//private function onSwitchMachineBtnTouched(event: TouchEvent): void
	//{
		//var touch: Touch = event.getTouch(_machine.getSwitchMachineBtn());
		//if (touch)
		//{
			//if (touch.phase == TouchPhase.HOVER)
			//{
				//_machine.getSwitchMachineBtn().setSequence("Over");
			//}
			//else if (touch.phase == TouchPhase.BEGAN)
			//{
				//_machine.getSwitchMachineBtn().setSequence("Down");
			//}
			//else if (touch.phase == TouchPhase.ENDED)
			//{
				//_machine.getSwitchMachineBtn().setSequence("Up");
				//_machine.switchType();
			//}
			//else
			//{
				//_machine.getSwitchMachineBtn().setSequence("Up");
			//}
		//}
	//}
	
	private function onError(pEvent: Dynamic): Void
	{
		trace(pEvent);
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}