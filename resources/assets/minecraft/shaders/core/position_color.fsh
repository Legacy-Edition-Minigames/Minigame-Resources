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
    vec4(50, 50, 50, 255) / 255,    //#323232
    vec4(235, 235, 235, 235) / 255, //#EBEBEB
    vec4(41, 56, 64, 222) / 255,    //#2A3840
    vec4(37, 49, 58, 210) / 255,    //#25313A
    vec4(35, 49, 55, 234) / 255,    //#233137
    vec4(37, 51, 58, 230) / 255,    //#25333A
    vec4(43, 57, 66, 217) / 255,    //#2B3942
    vec4(46, 63, 71, 210) / 255     //#2E3F47
);

int bitmap[64] = int[](
    0, 0, 2, 2, 2, 2, 2, 2,
    0, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 1, 1, 1, 1, 1,
    2, 2, 1, 5, 4, 7, 7, 7,
    2, 2, 1, 4, 3, 8, 8, 8,
    2, 2, 1, 7, 8, 9, 9, 9,
    2, 2, 1, 7, 8, 9, 9, 9,
    2, 2, 1, 7, 8, 9, 9, 9
);



void main() {
    vec4 color = vertexColor;

    if (color.a == 0.0) {
        discard;
    }

    fragColor = color * ColorModulator;


    // Removes shadow in GUIs' & Menus
    if (ProjMat[3][2] == -2.0 && color.g*255.0 == 16.0 && color.b*255.0 == 16.0 && color.r*255.0 == 16.0){
        discard;
    }

    // Fancy math stuff to find the tooltip from the vertex shader
    if (flatCorner != vec2(-1))
    {
        //Actual Pos
        vec2 APos1 = Pos1;
        vec2 APos2 = Pos2;
        APos1 = round(APos1 / (flatCorner.x == 0 ? 1 - Coords.z : 1 - Coords.w)); //Right-up corner
        APos2 = round(APos2 / (flatCorner.x == 0 ? Coords.w : Coords.z)); //Left-down corner

        ivec2 res = ivec2(abs(APos1 - APos2)) - 1; //Resolution of frame
        ivec2 stp = ivec2(min(APos1, APos2)); //Left-Up corner
        ivec2 pos = ivec2(floor(position)) - stp; //Position in frame

        vec4 col = vec4(46, 63, 71, 210) / 255.0;
        col.rgb -= max(1 - length((pos - res / 2.0) / res) * 2, 0) / 10;

        ivec2 corner = min(pos, res - pos);

        // Remove tooltip if too large (used for menus)
        if (res.x > 1000)
        {
            discard;
        }
        else // If the tooltip isnt too large, continue as normal.
        {
            if (corner.x < 8 && corner.y < 8)
            {
                int bit = bitmap[corner.y * 8 + corner.x]; 
                // due to glsl restrictions the *8  exists so the bitmap can be 2d. Why a 2d bitmap? no idea.
                if (bit == 0)
                    discard;
                if (bit != 9)
                    col = colors[bit];
            }
            // For the rest of the image find its location, and render the approptriate colour
            else if (corner.x == 0 || corner.x == 1)
                col = colors[2];
            else if (corner.x == 2)
                col = colors[1];
            else if (corner.x == 3)
                col = colors[7];
            else if (corner.x == 4)
                col = colors[8];
            else if (corner.y == 0 || corner.y == 1)
                col = colors[2];
            else if (corner.y == 2)
                col = colors[1];
            else if (corner.y == 3)
                col = colors[7];
            else if (corner.y == 4)
                col = colors[8];
        }


        // Final output of colours
        fragColor = col;
        
    }
}
