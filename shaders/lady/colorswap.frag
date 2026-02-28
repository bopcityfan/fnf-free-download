#pragma header

uniform vec4 colorReplaceSkin = vec4(243.0/255.0, 224.0/255.0, 203.0/255.0, 1.0);
uniform vec4 colorReplaceHair = vec4(198.0/255.0, 192.0/255.0, 179.0/255.0, 1.0);
uniform vec4 colorReplaceDye = vec4(88.0/255.0, 61.0/255.0, 95.0/255.0, 1.0);

uniform vec4 colorReplaceShirt = vec4(63.0/255.0, 114.0/255.0, 112.0/255.0, 1.0);

uniform vec4 colorReplaceShorts = vec4(44.0/255.0, 63.0/255.0, 62.0/255.0, 1.0);
uniform vec4 colorReplaceSocks = vec4(187.0/255.0, 201.0/255.0, 208.0/255.0, 1.0);
uniform vec4 colorReplaceShoes = vec4(53.0/255.0, 69.0/255.0, 77.0/255.0, 1.0);

vec4 colorSkin = vec4(243.0/255.0, 224.0/255.0, 203.0/255.0, 1.0);
vec4 colorHair = vec4(198.0/255.0, 192.0/255.0, 179.0/255.0, 1.0);
vec4 colorDye = vec4(88.0/255.0, 61.0/255.0, 95.0/255.0, 1.0);

vec4 colorShirt = vec4(63.0/255.0, 114.0/255.0, 112.0/255.0, 1.0);

vec4 colorShorts = vec4(44.0/255.0, 63.0/255.0, 62.0/255.0, 1.0);
vec4 colorSocks = vec4(187.0/255.0, 201.0/255.0, 208.0/255.0, 1.0);
vec4 colorShoes = vec4(53.0/255.0, 69.0/255.0, 77.0/255.0, 1.0);

float range = 3.0 / 255.0;
vec3 rangeVec = vec3(range, range, range);

bool inRange(vec3 rgb)
{
	return all(lessThanEqual(rgb, rangeVec));
}

void main()
{
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);

	if(inRange(abs(pixelColor.rgb - colorSkin.rgb)))
		pixelColor.rgb = colorReplaceSkin.rgb;
	if(inRange(abs(pixelColor.rgb - colorHair.rgb)))
		pixelColor.rgb = colorReplaceHair.rgb;
	if(inRange(abs(pixelColor.rgb - colorDye.rgb)))
		pixelColor.rgb = colorReplaceDye.rgb;

	if(inRange(abs(pixelColor.rgb - colorShirt.rgb)))
		pixelColor.rgb = colorReplaceShirt.rgb;

	if(inRange(abs(pixelColor.rgb - colorShorts.rgb)))
		pixelColor.rgb = colorReplaceShorts.rgb;
	if(inRange(abs(pixelColor.rgb - colorSocks.rgb)))
		pixelColor.rgb = colorReplaceSocks.rgb;
	if(inRange(abs(pixelColor.rgb - colorShoes.rgb)))
		pixelColor.rgb = colorReplaceShoes.rgb;

	// apply the colorTransform stuff that flixel_texture2D normally does (stolen from FlxGraphicsShader lol!!!)
	if (hasColorTransform) {
		mat4 colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

		pixelColor = clamp(openfl_ColorOffsetv + (pixelColor * colorMultiplier), 0.0, 1.0);
	}

	// alpha fix (also stolen from FlxGraphicsShader)
	if (pixelColor.a > 0.0) gl_FragColor = vec4(pixelColor.rgb * pixelColor.a * openfl_Alphav, pixelColor.a * openfl_Alphav);
	else gl_FragColor = vec4(pixelColor.rgb / pixelColor.a, pixelColor.a);
}