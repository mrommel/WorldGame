precision mediump float;

varying vec4 DestinationColor;

varying vec2 TexCoordOut;
varying vec2 TexCoordOut2;

uniform sampler2D texture[2];

void main(void) {
    vec4 texel0 = texture2D(texture[0], TexCoordOut);
    vec4 texel1 = texture2D(texture[1], TexCoordOut2);
    gl_FragColor = texel0 + texel1;
}