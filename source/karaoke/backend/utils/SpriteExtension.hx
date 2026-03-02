package karaoke.backend.utils;

enum DrawPassType {
	LIGHTING(shadowOffset:{x:Float, y:Float}, baseColor:Array<Float>, shadowColor:Array<Float>);
	SHADER(callDraw:Bool, offset:{x:Float, y:Float}, shader:FunkinShader);
	COLOR(callDraw:Bool, offset:{x:Float, y:Float}, color:Array<Float>);
}

class SpriteExtension {
	static public function setOffset(sprite:FlxSprite, x:Float = 0, y:Float = 0) {
		x = x != null ? x : 0;
		y = y != null ? y ; 0;

		if (sprite is Character) {
			sprite.offset.set(-sprite.globalOffset.x + x, -sprite.globalOffset.y + y);
		} else {
			sprite.offset.set(x, y);
		}
	}

	static public function setDrawPass(sprite:FlxSprite, drawPasses:Array<DrawPassType>) {
		var passes:Array<DrawPassType> = drawPasses;

		sprite.onDraw = (spr:FlxSprite) -> {
			for (pass in passes) {
				switch(pass) {
					case DrawPassType.LIGHTING(shadowOffset, baseColor, shadowColor):
						spr.setColorTransform(baseColor[0], baseColor[1], baseColor[2], baseColor[3] != null ? baseColor[3] : 1);
						setOffset(spr);
						spr.draw();

						spr.setColorTransform(shadowColor[0], shadowColor[1], shadowColor[2], shadowColor[3] != null ? shadowColor[3] : 1);
						setOffset(spr, shadowOffset.x, shadowOffset.y);
						spr.draw();
					case DrawPassType.SHADER(callDraw, offset, shader):
						offset = offset != null ? offset : {x: 0, y: 0};

						spr.color = 0xFFFFFFFF;
						spr.shader = shader;
						setOffset(spr, offset.x, offset.y);

						if (callDraw) {
							spr.draw();
						}
					case DrawPassType.COLOR(callDraw, offset, color):
						offset = offset != null ? offset : {x: 0, y: 0};

						spr.setColorTransform(color[0], color[1], color[2], color[3] != null ? color[3] : 1);
						setOffset(spr, offset.x, offset.y);

						if (callDraw) {
							spr.draw();
						}
				}
			}
		};
	}
}