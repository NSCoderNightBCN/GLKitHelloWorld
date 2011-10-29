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

GLfloat gCubeVertexData[288] = 
{
  // La disposicion de los datos es:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  // son 6 caras y cada cara esta formada por dos triangulos (tres vertices por cada triangulo * 2 triangulos por cara = 6 vertices por cara)
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,      1.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,      1.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,      0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,      0.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,      0.0f, 1.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,      1.0f, 1.0f,
  
  0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,      1.0f, 1.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,      0.0f, 1.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,      1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,      1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,      0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,      0.0f, 0.0f,
  
  -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,      1.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,      0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,      1.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,      1.0f, 1.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,      0.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,      0.0f, 1.0f,
  
  -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,      1.0f, 1.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,      0.0f, 1.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,      1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,      1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,      0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,      0.0f, 0.0f,
  
  0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,      1.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,      0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,      1.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,      1.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,      0.0f, 1.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,      0.0f, 0.0f,
  
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,      0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,      1.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,      0.0f, 1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,      0.0f, 1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,      1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,      1.0f, 1.0f
};

@interface ViewController ()
@property (nonatomic, retain) GLKTextureInfo *texture;
@property (atomic, assign) BOOL loadingTexture;
@property (assign, nonatomic) BOOL gcdEnabled;

- (void)switchTextures;

@end

@implementation ViewController

@synthesize frameRateLabel = _frameRateLabel;
@synthesize enableGCDButton = _enableGCDButton;
@synthesize context = _context;
@synthesize effect = _effect;
@synthesize texture;
@synthesize loadingTexture;
@synthesize gcdEnabled = _gcdEnabled;

- (void)dealloc
{
  [texture release];
  [_context release];
  [_effect release];
  [_frameRateLabel release];
  [_enableGCDButton release];
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.gcdEnabled = NO;
  self.preferredFramesPerSecond = _fps = 60;
  _textIndex = 1;
  
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
  
  [NSTimer scheduledTimerWithTimeInterval:3 target:self 
                                 selector:@selector(switchTextures) 
                                 userInfo:nil 
                                  repeats:YES];
}

- (void)viewDidUnload
{    
  [self setFrameRateLabel:nil];
  [self setEnableGCDButton:nil];
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
  
  // creamos el efecto
  self.effect = [[[GLKBaseEffect alloc] init] autorelease];
  //activamos una luz en el efecto (roja)
  self.effect.light0.enabled = GL_TRUE;
//  self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
  
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
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));

  glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
  glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));

  // desenlazamos el VAO
  glBindVertexArrayOES(0);

  // desenlazamos el VBO -> esto no viene en el template, pero es buena costumbre
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  
  NSError *error;
  self.texture = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tex.png" ofType:nil] 
                                                     options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft]  
                                                       error:&error];
  if (!texture) {
    NSLog(@"error loading texture: %@", [error description]);
  }
  
  self.effect.texture2d0.name = self.texture.name;
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
}

- (IBAction)enableGCD:(id)sender
{
  NSString *buttonTitle;
  
  // Cambiamos el flag que activa/desactiva las funciones de GCD
  self.gcdEnabled = !self.gcdEnabled;
  
  // Actualizamos el título del botón
  buttonTitle = (self.gcdEnabled) ? @"Desactivar GCD" : @"Activar GCD";
  [self.enableGCDButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)switchTextures
{
  // Si aún se está ejecutando una operación de carga de texturas, abandonamos
  if (self.loadingTexture) {
    return;
  }
  self.loadingTexture = YES;


  void (^loadTextureBlock)(void);
  
  // ATENCIÓN! Aquí sólo definimos el bloque, no lo ejecutamos!
  loadTextureBlock = ^{
    
    // La documentación de GLKTextureLoader nos exige que, antes de cargar una
    // textura de manera síncrona, activemos el contexto OpenGL a usar.
    [EAGLContext setCurrentContext:self.context];
    
    NSError *error;
    NSString *textFileName;
    
    // Cargamos una imagen distinta cada cez (de las 5 disponibles)
    _textIndex = (_textIndex == 5) ? 1 : _textIndex + 1;
    textFileName = [NSString stringWithFormat:@"tex%lu.png", _textIndex];
    self.texture = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:textFileName ofType:nil] 
                                                       options:NULL 
                                                         error:&error];
    if (!texture) {
      NSLog(@"error loading texture: %@", [error description]);
    }
    
    void (^assignTextureBlock)(void);
    
    // Recordamos que aquí sólo definimos el boque, se ejecuta más abajo
    assignTextureBlock = ^{

      // Como buenos samaritanos, tenemos que volver a activar el contexto
      [EAGLContext setCurrentContext:self.context];
      
      // Eliminamos la textura actual
      GLuint tex = self.effect.texture2d0.name;
      glDeleteTextures(1, &tex);
      
      // Assignamos la nueva textura
      self.effect.texture2d0.name = self.texture.name;
      
      // Hemos terminado de cargar la textura, volvemos a permitir más cambios
      self.loadingTexture = NO; 
    };
    
    if (self.gcdEnabled)
    {
      dispatch_queue_t mainQueue = dispatch_get_main_queue();
      dispatch_async(mainQueue, assignTextureBlock);
    }
    else
      assignTextureBlock();
  };
  
  // Aquí sí lo ejecutamos (con GCD o no dependiendo del flag)
  if (self.gcdEnabled)
  {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, loadTextureBlock);
  }
  else
    loadTextureBlock();
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  // logica: calcular que tenemos que dibujar
  // en nuestro caso se trata de calcular las transformaciones a la geometria
  // (girar)
  
  //calculos comunes
  
  //aspect ratio de la vista
  float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
  
  // camara
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);

  // aleja los objetos
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.0f);
  
  // asignamos la matriz de la camara
  self.effect.transform.projectionMatrix = projectionMatrix;
  
  // aleja un poco mas el cubo
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
  // rota sobre todos los ejes
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  // combina las transformacion "intrinseca" con la transformacion del "mundo"
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.effect.transform.modelviewMatrix = modelViewMatrix;

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
  
  // Desgraciadamente no podemos fiarnos de la propiedad @framesPerSecond de
  // GLKViewController porqué parece no cambiar nunca. Por lo tanto vamos a 
  // calcularlo por nuestra cuenta.
  _acc += self.timeSinceLastDraw;
  if (self.framesDisplayed > 1 && (self.framesDisplayed % 30) == 0)
  {
    _fps = (_fps + 30.0/_acc)/2.0;
    _acc = 0.0;
    self.frameRateLabel.text = [NSString stringWithFormat:@"Frame Rate: %.1f", _fps];
  }
}

@end
