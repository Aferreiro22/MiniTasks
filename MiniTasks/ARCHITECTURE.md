
# MiniTasks v2 — Documentación de arquitectura

## 1. Introducción

MiniTasks v2 es una refactorización de la aplicación MiniTasks original, desarrollada con Swift y SwiftUI.

El objetivo de esta versión es mejorar la organización interna del proyecto mediante la separación de responsabilidades, facilitando el mantenimiento del código y las pruebas de sus componentes.

Para ello, se ha utilizado el patrón MVVM y se ha introducido un repositorio en memoria que permite separar la gestión de los datos de la lógica de presentación.

La refactorización mantiene las funcionalidades principales de la versión original.

## 2. Arquitectura inicial — MiniTasks v1

En la primera versión, la estructura del proyecto era sencilla y estaba formada principalmente por `ContentView.swift` y `MyApp.swift`.

La vista principal concentraba buena parte de la interfaz y de la gestión de las tareas.

### Diagrama Antes

```text
              ┌──────────────────────┐
              │      MyApp.swift     │
              │                      │
              │   Inicio aplicación  │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │     ContentView      │
              │                      │
              │  ┌────────────────┐  │
              │  │ Interfaz       │  │
              │  ├────────────────┤  │
              │  │ Estado         │  │
              │  ├────────────────┤  │
              │  │ Acciones       │  │
              │  ├────────────────┤  │
              │  │ Gestión tareas │  │
              │  └────────────────┘  │
              └──────────────────────┘
```

### Problema detectado

La principal dificultad era la concentración de responsabilidades en la vista principal.

Esta organización podía complicar el mantenimiento del código y dificultaba probar las operaciones de gestión de tareas de forma independiente a la interfaz.

Por ello, se decidió separar las responsabilidades utilizando una estructura basada en MVVM.

## 3. Arquitectura final — MiniTasks v2

En la segunda versión se han separado las responsabilidades en diferentes componentes.

La interfaz delega las operaciones al ViewModel, que se comunica con el repositorio mediante un protocolo.

### Diagrama Después

```text
              ┌──────────────────────┐
              │      MyApp.swift     │
              │                      │
              │   Inicio aplicación  │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │        VIEWS         │
              │                      │
              │    ContentView       │
              │    TaskDetailView    │
              │    TaskFormView      │
              │    TaskRowView       │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │      VIEWMODEL       │
              │                      │
              │ MiniTasksViewModel   │
              │                      │
              │ Estado y acciones    │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │    TASK REPOSITORY   │
              │                      │
              │       Protocolo      │
              │                      │
              │ fetchAll()           │
              │ save(_:)             │
              │ delete(id:)          │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │       DATA           │
              │                      │
              │ InMemoryTaskRepository│
              │                      │
              │ Almacenamiento       │
              │ en memoria           │
              └──────────────────────┘


       ┌──────────────────────┐
       │        MODEL         │
       │                      │
       │      TaskItem        │
       │                      │
       │ Datos de las tareas  │
       └──────────────────────┘


       ┌──────────────────────┐
       │        TESTS         │
       │                      │
       │ Repository Tests     │
       │ ViewModel Tests      │
       └──────────────────────┘
```

El modelo `TaskItem` es utilizado por las distintas partes de la aplicación para representar las tareas. Las pruebas unitarias comprueban de forma independiente el funcionamiento del repositorio y del ViewModel.

## 4. Responsabilidades de los componentes

### 4.1. Models

**Archivo:** `TaskItem.swift`

Contiene el modelo de datos de la aplicación.

`TaskItem` representa una tarea y almacena su identificador, título, descripción, prioridad y estado de finalización.

También contiene los tipos `Priority` y `TaskFilter`, utilizados para representar las prioridades y los filtros disponibles.

El modelo no depende de SwiftUI, por lo que puede utilizarse independientemente de la interfaz.

### 4.2. Views

**Carpeta:** `Views/`

Contiene las vistas encargadas de representar la información y permitir la interacción con el usuario.

- `ContentView.swift`: muestra el listado de tareas, los filtros y la búsqueda, y coordina la navegación.
- `TaskDetailView.swift`: muestra la información de una tarea y permite realizar acciones sobre ella.
- `TaskFormView.swift`: permite crear y editar tareas, validando que el título no esté vacío.
- `TaskRowView.swift`: representa cada tarea dentro del listado.

Las vistas se encargan principalmente de la presentación y delegan las operaciones de gestión de tareas al ViewModel.

### 4.3. ViewModels

**Archivo:** `MiniTasksViewModel.swift`

Gestiona el estado de la pantalla y las operaciones relacionadas con las tareas.

Sus responsabilidades principales son:

- Cargar las tareas.
- Aplicar filtros y búsquedas.
- Guardar y eliminar tareas.
- Cambiar el estado de finalización.
- Comunicar posibles errores a la interfaz.

Utiliza `ObservableObject` y `@Published` para notificar los cambios de estado a las vistas.

### 4.4. Data

**Carpeta:** `Data/`

Contiene los componentes encargados de gestionar el acceso a los datos.

**TaskRepository.swift**

Define el protocolo `TaskRepository`, que establece las operaciones disponibles para gestionar las tareas:

- Obtener todas las tareas.
- Guardar una tarea.
- Eliminar una tarea.

También define los errores que pueden producirse durante estas operaciones.

**InMemoryTaskRepository.swift**

Implementa el protocolo `TaskRepository` y almacena las tareas en memoria.

Esta implementación permite gestionar las tareas sin necesidad de utilizar una base de datos o un servicio externo.

### 4.5. Tests

**Carpeta:** `MiniTasksTests/`

Contiene las pruebas unitarias desarrolladas con XCTest.

Se han creado dos archivos:

- `InMemoryTaskRepositoryTests.swift`: comprueba las operaciones del repositorio, incluyendo el guardado y la eliminación de tareas y el tratamiento de errores.
- `MiniTasksViewModelTests.swift`: comprueba la carga de tareas, los filtros, las búsquedas y las operaciones principales del ViewModel.

El proyecto cuenta con 11 pruebas unitarias: 3 del repositorio y 8 del ViewModel.

## 5. Decisiones arquitectónicas

Durante la refactorización se han tomado las siguientes decisiones:

### 5.1. Utilización de MVVM

Se ha elegido MVVM para separar la interfaz de usuario de la gestión del estado y de las operaciones de la aplicación.

De esta manera, las vistas no necesitan concentrar toda la lógica relacionada con las tareas.

### 5.2. Introducción de un repositorio

Se ha creado el protocolo `TaskRepository` para establecer una separación entre el ViewModel y la implementación concreta que almacena las tareas.

Esto permite sustituir la implementación del repositorio en el futuro sin tener que modificar toda la lógica de presentación.

### 5.3. Inyección por inicializador

El repositorio se proporciona al ViewModel mediante su inicializador.

Esto permite utilizar distintas implementaciones del repositorio y facilita la realización de pruebas con datos controlados.

### 5.4. Gestión de errores

Las operaciones del repositorio utilizan errores mediante `throws`.

El ViewModel captura esos errores utilizando `do-catch` y comunica los problemas a la interfaz para que puedan mostrarse al usuario.

### 5.5. No utilización de Use Cases

No se ha considerado necesario introducir una capa de casos de uso (Use Cases).

Las operaciones actuales son suficientemente sencillas y pueden gestionarse desde el ViewModel y el repositorio sin añadir abstracciones innecesarias.

## 6. Límites conocidos

MiniTasks v2 mantiene algunas limitaciones que quedan fuera del alcance de esta refactorización:

- Los datos se almacenan únicamente en memoria.
- Las tareas no se conservan al cerrar la aplicación.
- No existe conexión con una API o un servicio externo.
- No se utiliza una base de datos persistente.
- Las pruebas unitarias cubren las operaciones principales, pero todavía podrían ampliarse.

## 7. Siguiente paso y posibles mejoras

Como posibles evoluciones del proyecto se plantean:

- Incorporar persistencia de datos para conservar las tareas entre sesiones.
- Crear una nueva implementación del repositorio que utilice almacenamiento persistente.
- Ampliar las pruebas unitarias.
- Incorporar nuevas opciones de ordenación y filtrado.
- Mejorar progresivamente la accesibilidad de la interfaz.

Estas mejoras quedan fuera del alcance de MiniTasks v2 y no se han implementado en esta entrega.

## 8. Conclusión

La refactorización de MiniTasks v2 permite disponer de una estructura más organizada y con responsabilidades mejor diferenciadas.

La introducción de MVVM, el protocolo de repositorio, la inyección por inicializador y las pruebas unitarias facilita el mantenimiento y la comprobación del funcionamiento de la aplicación.

Se han mantenido las funcionalidades principales de MiniTasks, evitando introducir capas o abstracciones que no aportasen un beneficio real al proyecto.
