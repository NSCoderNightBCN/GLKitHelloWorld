//
//  ViewController.h
//  GLKitHelloWorld
//
//  Created by Ivan Leider on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController {
  // el identificador del programa formado por los shaders
  GLuint _program;
  
  // matriz de 4x4 que representa la transformacion del mundo y la camara
  GLKMatrix4 _modelViewProjectionMatrix;
  
  // matriz de 3x3 que representa las normales de las caras de los objetos
  GLKMatrix3 _normalMatrix;
  
  // este parametro variara con cada ciclo
  float _rotation;
  
  // identificador del VAO
  GLuint _vertexArray;
  // identificador del VBO
  GLuint _vertexBuffer;

}

// contexto EAGL
@property (strong, nonatomic) EAGLContext *context;

// shader preprogramado (se aplica al cubo rojo)
@property (strong, nonatomic) GLKBaseEffect *effect;

// "activa" el contexto Open GL
// carga, compila y enalaza los shaders
// configura el "effect"
// activa el estado GL_DEPTH_TEST (stencil buffer, mascara)
// carga la geometria
- (void)setupGL;

// "activa" el contexto Open GL
// borra el programa
// borra la geometria
// borra el "effect"
- (void)tearDownGL;

// metodos para
// cargar, compilar, enalazar y validar los shaders
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;


@end
