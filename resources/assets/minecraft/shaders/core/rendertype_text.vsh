#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    //0.03/0 for /title text, bossbar name, world/server selection name/description text, resourcepack selection "Available" and "Selected" text.
    //100.03/100 for Chat display, Recipe book search text
    if (Color == vec4(250/255., 250/255., 250/255., Color.a) && (Position.z == 0.03 || Position.z == 100.03)) {
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0); // remove color from no shadow marker
    } else if (Color == vec4(62/255., 62/255., 62/255., Color.a) && (Position.z == 0 || Position.z == 100)) {
        vertexColor = vec4(0); // remove shadow
    }
}
