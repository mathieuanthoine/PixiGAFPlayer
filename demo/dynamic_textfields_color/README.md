SWF source file was converted into GAF format by Standalone GAF Converter version 5.8

<hr>

GAF Converter conversion settings:

Conversion source: Main Timeline<br>
Conversion mode: nesting <br>

☑ Limit max bake scale = 1
Atlas max size: 2048x2048

Scale settings:
☑ Basic

* Limit max bake scale = 1 is used to decrease texture atlas size. Purple background is baked in texture atlas in smaller size than it is used in animation. Upper scaling for it doesn't cause pixelation effect.

* Conversion mode "nesting" is used to save Dynamic TextFields in converted GAF asset.

Info
-----------------

The font Cooper Black is used to display text in the upper text field. The example use the WebFontLoader library and WebFontLoader Haxe externs to load the font before displaying it.

Warning
-----------------

As there is no native support for Input Text in PixiJs, Input Text are considered as Dynamic Text