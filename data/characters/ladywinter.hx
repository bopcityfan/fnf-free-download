import karaoke.game.Speaker;
import funkin.savedata.FunkinSave;

static var ladySkin:CustomShader;
static var ladySpeaker:Speaker;

function create() {
	ladySpeaker = new Speaker();

	shader = ladySkin = new CustomShader("lady/colorswap");
}

var firstFrame:Bool = true;
function update(elapsed:Float) {
	if (firstFrame) {
		firstFrame = false;
		FlxG.state.insert(FlxG.state.members.indexOf(this), ladySpeaker);
	}
	ladySpeaker.setPosition(x - (ladySpeaker.width*0.2), y + 77);
}

function destroy() {
	ladySpeaker = null;
	ladySkin = null;
}