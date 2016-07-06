precision mediump float;

varying vec2 texCoord;
varying vec4 textureContributions;

uniform sampler2D TexturesIn[4];

void main(void) {
    vec4 texel0 = texture2D(TexturesIn[0], texCoord);
    vec4 texel1 = texture2D(TexturesIn[1], texCoord);
    vec4 texel2 = texture2D(TexturesIn[2], texCoord);
    vec4 texel3 = texture2D(TexturesIn[3], texCoord);
    
    gl_FragColor = texel0 * textureContributions.x + texel1 * textureContributions.y + texel2 * textureContributions.z + texel3 * textureContributions.w;
}