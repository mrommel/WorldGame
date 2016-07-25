attribute vec4 texPosition;
attribute vec4 texSourceColor;

varying vec4 DestinationColor;

attribute vec2 texTexCoordIn;
varying vec2 TexCoordOut;

void main(void) {
    DestinationColor = texSourceColor;
    gl_Position = texPosition;
    TexCoordOut = texTexCoordIn;
}