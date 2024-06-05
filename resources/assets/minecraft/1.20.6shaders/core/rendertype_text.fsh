#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in float fx;
in vec2 uv;

out vec4 fragColor;

vec4 panorama() {
    if (uv.x <= 1.0 || uv.x > 206.0) return vec4(0.0);

    vec2 texSize = vec2(256.0);
    vec2 texCoords = texCoord0 * texSize;
    texCoords.y = clamp(texCoords.y, 0.0, 143.0);

    vec2 s = fract(texCoords) * 2.0 - 1.0;
    s.x = sign(s.x) * pow(abs(s.x), 1.1);
    s.y = sign(s.y) * pow(abs(s.y), 1.1);
    s = s * 0.5 + 0.5;

    texCoords /= texSize;
    vec4 sample0 = texture(Sampler0, texCoords);
    vec4 sample1 = texture(Sampler0, texCoords + vec2(1.0, 0.0) / texSize);
    vec4 sample2 = texture(Sampler0, texCoords + vec2(0.0, 1.0) / texSize);
    vec4 sample3 = texture(Sampler0, texCoords + vec2(1.0, 1.0) / texSize);

    return mix(mix(sample0, sample1, s.x), mix(sample2, sample3, s.x), s.y);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    int control = int(fx + 0.5);
    if (control == 1) color = panorama();
    color *= vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
