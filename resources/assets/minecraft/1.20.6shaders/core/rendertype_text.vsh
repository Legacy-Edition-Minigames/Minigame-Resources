#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float fx;
out vec2 uv;

vec2 corners[4] = vec2[](
    vec2(-1.0,  1.0),
    vec2(-1.0, -1.0),
    vec2( 1.0, -1.0),
    vec2( 1.0,  1.0)
);

void main() {
    ivec3 control = ivec3(0);
    fx = 0.0;
    if (Position.y > 3200.0) control = ivec3(Color.rgb * 255.0 + 0.5); // Has very far offset to indicate gui object.
    if ((control.r < 4 || control.g < 4 || control.b < 4) && control != ivec3(0)) { // Is in control color range, but not shadow.
        gl_Position = ProjMat * ModelViewMat * vec4(Position + vec3(0.0, -6400.0, 0.0), 1.0);
        vertexColor = vec4(1.0);
        /* */if (control == ivec3(1, 0, 0)) gl_Position.xy += vec2(-1.0,  0.0); // #010000 TOP LEFT
        else if (control == ivec3(2, 0, 0)) gl_Position.xy += vec2( 0.0,  0.0); // #020000 TOP CENTER
        else if (control == ivec3(3, 0, 0)) gl_Position.xy += vec2( 1.0,  0.0); // #030000 TOP RIGHT
        else if (control == ivec3(0, 1, 0)) gl_Position.xy += vec2(-1.0, -1.0); // #000100 CENTER LEFT
        else if (control == ivec3(0, 2, 0)) gl_Position.xy += vec2( 0.0, -1.0); // #000200 CENTER CENTER
        else if (control == ivec3(0, 3, 0)) gl_Position.xy += vec2( 1.0, -1.0); // #000300 CENTER RIGHT
        else if (control == ivec3(0, 0, 1)) gl_Position.xy += vec2(-1.0, -2.0); // #000001 BOTTOM LEFT
        else if (control == ivec3(0, 0, 2)) gl_Position.xy += vec2( 0.0, -2.0); // #000002 BOTTOM CENTER
        else if (control == ivec3(0, 0, 3)) gl_Position.xy += vec2( 1.0, -2.0); // #000003 BOTTOM RIGHT

        else if (control == ivec3(2, 1, 0)) {                                   // #020100 FILL SCREEN
            gl_Position = vec4(corners[gl_VertexID % 4], 0.0, 1.0);
        }
        else if (control == ivec3(2, 2, 0)) {                                   // #020200 PANORAMA
            fx = 1.0;
            float pos = Position.x - GameTime * 8200.0;
            if (gl_VertexID % 4 > 1) pos -= 205.0;
            pos = mod(pos, 3280.0);
            vec2 minPos = (ProjMat * ModelViewMat * vec4(pos + 0.0, 0.0, 0.0, 1.0)).xy;
            vec2 maxPos = (ProjMat * ModelViewMat * vec4(pos + 205.0, 144.0, 0.0, 1.0)).xy;
            float scale = 2.0 / (1.0 - maxPos.y);
            minPos.y += -1.0;
            maxPos.y += -1.0;
            minPos *= scale;
            maxPos *= scale;
            gl_Position = vec4(vec3(0.0), 1.0);
            switch (gl_VertexID % 4) {
                case 0:
                gl_Position.xy = minPos;
                uv = vec2(0.0, 144.0);
                break;
                case 1:
                gl_Position.xy = vec2(minPos.x, maxPos.y);
                uv = vec2(0.0, 0.0);
                break;
                case 2:
                gl_Position.xy = maxPos;
                uv = vec2(207.0, 0.0);
                break;
                case 3:
                gl_Position.xy = vec2(maxPos.x, minPos.y);
                uv = vec2(207.0, 144.0);
                break;
            }
            gl_Position.xy += vec2(-1.0, 1.0);
        }

        else if (control == ivec3(1, 1, 0)) gl_Position.xy += vec2(-1.0, -1.0); // #010100 GLIDE LEFT [NOT COMPLETE!]
        else if (control == ivec3(1, 2, 0)) gl_Position.xy += vec2( 1.0, -1.0); // #010200 GLIDE RIGHT [NOT COMPLETE!]
    }
    else { // Normal text.
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    }
    vertexDistance = fog_distance(Position, FogShape);
    texCoord0 = UV0;
}
