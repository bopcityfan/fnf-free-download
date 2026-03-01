package karaoke.backend.utils;

enum DrawPassType {
	LIGHTING(offset:{x:Float, y:Float}, baseColor:Array<Float>, shadowColor:Array<Float>);
	SHADER(callDraw:Bool, offset:{x:Float, y:Float}, shader:FunkinShader);
	COLOR(callDraw:Bool, offset:{x:Float, y:Float}, color:Array<Float>);
}

class SpriteExtension {
	static public function setDrawPass(sprite:FlxSprite, drawPasses:Array<DrawPassType>) {
		var passes:Array<DrawPassType> = drawPasses;

		sprite.onDraw = (spr:FlxSprite) -> {
			for (pass in passes) {
				switch(pass) {
					case DrawPassType.LIGHTING(offset, baseColor, shadowColor):
						spr.setColorTransform(baseColor[0], baseColor[1], baseColor[2], baseColor[3] ?? 1);
						if (spr is Character) {
							spr.offset.set(-spr.globalOffset.x, -spr.globalOffset.y);
						} else {
							spr.offset.set(0, 0);
						}
						spr.draw();

						spr.setColorTransform(shadowColor[0], shadowColor[1], shadowColor[2], shadowColor[3] ?? 1);
						if (spr is Character) {
							spr.offset.set(-spr.globalOffset.x + offset.x, -spr.globalOffset.y + offset.y);
						} else {
							spr.offset.set(offset.x, offset.y);
						}
						spr.draw();
					case DrawPassType.SHADER(callDraw, offset, shader):
						spr.color = 0xFFFFFFFF;

						if (spr is Character) {
							spr.offset.set(-spr.globalOffset.x + offset.x, -spr.globalOffset.y + offset.y);
						} else {
							spr.offset.set(offset.x, offset.y);
						}

						spr.shader = shader;

						if (callDraw) {
							spr.draw();
						}
					case DrawPassType.COLOR(callDraw, offset, color):
						spr.setColorTransform(color[0], color[1], color[2], color[3] ?? 1);

						if (spr is Character) {
							spr.offset.set(-spr.globalOffset.x + offset.x, -spr.globalOffset.y + offset.y);
						} else {
							spr.offset.set(offset.x, offset.y);
						}

						if (callDraw) {
							spr.draw();
						}
				}
			}
		};
	}
}