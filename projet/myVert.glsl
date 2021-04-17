uniform mat4 transformMatrix;
uniform mat4 texMatrix;
uniform bool bicycle;
uniform bool picnic;


attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec2 heat;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transformMatrix * position;

  float red = color[0];
  float blue = color[1];
  float green = color[2];

  if (heat[0] < 0.9 && bicycle)
    blue = color[1]+2-2*heat[0];


  if (heat[1] < 0.9 && picnic)
    green = color[2]+2-2*heat[1];

  vertColor = vec4(red, green, blue, color[3]);

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
