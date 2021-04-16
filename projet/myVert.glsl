uniform mat4 transformMatrix;
uniform mat4 texMatrix;
uniform bool on_off;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec2 heat;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transformMatrix * position;

  if (on_off) {
    float red = color[0];
    float blue;
    if (heat[1] > 0.9) {
      blue = color[1];
    } else {
      blue = color[1]+2-2*heat[1];
    }
    float green;
    if (heat[0] > 0.9) {
      green = color[2];
    } else {
      green = color[2]+2-2*heat[0];
    }
    vertColor = vec4(red, green, blue, color[3]);
  } else {
    vertColor = color;
  }

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
