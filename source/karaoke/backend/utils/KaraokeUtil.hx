class KaraokeUtil {
	public static function songTimeToSeconds(steps:Float, beats:Float, sections:Float):Float {
		return (
			(Conductor.stepCrochet * steps) * 0.001 +
			(Conductor.stepCrochet * (beats * 4)) * 0.001 +
			(Conductor.stepCrochet * (sections * 16)) * 0.001
		);
	}
}