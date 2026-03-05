import funkin.savedata.FunkinSave;
import karaoke.backend.utils.ColorExtension;
import karaoke.backend.utils.SpriteExtension;
import karaoke.backend.utils.SpriteExtension.DrawPassType;

using ColorExtension;
using SpriteExtension;

public var isNightTime:Bool = false;

public final duskColor:FlxColor = 0xFFFFC8AD;
public final duskLightingColor:Array<Float> = duskColor.vec4();
public final duskShadowColor:Array<Float> = [0, 0, 0, 0.4];
public final duskSkyGradientColor:Array<Float> = [0xFFE6966E, 0xFFE8B66C];

public final nightLightingColor:Array<Float> = [97/255, 76/255, 117/255, 1.0];
public final nightShadowColor:Array<Float> = [0, 0, 0, 0.45];

public var sky:FunkinSprite;
public var houseLights:FunkinSprite;

function postCreate() {
	if (!isNightTime) {
		sky = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF91CFDD);
		sky.scrollFactor.set();
		sky.zoomFactor = 0;
		insert(0, sky);
	} else {
		sky = new FunkinSprite(0, -75).loadGraphic(Paths.image("game/stages/house/googlenightsky"));
		sky.scrollFactor.set(0.5, 0.5);
		sky.shader = new CustomShader("wiggleButWeird");
		sky.shader.wIntensity = 0.025;
		sky.shader.wStrength = 5;
		sky.shader.wSpeed = 1;
		sky.shader.threeFuckingTextureCalls = false;
		sky.setColorTransform(0.5, 0.2, 0.7, 1, 40, 40, 40, 0);
		insert(0, sky);

		houseLights = new FunkinSprite().loadSprite(Paths.image("game/stages/house/lights"));
		houseLights.animation.add("lights", !FunkinSave.save.data.epilepsy ? [0,1,2,3] : [0], 0, true, false, false);
		houseLights.playAnim("lights", true);
		insert(5, houseLights);

		for (name => spr in stage.stageSprites) {
			spr.color = 0xFF261B33;
		}

		dad.setDrawPass([
			DrawPassType.LIGHTING({x: 4, y: 0}, nightLightingColor, nightShadowColor)
		]);

		playerEyes.colorReplaceEyes = 0xFFFFFFFF.vec3();
		boyfriend.setDrawPass([
			DrawPassType.SHADER(false, {x: 0, y: 0}, playerSkin),
			DrawPassType.LIGHTING({x: -4, y: 0}, nightLightingColor, nightShadowColor),
			DrawPassType.SHADER(true, {x: 0, y: 0}, playerEyes)
		]);

		gf.setDrawPass([
			DrawPassType.SHADER(false, {x: 0, y: 0}, ladySkin),
			DrawPassType.LIGHTING({x: 0, y: 4}, nightLightingColor, nightShadowColor),
		]);

		ladySpeaker?.setDrawPass([
			DrawPassType.LIGHTING({x: 0, y: 4}, nightLightingColor, nightShadowColor)
		]);
		if (speakerLight != null) {
			speakerLight = true;
		}
	}
}

function beatHit(b) {
	if (!isNightTime || speakerInterval == null) return;

	houseLights.animation.curAnim.curFrame = FlxMath.wrap(Std.int(b/speakerInterval), 0, 3);
}

var timer:Float = 0;
function update(e:Float) {
	if (!isNightTime) return;

	timer += e;
	sky.shader.elapsed = timer;
}