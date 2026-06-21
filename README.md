# flutter_spring_boot

Cliente **Flutter** de demostración del ecosistema Spring Cloud. Implementa login nativo contra OAuth y consume la API de usuarios a través del API Gateway con token Bearer.

## Stack

- Flutter · Dart ^3.10.4
- Dependencias: `http`, `flutter_secure_storage`

## Llamadas HTTP (cliente)

No expone API propia. Realiza estas peticiones al backend:

| Método | URL | Descripción |
|--------|-----|-------------|
| POST | `http://{host}:9190/api/auth/login` | Login nativo (usuario/contraseña → JWT) |
| GET | `http://{host}:8080/api/users/v1` | Lista usuarios con `Authorization: Bearer {token}` |

**Host:** `127.0.0.1` (iOS/desktop) · `10.0.2.2` (emulador Android). Configurable en `lib/config/oauth_config.dart`.

El token se persiste en almacenamiento seguro (`flutter_secure_storage`).

## Pantallas

- **LoginScreen** — formulario de credenciales
- **HomeScreen** — lista de usuarios y logout

## Importancia en el ecosistema

Es el **cliente móvil/desktop** que demuestra el flujo completo: autenticación OAuth nativa + consumo de API protegida vía gateway.

**Dependencias:**

- **oauth** (`:9190`) — obtención del JWT
- **msvc-gateway-server** (`:8080`) — acceso a la API de usuarios
- Indirectamente: **msvc-users** (a través del gateway)

**Orden de arranque:** arrancar la app Flutter cuando OAuth, Gateway y msvc-users estén operativos.

```bash
flutter run
```
