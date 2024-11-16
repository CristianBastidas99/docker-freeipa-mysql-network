# Docker Compose para Servidor MySQL y FreeIPA

Este proyecto contiene un `docker-compose` que configura un entorno de contenedores con MySQL, FreeIPA y un contenedor adicional para manejar reglas de firewall en la red interna. Incluye mapeo de volumen, inicialización de datos, y configuraciones de red.

### Contenidos

1. [Requisitos](#requisitos)
2. [Instrucciones](#instrucciones)
3. [Servicios](#servicios)
4. [Redes](#redes)
5. [Configuración de Keycloak](#configuración-de-keycloak)


---

### Requisitos

- Docker
- Docker Compose

### Instrucciones

1. Clona el repositorio o guarda el archivo `docker-compose.yml` en una carpeta local.
2. En tu archivo de hosts (`/etc/hosts` en Linux/macOS o `C:\Windows\System32\drivers\etc\hosts` en Windows), agrega la siguiente línea para mapear el dominio `ipa1.test.com`:

   ```plaintext
   127.0.0.1 ipa1.test.com
   ```

3. Ejecuta el siguiente comando para iniciar los contenedores:

   ```bash
   docker-compose up -d
   ```

### Servicios

#### 1. `persistencia` (MySQL)

- **Imagen**: `mysql:latest`
- **Configuración**:
  - Base de datos: `persistencia`
  - Usuario: `persistencia`
  - Contraseña: `persistencia-12345`
  - Contraseña de root: `persistencia-12345`
- **Volumen**: Mapea el directorio `./sql` para la inicialización de la base de datos en `/docker-entrypoint-initdb.d`.

#### 2. `freeipa` (Servidor FreeIPA)

- **Imagen**: `freeipa/freeipa-server:rocky-8-4.9.11`
- **Hostname**: `ipa1.test.com`
- **Puertos Expuestos**: 80, 443, 464, 88, 636, 389
- **Comando de Inicio**: `ipa-server-install` con el modo desatendido para el dominio `test.com`.
- **Configuración**:
  - Volumen mapeado para almacenamiento persistente de datos en `/var/lib/ipa-data`.

#### 3. `firewall`

- **Imagen**: `nicolaka/netshoot`
- **Capacidades**: Acceso extendido a `NET_ADMIN` y permisos `privileged` para configurar reglas de firewall.
- **Dependencias**: Inicia después de `freeipa`.
- **Puertos**: Expone el puerto 443 para tráfico externo.
- **Script de Configuración**: Ejecuta `setup_firewall.sh` (asegúrate de que el archivo tenga permisos de ejecución).

### Redes

- **internal_net**: Red interna entre todos los contenedores.
- **external_net**: Red externa a la que `firewall` tiene acceso.

---

## Configuración de Keycloak

### Acceder a Keycloak
1. Abre tu navegador y ve a `http://localhost:8081`.
2. Inicia sesión con las siguientes credenciales:
   - **Usuario**: `admin`
   - **Contraseña**: `admin123`

---

### Crear un nuevo *Realm*
1. En el menú de la izquierda, selecciona `Add realm`.
2. Ingresa el nombre del *realm* como `MyRealm` y guarda los cambios.

---

### Crear un nuevo usuario
1. En el menú de la izquierda, selecciona `Users` y luego `Add user`.
2. Ingresa un nombre de usuario y guarda los cambios.
3. En la pestaña `Credentials`:
   - Establece una contraseña para el usuario.
   - Asegúrate de desmarcar la opción `Temporary` para que la contraseña no expire.

---

### Crear un nuevo cliente
1. En el menú de la izquierda, selecciona `Clients` y luego `Create`.
2. Ingresa el **Client ID** como `my-client` y guarda los cambios.
3. En la pestaña `Settings`:
   - Establece **Valid Redirect URIs** a `https://www.keycloak.org/app/*`.
   - Establece **Web Origins** a `https://keycloak.org`.

---

### Configurar la federación de identidad con Google
1. En el menú de la izquierda, selecciona `Identity Providers` y luego `Add provider`.
2. Selecciona `Google` y completa los campos necesarios con la información de tu proyecto en Google Cloud Console:
   - **Client ID**: Obtén este dato desde Google Cloud Console.
   - **Client Secret**: También se obtiene desde Google Cloud Console.
3. Guarda los cambios.

---

### Probar la configuración
1. Abre tu navegador y ve a `http://localhost:8081/realms/MyRealm/account`.
2. Inicia sesión con las credenciales del usuario creado previamente.
3. Si configuraste correctamente la federación de identidad con Google, prueba iniciar sesión con una cuenta de Google.

---

## Resumen
Con esta configuración:
- Podrás gestionar accesos y usuarios desde el *realm* `MyRealm`.
- Tendrás un cliente configurado para redirigir a la URI definida.
- Habrás integrado la federación de identidad con Google para iniciar sesión usando cuentas de Google.

Estas configuraciones pueden ser utilizadas tanto para pruebas locales como en producción.





