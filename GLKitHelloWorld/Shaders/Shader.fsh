//
//  Shader.fsh
//  GLKitHelloWorld
//
//  Created by Ivan Leider on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//el vertex shader nos pasara este parametro
//es un vector de cuatro posiciones de baja precision
varying lowp vec4 colorVarying;

void main()
{
  // gl_FragColor es una variable especial definida por Open GL
  // representa el "output color" del shader

  // en este caso el color va a ser igual al color que llega
  //  como parametro desde el vertex shader
  gl_FragColor = colorVarying;
}
