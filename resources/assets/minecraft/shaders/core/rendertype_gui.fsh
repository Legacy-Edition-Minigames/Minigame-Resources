#version 150
in vec4 vertexColor;
flat in vec2 flatCorner;
in vec2 Pos1;
in vec2 Pos2;
in vec4 Coords;
in vec2 position;
uniform vec4 ColorModulator;
uniform mat4 ProjMat;
out vec4 fragColor;
vec4 colors[9] = vec4[](
    vec4(0),
    vec4(7, 8, 27, 255) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255,
    vec4(28, 32, 93, 210) / 255
);
int bitmap[64] = int[](
    0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 1, 1, 9, 9, 9, 9,
    0, 1, 9, 9, 9, 9, 9, 9,
    1, 1, 9, 9, 9, 9, 9, 9,
    1, 9, 9, 9, 9, 9, 9, 9,
    1, 9, 9, 9, 9, 9, 9, 9,
    1, 9, 9, 9, 9, 9, 9, 9,
    1, 9, 9, 9, 9, 9, 9, 9
);
void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
     if (ProjMat[3][0] == -1.0 && color.g*255.0 == 16.0 && color.b*255.0 == 16.0 && color.r*255.0 == 16.0){
        discard;
    }
    if (flatCorner != vec2(-1))
    {
        vec2 APos1 = Pos1;
        vec2 APos2 = Pos2;
        APos1 = round(APos1 / (flatCorner.x == 0 ? 1 - Coords.z : 1 - Coords.w));
        APos2 = round(APos2 / (flatCorner.x == 0 ? Coords.w : Coords.z));
        ivec2 res = ivec2(abs(APos1 - APos2)) - 1;
        ivec2 stp = ivec2(min(APos1, APos2));
        ivec2 pos = ivec2(floor(position)) - stp;
        vec4 col = vec4(28, 32, 93, 210) / 255.0;
        ivec2 corner = min(pos, res - pos);
        if (res.x > 1000)
        {
            discard;
        }
        else
        if (corner.x < 8 && corner.y < 8)
        {
            int bit = bitmap[corner.y * 8 + corner.x];
            if (bit == 0)
                discard;
            if (bit != 9)
                col = colors[bit];
        }
        else if (corner.x == 0)
            col = colors[1];
        else if (corner.y == 0)
            col = colors[1];
        fragColor = col;

    }
}
