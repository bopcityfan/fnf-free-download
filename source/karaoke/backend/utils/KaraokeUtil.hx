class KaraokeUtil {
	public static function songTimeToSeconds(steps:Float, beats:Float, sections:Float):Float {
		return (
			(Conductor.stepCrochet * steps) * 0.001 +
			(Conductor.stepCrochet * (beats * 4)) * 0.001 +
			(Conductor.stepCrochet * (sections * 16)) * 0.001
		);
	}

	public static function playMenuMusic():Void {
		if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
			CoolUtil.playMusic(Paths.music('menu'), true, 1, true, 110);
			FlxG.sound.music.persist = true;
		}
	}
}