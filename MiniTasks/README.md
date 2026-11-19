# MiniTasks v2

## 1. Descripción

MiniTasks es una aplicación de gestión de tareas desarrollada con Swift y SwiftUI como parte del programa de prácticas iOS SFY.

Esta segunda versión tiene como objetivo refactorizar la estructura interna de la aplicación, separando las distintas responsabilidades para conseguir un código más organizado, fácil de mantener y sencillo de probar.

La aplicación permite crear, consultar, editar, completar y eliminar tareas.

## 2. Objetivos de la refactorización

- Separar la interfaz visual de la lógica de la aplicación.
- Organizar los datos y las operaciones de acceso a ellos.
- Aplicar una estructura basada en MVVM.
- Utilizar protocolos para separar la gestión de datos de su implementación.
- Facilitar las pruebas mediante la inyección de dependencias.
- Mantener el comportamiento funcional de la versión anterior.

## 3. Funcionalidades

- **Listado de tareas:** muestra el título, la descripción, la prioridad y el estado de cada tarea.
- **Creación de tareas:** permite añadir tareas mediante un formulario.
- **Edición de tareas:** permite modificar una tarea existente sin crear duplicados.
- **Eliminación de tareas:** permite eliminar tareas desde su pantalla de detalle, con confirmación.
- **Gestión del estado:** permite marcar las tareas como pendientes o completadas.
- **Prioridades:** cada tarea puede tener prioridad baja, media o alta.
- **Filtros:** permite mostrar todas las tareas, únicamente las pendientes o únicamente las completadas.
- **Búsqueda:** permite buscar tareas por título o descripción.
- **Validación:** impide guardar tareas sin título y muestra un mensaje de error.
- **Estados vacíos:** informa cuando no hay tareas que coincidan con el filtro o la búsqueda.

## 4. Arquitectura y organización del proyecto

La aplicación utiliza una organización basada en MVVM, separando las responsabilidades en diferentes carpetas.

### Models

Contiene las estructuras que representan los datos de la aplicación.

- `TaskItem.swift`: define una tarea, sus propiedades, prioridades y filtros.

### Views

Contiene las pantallas y componentes visuales de la aplicación.

- `ContentView.swift`: pantalla principal, listado, búsqueda, filtros y navegación.
- `TaskDetailView.swift`: muestra los detalles de una tarea.
- `TaskFormView.swift`: permite crear y editar tareas.
- `TaskRowView.swift`: representa una tarea dentro del listado.

### ViewModels

Contiene la lógica que gestiona la información y las acciones de la aplicación.

- `MiniTasksViewModel.swift`: carga, guarda, elimina y actualiza tareas. También gestiona los filtros, las búsquedas y comunica los errores a la interfaz.

### Data

Contiene los elementos encargados de gestionar el acceso a los datos.

- `TaskRepository.swift`: define mediante un protocolo las operaciones disponibles para gestionar las tareas.
- `InMemoryTaskRepository.swift`: implementa esas operaciones utilizando almacenamiento en memoria.

La utilización del protocolo permite sustituir la implementación actual por otra solución de almacenamiento en el futuro sin tener que modificar las pantallas.

### MiniTasksTests

Contiene las pruebas automatizadas del proyecto.

- `InMemoryTaskRepositoryTests.swift`: comprueba las operaciones de guardado y eliminación del repositorio.
- `MiniTasksViewModelTests.swift`: comprueba la carga de tareas, los filtros, el guardado, el cambio de estado, la eliminación y las búsquedas.

### Decisiones de arquitectura

La refactorización introduce un ViewModel para separar la lógica de la interfaz y un protocolo de repositorio para independizar la aplicación de la implementación del almacenamiento.

El repositorio se inyecta en el ViewModel mediante su inicializador, lo que permite utilizar diferentes implementaciones y facilita las pruebas automatizadas.

No se han añadido casos de uso (Use Cases), ya que las operaciones actuales no necesitan una capa adicional de abstracción.

## 5. Tecnologías y conceptos utilizados

- Swift.
- SwiftUI.
- Combine.
- Arquitectura MVVM.
- Modelos y vistas.
- `ObservableObject` y `@Published`.
- `@State` y `@StateObject`.
- Protocolos.
- Repositorios.
- Inyección de dependencias mediante inicializador.
- Gestión de errores con `throws` y `do-catch`.
- Pruebas unitarias con XCTest.
- Navegación mediante `NavigationStack` y `NavigationLink`.

## 6. Almacenamiento de datos

Las tareas se almacenan en memoria mediante `InMemoryTaskRepository`.

No se utiliza backend, API externa ni base de datos.

Los cambios se reflejan en la interfaz mientras la aplicación está en ejecución, pero los datos no se conservan al cerrar la aplicación.

La estructura permite incorporar otra implementación del protocolo `TaskRepository` en el futuro.

## 7. Pruebas automatizadas

Se han creado once pruebas unitarias utilizando XCTest.

**Pruebas del repositorio:**

- Comprobar que se puede guardar una tarea.
- Comprobar que se puede eliminar una tarea.
- Comprobar que se produce un error al eliminar una tarea inexistente.

**Pruebas del ViewModel:**

- Comprobar que carga las tareas iniciales.
- Comprobar el filtro de tareas pendientes.
- Comprobar el filtro de tareas completadas.
- Comprobar que se puede guardar una tarea.
- Comprobar que se puede cambiar el estado de una tarea.
- Comprobar que se puede eliminar una tarea.
- Comprobar que se pueden buscar tareas por título.
- Comprobar que se pueden buscar tareas por descripción.

Todas las pruebas implementadas se han ejecutado correctamente en Xcode.

## 8. Ejecución

1. Abrir el proyecto en Xcode.
2. Seleccionar un simulador de iOS compatible.
3. Ejecutar la aplicación.
4. Crear, consultar, editar, completar y eliminar tareas para comprobar su funcionamiento.

Para ejecutar las pruebas automatizadas, utilizar `Cmd + U` en Xcode.

## 9. Limitaciones y mejoras futuras

- Incorporar persistencia de datos para conservar las tareas entre ejecuciones.
- Implementar una nueva versión del repositorio utilizando una base de datos.
- Añadir ordenación de tareas.
- Ampliar las pruebas automatizadas.
- Revisar la accesibilidad, VoiceOver y Dynamic Type.

## Repositorio y Pull Request

- **Repositorio GitHub:** https://github.com/Aferreiro22/MiniTasks
- **Pull Request:** [Refactor MiniTasks to MVVM architecture](PEGA_AQUI_EL_ENLACE_DE_LA_PR)   https://github.com/Aferreiro22/MiniTasks/pull/1
