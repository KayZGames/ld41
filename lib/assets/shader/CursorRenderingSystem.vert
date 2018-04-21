#version 300 es

uniform mat4 uViewProjectionMatrix;
in vec2 pos;

void main() {
	gl_Position = uViewProjectionMatrix * vec4(pos, -0.1, 1.0);
}
