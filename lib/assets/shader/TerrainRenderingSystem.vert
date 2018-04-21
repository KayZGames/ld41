#version 300 es

uniform mat4 uViewProjectionMatrix;
in vec2 pos;
in vec3 color;
out vec3 fragColor;

void main() {
//	gl_Position = mat4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0) * vec4(pos, 0.0, 1.0);
	gl_Position = uViewProjectionMatrix * vec4(pos, 0.0, 1.0);
	fragColor = color;
}
