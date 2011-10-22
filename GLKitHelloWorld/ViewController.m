//
//  ViewController.m
//  GLKitHelloWorld
//
//  Created by Ivan Leider on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
  UNIFORM_MODELVIEWPROJECTION_MATRIX,
  UNIFORM_NORMAL_MATRIX,
  NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
  ATTRIB_VERTEX,
  ATTRIB_NORMAL,
  NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
  // La disposicion de los datos es:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  // son 6 caras y cada cara esta formada por dos triangulos (tres vertices por cada triangulo * 2 triangulos por cara = 6 vertices por cara)
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
  
  0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
  
  -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
  
  -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
  
  0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
  
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@implementation ViewController

@synthesize context = _context;
@synthesize effect = _effect;

- (void)dealloc
{
  [_context release];
  [_effect release];
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // creamos el contexto EAGL
  self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];
  
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  // asignamos el contexto a nuestra vista
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  
  //vamos a usar el "depth buffer" para manejar prfundidad
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [self setupGL];
}

- (void)viewDidUnload
{    
  [super viewDidUnload];
  
  [self tearDownGL];
  
  // borra el contexto
  if ([EAGLContext currentContext] == self.context) {
    [EAGLContext setCurrentContext:nil];
  }
  self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void)setupGL
{
  //activamos el contexto
  [EAGLContext setCurrentContext:self.context];
  
  // carga, compila y enalaza los shaders
  [self loadShaders];
  
  // creamos el efecto
  self.effect = [[[GLKBaseEffect alloc] init] autorelease];
  //activamos una luz en el efecto (roja)
  self.effect.light0.enabled = GL_TRUE;
  self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
  
  //activamos el estado para manejar profundidad
  glEnable(GL_DEPTH_TEST);
  
  // Open GL admite "extensiones": funcionalidad que no necesariamente esta implementada por todos los vendors
  // Es posible preguntarle a Open GL cuales son las extensiones disponibles
  // Las extensiones en general pueden ser invocadas a traves de APIs con sufijos
  // AGL = Apple, OES = Khronos Group, etc
  
  //CREAMOS LA GEOMETRIA
  
  // Existen varias tecnicas para cargar geometrias
  // Los principales atributos que podemos considerar para cada vertice son: 
  //  - posicion (xyz)
  //  - coordenadas de la textura (st)
  //  - color (rgba)
  //  - normal (ijk)
  // en nuestro ejemplo pasaremos la posicion y la normal, ya que no usaremos texturas y el color estara dado por la luz
  
  // Open GL admite que los atributos sean pasados como "struct of arrays" o como "array of structs"
  // struct of arrays [POS1, POS2, POS3] [NOR1, NOR2, NOR3]
  // array of structs [POS1, NOR1, POS2, NOR2, POS3, NOR3] <- en general es mas eficiente
  
  // Es posible copiar los datos de los vertices antes de cada llamada, pero eso es ineficiente
  // Conviene generar un "VBO" o Vertex Buffer Object para que Open GL maneje los datos, tambien teniendo en cuenta 
  //   una "pista" que proveemos para decir cuanto varia nuestra geometria en el tiempo, en este caso GL_STATIC_DRAW = no cambia
  // Estas tres llamadas generan, asignan y llenan un buffer con nuestra geometria
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);

  
  // Ahora bien, cuando dibujemos nuestra geometria deberemos pasar los atributos de los vertices a nuestro programa
  // eso implica que para cada tipo de atributo deberemos llamar una secuencia de tipo
  // enlazarBuffer -> apuntarElBufferALosDatos -> encenderElEstadoDeEsteAtributo
  // o mejor... glBindBuffer -> glVertexAttribPointer -> glEnableVertexAttribArray
  // en nuestro caso hay que hacer esas tres llamadas para las posiciones y las normales
  // ¡Pero las llamadas son siempre las mismas!
  
  // Para mejorar la eficiencia de este aspecto existe una extension llamada OES_vertex_array_object
  // o "VAO" en la jerga
  // Lo que vamos a hacer en las siguientes lineas es generar un VAO, enlazarlo de modo que las llamadas
  // subsiguientes hagan referencia al mismo, encenderemos cada uno de los estados de nuestros atributos
  // y apuntaremos las posiciones del VAO al VBO con sus respectivos offsets y strides
  
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);

  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
  
  // desenlazamos el VAO
  glBindVertexArrayOES(0);

  // desenlazamos el VBO -> esto no viene en el template, pero es buena costumbre
  glBindBuffer(GL_ARRAY_BUFFER, 0);

}

- (void)tearDownGL
{
  //activamos el contexto
  [EAGLContext setCurrentContext:self.context];

  //borramos la geometria
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteVertexArraysOES(1, &_vertexArray);
  
  //borramos el efecto
  self.effect = nil;
  
  //borramos el programa
  if (_program) {
    glDeleteProgram(_program);
    _program = 0;
  }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  // logica: calcular que tenemos que dibujar
  // en nuestro caso se trata de calcular las transformaciones a la geometria
  // (girar)
  
  // debemos actualizar dos calculos separados
  // uno para cada cubo (uno para el efecto y otro para el programa)
  
  //calculos comunes
  
  //aspect ratio de la vista
  float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
  
  // camara
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);

  // aleja los objetos
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
  // rota los objetos alrededor del centro de la escena sobre el eje Y
  baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
  
  //EMPEZAMOS CON EL CUBO DEL EFECTO

  // asignamos la matriz de la camara
  self.effect.transform.projectionMatrix = projectionMatrix;
  
  // aleja un poco mas el cubo
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
  // rota sobre todos los ejes
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  // combina las transformacion "intrinseca" con la transformacion del "mundo"
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.effect.transform.modelviewMatrix = modelViewMatrix;
  
  //SEGUIMOS CON EL CUBO DEL PROGRAMA
  
  // acerca un poco mas el cubo
  modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
  // rota sobre todos los ejes
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  // combina las transformacion "intrinseca" con la transformacion del "mundo"
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  // asignamos las normales
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  
  // asignamos la matriz de la camara
  _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
  
  // incrementamos el angulo de rotacion 
  // (de manera proporcional al tiempo de actualizacion para mantener la velocidad constante en todos los disposivos)
  _rotation += self.timeSinceLastUpdate * 0.5f;
}


// DIBUJAMOS!!!!!!!! (aunque no lo creais)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  //pintamos el fondo de gris
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  //cargamos el "estado" de la geometria
  glBindVertexArrayOES(_vertexArray);
  
  // vamos dibujar...
  
  // activa el efecto (esto equivale a activar un programa)
  [self.effect prepareToDraw];
  
  //DIBUJAMOS!!!! un cubo
  glDrawArrays(GL_TRIANGLES, 0, 36);
  
  // activamos el otro programa (el que hemos cargado de archivos)
  glUseProgram(_program);
  
  // pasamos los parametros "uniform" al shader
  glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
  
  //DIBUJAMOS!!!! el otro cubo
  glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark -  OpenGL ES 2 shader compilation

//carga los shaders desde dos archivos
- (BOOL)loadShaders
{
  //"handles" para el vertex shader y el fragment shader
  GLuint vertShader, fragShader;
  //path de los archivos que contienen los shaders
  NSString *vertShaderPathname, *fragShaderPathname;
  
  // Crea el programa
  _program = glCreateProgram();
  
  // lee, crea y compila el vertex shader, devuelve el handle por parametro
  vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
  if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
    NSLog(@"Failed to compile vertex shader");
    return NO;
  }
  
  // lee, crea y compila el fragment shader, devuelve el handle por parametro
  fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
  if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
    NSLog(@"Failed to compile fragment shader");
    return NO;
  }
  
  // Vincula el vertex shader con el programa
  glAttachShader(_program, vertShader);
  
  // Vincula el fragment shader con el programa
  glAttachShader(_program, fragShader);
  
  // Asigna las posiciones en las que seran pasados los parametros (atributos) al programa
  // Esto debe hacerse antes de enlazar (link) el programa
  glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
  glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
  
  // Enlaza rl programa (link)
  if (![self linkProgram:_program]) {
    NSLog(@"Failed to link program: %d", _program);
    
    if (vertShader) {
      glDeleteShader(vertShader);
      vertShader = 0;
    }
    if (fragShader) {
      glDeleteShader(fragShader);
      fragShader = 0;
    }
    if (_program) {
      glDeleteProgram(_program);
      _program = 0;
    }
    
    return NO;
  }
  
  // Obtiene las direcciones de los parametros "uniform"
  uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
  uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
  
  // Descarta los shaders (ya no hacen falta porque estan enlazados en el programa)
  if (vertShader) {
    glDetachShader(_program, vertShader);
    glDeleteShader(vertShader);
  }
  if (fragShader) {
    glDetachShader(_program, fragShader);
    glDeleteShader(fragShader);
  }
  
  return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
  GLint status;
  const GLchar *source;
  
  source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
  if (!source) {
    NSLog(@"Failed to load vertex shader");
    return NO;
  }
  
  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);
  
#if defined(DEBUG)
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    NSLog(@"Shader compile log:\n%s", log);
    free(log);
  }
#endif
  
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0) {
    glDeleteShader(*shader);
    return NO;
  }
  
  return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;
  glLinkProgram(prog);
  
#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif
  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;
  
  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }
  
  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

@end
