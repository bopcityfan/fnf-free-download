import flixel.util.FlxGradient;
import karaoke.backend.utils.SpriteExtension;
import karaoke.backend.utils.SpriteExtension.DrawPassType;
import karaoke.backend.utils.KaraokeUtil;

using SpriteExtension;

// switch statement in stephit because life isnt good var hate
function stepHit(step:Int) {
	switch(step) {
		case 376:
			camGame.fade(0xFFFFFFFF, KaraokeUtil.songTimeToSeconds(0, 2, 0), false, null, true);
		case 384:
			camGame.flash(0xFFFFFFFF, 0.001, null, true); // stop the fade or something? idk
			camGame.fade(0xFFFFFFFF, KaraokeUtil.songTimeToSeconds(0, 1, 0), true, null, true);

			FlxGradient.overlayGradientOnFlxSprite(sky, sky.width, sky.height, duskSkyGradientColor, 0, 0, 1, 90, true);

			for (name => spr in stage.stageSprites) {
				spr.color = duskColor;
			}

			dad.setDrawPass([
				DrawPassType.LIGHTING({x: 4, y: -4}, duskLightingColor, duskShadowColor)
			]);

			boyfriend.setDrawPass([
				DrawPassType.SHADER(false, {x: 0, y: 0}, playerSkin),
				DrawPassType.LIGHTING({x: -4, y: -4}, duskLightingColor, duskShadowColor)
			]);

			gf.setDrawPass([
				DrawPassType.SHADER(false, {x: 0, y: 0}, ladySkin),
				DrawPassType.LIGHTING({x: 0, y: -4}, duskLightingColor, duskShadowColor),
			]);

			ladySpeaker?.setDrawPass([
				DrawPassType.LIGHTING({x: 0, y: -4}, duskLightingColor, duskShadowColor)
			]);
			if (speakerLight != null) {
				speakerLight = true;
			}
	}
}