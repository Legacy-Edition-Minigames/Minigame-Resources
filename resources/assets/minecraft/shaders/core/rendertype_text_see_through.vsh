#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexColor = Color;
    texCoord0 = UV0;

    if (Color == vec4(78/255., 92/255., 36/255., Color.a)) {
        vertexColor = vec4(255/255., 255/255., 255/255., Color.a);
    }
}
