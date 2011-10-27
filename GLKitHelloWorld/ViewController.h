//
//  ViewController.h
//  GLKitHelloWorld
//
//  Created by Ivan Leider on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


// Se dibujan dos cubos que rotan alrededor del eje Y y que a su vez rotan sobre todos sus propios ejes
// Uno de los cubos (el rojo) se dibuja usando las APIs GLKit, el otro (azul) se dibuja usando las APIs Open GL

@interface ViewController : GLKViewController
{
  // este parametro variara con cada ciclo
  float _rotation;
  // identificador del VAO
  GLuint _vertexArray;
  // identificador del VBO
  GLuint _vertexBuffer;
  
  // índice de la imagen a cargar
  NSUInteger _textIndex;
}

// contexto EAGL
@property (strong, nonatomic) EAGLContext *context;

// shader preprogramado (se aplica al cubo rojo)
@property (strong, nonatomic) GLKBaseEffect *effect;

// "activa" el contexto Open GL
// carga, compila y enalaza los shaders
// configura el "effect"
// activa el estado de control de profundidad (GL_DEPTH_TEST)
// carga la geometria
- (void)setupGL;

// "activa" el contexto Open GL
// borra el programa
// borra la geometria
// borra el "effect"
- (void)tearDownGL;

- (IBAction)enableGCD:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *frameRateLabel;
@property (retain, nonatomic) IBOutlet UIButton *enableGCDButton;

@end
