#pragma header

uniform vec3 colorReplaceEyes = vec3(31.0/255.0, 30.0/255.0, 39.0/255.0);

vec3 colorEyes = vec3(32.0/255.0, 30.0/255.0, 40.0/255.0);

bool inRange(vec3 rgb, float range)
{
	return all(lessThanEqual(rgb, vec3(range, range, range)));
}

void main()
{
	vec4 pixelColor = texture2D(bitmap, openfl_TextureCoordv);

	float range = 1.0 / 255.0;

	if (inRange(abs(pixelColor.rgb - colorEyes.rgb), range)) {
		pixelColor.rgb = colorReplaceEyes;
		gl_FragColor = pixelColor;
	} else {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	}
}