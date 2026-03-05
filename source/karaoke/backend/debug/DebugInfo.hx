package karaoke.backend.debug;

import funkin.backend.MusicBeatGroup;
import funkin.backend.system.Flags;
import karaoke.backend.KaraokeText;
import openfl.filters.BitmapFilter;

class DebugInfo extends MusicBeatGroup {
	public var fpsText:KaraokeText;
	public var memoryText:KaraokeText;
	public var timeScaleText:KaraokeText;

	public var modVersionText:KaraokeText;
	public var cneCommitText:KaraokeText;

	override function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0) {
		X ??= 0;
		Y ??= 0;
		MaxSize ??= 0;

		super(X, Y, MaxSize);

		final shadowDraw:KaraokeText->Void = (spr:KaraokeText) -> {
			final oldColor:FlxColor = spr.color;

			spr.color = 0xFF000000;
			spr.offset.set(-spr.borderSize, -spr.borderSize);
			spr.draw();

			spr.color = oldColor;
			spr.offset.set();
			spr.draw();
		}

		fpsText = new KaraokeText(0, 0, 0, 'FPS: ${fps}', 16, true);
		fpsText.color = 0xFFFF8080;
		fpsText.onDraw = shadowDraw;
		add(fpsText);

		memoryText = new KaraokeText(0, 0, 0, 'MEMORY: ${CoolUtil.getSizeString(memory)} / ${CoolUtil.getSizeString(memoryPeak)}', 5, true);
		memoryText.color = 0xFFFFCB80;
		memoryText.font = Paths.font('Pixeled.ttf');
		memoryText.onDraw = shadowDraw;
		add(memoryText);

		timeScaleText = new KaraokeText(0, 0, 0, 'TIMESCALE: ${FlxG.timeScale}', 5, true);
		timeScaleText.color = 0xFFE6FF80;
		timeScaleText.font = Paths.font('Pixeled.ttf');
		timeScaleText.onDraw = shadowDraw;
		timeScaleText.visible = false;
		add(timeScaleText);

		modVersionText = new KaraokeText(0, 0, 0, 'MOD VERSION: ${Flags.customFlags['MOD_VERSION']}', 5, true);
		modVersionText.color = 0xFF9BFF80;
		modVersionText.font = Paths.font('Pixeled.ttf');
		modVersionText.onDraw = shadowDraw;
		modVersionText.visible = false;
		add(modVersionText);

		cneCommitText = new KaraokeText(0, 0, 0, 'CNE COMMIT: ${Flags.COMMIT_HASH}', 5, true);
		cneCommitText.color = 0xFF7FFEB2;
		cneCommitText.font = Paths.font('Pixeled.ttf');
		cneCommitText.onDraw = shadowDraw;
		cneCommitText.visible = false;
		add(cneCommitText);

		final textArray:Array<KaraokeText> = [fpsText, memoryText, timeScaleText, modVersionText, cneCommitText];
		for (index => text in textArray) {
			text.borderSize = 1;

			if (index == 0) {
				continue;
			}

			final lastText:KaraokeText = textArray[index-1];
			final verticalOffset:Float = index != 1 ? lastText.height * 0.6 : lastText.height * 0.7;

			text.y = lastText.y + verticalOffset;
		}
	}

	public function update(elapsed:Float) {
		fpsText.text = 'FPS: ${Std.string(Math.round(fps))}';
		memoryText.text = 'MEMORY: ${CoolUtil.getSizeString(memory)} / ${CoolUtil.getSizeString(memoryPeak)}';
		timeScaleText.text = 'TIMESCALE: ${FlxG.timeScale}';
	}
}