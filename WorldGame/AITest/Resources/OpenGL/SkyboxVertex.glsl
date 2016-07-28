attribute vec4 Position; // 1
attribute vec4 SourceColor; // 2

varying vec4 DestinationColor; // 3

uniform mat4 Projection;
uniform mat4 ModelView;
uniform mat4 ModelMatrix;

attribute vec2 TexCoordIn;
varying vec2 texCoord;

void main(void) { // 4
    DestinationColor = SourceColor; // 5
    gl_Position = Projection * ModelView * Position;
    texCoord = TexCoordIn;
}