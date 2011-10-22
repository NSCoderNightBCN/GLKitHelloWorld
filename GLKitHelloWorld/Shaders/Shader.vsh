//
//  Shader.vsh
//  GLKitHelloWorld
//
//  Created by Ivan Leider on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// este codigo se ejecuta una vez para cada vertice

// el programa nos pasara dos parametros:
// la posicion del vertice (vector de cuatro posiciones)
// la normal del vertice (vector de tres posiciones, representa la orientacion del plano)
attribute vec4 position;
attribute vec3 normal;

// este es un parametro que sera pasado al fragment shader
varying lowp vec4 colorVarying;

// el programa nos pasara dos parametros
// son "uniform" porque son constantes para todos los vertices
// modelViewProjectionMatrix representa la matriz de transformacion
// que sera aplicada a nuestros "objetos", representa la combinacion de la camara y el "mundo" 
// normalMatrix
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
  // la funcion normalize devuelve un vector unitario
  
  // la direccion en la que miramos
  vec3 eyeNormal = normalize(normalMatrix * normal);
  
  // definimos las coordenadas de una luz
  vec3 lightPosition = vec3(0.0, 0.0, 1.0);
  
  // definimos el color de la luz (azul)
  vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
  
  // multiplicamos (dot = producto interno) la direccion en la que mirammos
  // con la posicion de la luz
  // de esta maner obtenemos un "indice" que nos permite calcular
  // con cuanta intensidad se vera el color
  float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
               
  // multiplicamos (producto vectorial) el color con el resultado 
  // de la operacion anterior
  colorVarying = diffuseColor * nDotVP;
  
  // gl_Position es una variable especial definida por Open GL
  // representa la "output position" del vertice
  
  // la posicion del vertice es su posicion mutiplicada
  // con la matriz modelViewProjection
  gl_Position = modelViewProjectionMatrix * position;
}
