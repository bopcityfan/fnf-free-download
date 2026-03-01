static var playerSkin:CustomShader;
static var playerEyes:CustomShader;

function postCreate() {
	shader = playerSkin = new CustomShader("player/colorswap");
	playerEyes = new CustomShader("player/eyes");
}

function destroy() {
	playerSkin = null;
	playerEyes = null;
}