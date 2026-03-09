package karaoke.game;

import funkin.backend.MusicBeatGroup;

enum SpeakerMode {
	STEP,
	BEAT,
	MEASURE,
	NONE
}

enum LightMode {
	SHARED,
	NONE
}

class Speaker extends MusicBeatGroup {
	public var mode:SpeakerMode;
	public var interval:Int;
	public var autoLength:Int;

	public var lightMode:LightMode;

	public var main:FunkinSprite;
	public var light:FunkinSprite;

	override function new(X:Float = 0, Y:Float = 0, ?Mode:SpeakerMode, ?Interval:Int, ?AutoLength:Int, ?LMode:LightMode) {
		X ??= 0;
		Y ??= 0;
		super(X, Y, 0);

		Mode ??= SpeakerMode.BEAT;
		Interval ??= 2;
		AutoLength ??= 3;
		LMode ??= LightMode.SHARED;
		mode = Mode;
		interval = Interval;
		autoLength = AutoLength;
		lightMode = LMode;

		main = new FunkinSprite();
		main.frames = Paths.getFrames("game/speaker/speaker");
		main.addAnim("colors", "spr_speaker_", 0, false);
		main.addAnim("off", "spr_speakeroff_", 0, false);
		main.animation.timeScale = 0;
		add(main);
		main.playAnim("colors", true);

		light = new FunkinSprite();
		light.frames = Paths.getFrames("game/speaker/speakerLights");
		light.addAnim("colors", "light", 0, false);
		light.addAnim("cyan", "cyan", 0, false);
		light.addAnim("player", "player", 0, false);
		light.addAnim("error", "error", 24, false);
		light.animation.timeScale = 0;
		light.visible = false;
		add(light);
		light.playAnim("colors", true);

		light.setPosition(12, 1);
	}

	public function autoProgress(time:Int) {
		if (autoLength < 0) {
			return;
		}

		final frameIndex:Int = FlxMath.wrap(Std.int(time / interval), 0, autoLength);
		main.playAnim("colors", false);
		main.animation.curAnim.curFrame = frameIndex;

		if (lightMode != LightMode.SHARED) {
			return;
		}

		light.playAnim("colors", false);
		light.animation.curAnim.curFrame = frameIndex;
	}

	override function stepHit(step:Int) {
		super.stepHit(step);
		if (mode != SpeakerMode.STEP || step <= 0) {
			return;
		}

		autoProgress(step);
	}

	override function beatHit(beat:Int) {
		super.beatHit(beat);
		if (mode != SpeakerMode.BEAT || beat <= 0) {
			return;
		}

		autoProgress(beat);
	}

	override function measureHit(measure:Int) {
		super.measureHit(measure);
		if (mode != SpeakerMode.MEASURE || measure <= 0) {
			return;
		}

		autoProgress(measure);
	}
}