import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import funkin.savedata.FunkinSave;
import funkin.backend.MusicBeatGroup;

class HudBase extends MusicBeatGroup {
	private var downscroll(get, set):Bool;
	function get_downscroll():Bool {return PlayState.instance.camHUD.downscroll;}
	function set_downscroll(value:Bool):Bool {return downscroll = PlayState.instance.camHUD.downscroll = value;}

	private var songScore(get, set):Int;
	function get_songScore():Int {return PlayState.instance.songScore;}
	function set_songScore(value:Int):Int {return songScore = PlayState.instance.songScore = value;}

	private var misses(get, set):Int;
	function get_misses():Int {return PlayState.instance.misses;}
	function set_misses(value:Int):Int {return misses = PlayState.instance.misses = value;}

	private var accuracy(get, set):Float;
	function get_accuracy():Float {return PlayState.instance.accuracy;}
	function set_accuracy(value:Int):Float {return accuracy = PlayState.instance.accuracy = value;}

	public function create() {}
	public function postCreate() {}
	public function update(elapsed:Float) {}
	public function postUpdate(elapsed:Float) {}

	public function onCountdown(event) {}
	public function onPostCountdown(event) {}
	public function onSongStart() {}
	public function onNoteHit(event) {}
	public function onPlayerMiss(event) {}
	public function onPostPlayerMiss(event) {}
	public function onFlowUpdate(flow:Float) {}
}