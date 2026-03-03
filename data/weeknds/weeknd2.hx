import karaoke.backend.utils.ColorExtension;
using ColorExtension;

function postCreate() {
	weekndData.songs[1].display = "gameboy";
	composition['dude'].shader.favColor = 0xFFF1F471.vec4();
}

function onSpriteNew(event) {
	if (event.sprite.name == 'cyanCDBoy') {
		event.cancel();

		remove(event.sprite);
		event.sprite.destroy();
	}
}