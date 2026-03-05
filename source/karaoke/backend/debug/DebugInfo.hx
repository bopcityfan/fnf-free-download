package karaoke.backend.debug;

import funkin.backend.MusicBeatGroup;
import funkin.backend.system.Flags;
import karaoke.backend.KaraokeText;
import openfl.filters.BitmapFilter;

class DebugInfo extends MusicBeatGroup {
	public var fpsText:KaraokeText;
	public var memoryText:KaraokeText;
	public var versionText:KaraokeText;

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

		memoryText = new KaraokeText(0, 0, 0, 'MEM: ${CoolUtil.getSizeString(memory)} / ${CoolUtil.getSizeString(memoryPeak)}', 8, true);
		memoryText.color = 0xFFFFCB80;
		memoryText.onDraw = shadowDraw;
		add(memoryText);

		versionText = new KaraokeText(0, 0, 0, 'VERSION: ${Flags.customFlags['MOD_VERSION']}', 8, true);
		versionText.color = 0xFFE6FF80;
		versionText.onDraw = shadowDraw;
		add(versionText);

		final textArray:Array<KaraokeText> = [fpsText, memoryText, versionText];
		for (index => text in textArray) {
			text.borderSize = 1;

			if (index == 0) {
				continue;
			}

			final lastText:KaraokeText = textArray[index-1];
			text.y = lastText.y + (lastText.height * 0.75);
		}
	}

	public function update(elapsed:Float) {
		fpsText.text = 'FPS: ${Std.string(Math.round(fps))}';
		memoryText.text = 'MEM: ${CoolUtil.getSizeString(memory)} / ${CoolUtil.getSizeString(memoryPeak)}';
	}
}