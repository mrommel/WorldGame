precision mediump float;

varying vec2 texCoord;

uniform sampler2D Texture;

void main(void) {
    gl_FragColor = texture2D(Texture, texCoord);
}