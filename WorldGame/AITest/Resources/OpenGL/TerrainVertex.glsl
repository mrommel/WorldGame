attribute vec4 Position; // 1
attribute vec4 SourceColor; // 2

varying vec4 DestinationColor; // 3

uniform mat4 Projection;
uniform mat4 ModelView;
uniform mat4 ModelMatrix;

attribute vec2 TexCoordIn;
varying vec2 texCoord;

attribute vec4 TextureContributionsIn;
varying vec4 textureContributions;

// used for clipping
uniform vec4 u_clipPlane; // in
varying float v_clipDistance; // out

void main(void) { // 4
    DestinationColor = SourceColor; // 5
    gl_Position = Projection * ModelView * Position;
    texCoord = TexCoordIn;
    textureContributions = TextureContributionsIn;
    
    //v_clipDistance = dot(ModelMatrix * Position, u_clipPlane);
    v_clipDistance = dot(Position, u_clipPlane);
}