# Árbitro Implacable

Juego arcade en HTML: un árbitro se mueve por la parte baja del campo y lanza tarjetas a las caras que caen. No dejes que ninguna se escape.

## Cómo se juega

| Acción | Teclado | Móvil |
|---|---|---|
| Moverse | ← → o A D | ◀ ▶ |
| Tarjeta amarilla | Espacio o Z (se puede mantener) | Botón amarillo |
| Tarjeta roja | X, ↑ o W | Botón rojo |
| Pausa | P o Esc | II |
| Silenciar | M | — |

- Dos amarillas a la misma cara = expulsión.
- La roja expulsa directamente y atraviesa varias caras, pero son limitadas (empiezas con 3, ganas una cada 6 expulsiones, máximo 5).
- Si una cara llega abajo pierdes una vida. Con 3 se acaba el partido.
- Cada 8 expulsiones subes de nivel: caen más rápido, salen más a menudo, la música se acelera y los puntos se multiplican.

## Jugadores y ranking

Antes de cada partida se pide el nombre del jugador. Al acabar, la puntuación entra en un ranking de los 10 mejores, que se ve en la pantalla final y (el top 3) en la portada.

Sin configurar nada, el ranking se guarda solo en el navegador de cada dispositivo. Para tener un **ranking global** compartido por todos, conéctalo a Supabase (gratis):

### Activar el ranking global con Supabase

1. Crea una cuenta en [supabase.com](https://supabase.com) y un proyecto nuevo (plan Free; la región más cercana, por ejemplo una europea).
2. En el proyecto, abre **SQL Editor → New query**, pega el contenido de `supabase.sql` y pulsa **Run**. Esto crea la tabla `ranking` con sus permisos.
3. Ve a **Project Settings → API Keys** y copia la **Publishable key** (empieza por `sb_publishable_`). Si solo ves claves *anon*/*service_role*, usa la **anon**. **Nunca** uses la *secret* ni la *service_role*: darían control total de la base de datos a cualquiera.
4. Copia también la URL del proyecto (`https://xxxxx.supabase.co`, en **Project Settings → Data API** o en la página principal del proyecto).
5. Pégalas en `index.html`, en `SUPABASE_URL` y `SUPABASE_KEY`, y sube el cambio a GitHub.

Detalles:
- La clave publishable está pensada para ir en páginas públicas: con ella solo se puede ver el ranking y añadir puntuaciones, no modificar ni borrar.
- La tabla rechaza puntuaciones imposibles para el nivel alcanzado, pero alguien con conocimientos podría enviar puntuaciones falsas creíbles. Para borrar una, ve a **Table Editor → ranking** o usa las consultas de mantenimiento del final de `supabase.sql`.
- Si un jugador se queda sin conexión al acabar, la puntuación se guarda en su móvil y se sube sola en la siguiente partida.
- Supabase pausa los proyectos gratuitos tras una semana sin actividad. Si pasa, entra en el panel y pulsa **Resume project**; los datos se conservan.

## Protestas

Al expulsar una cara aparece un bocadillo con una protesta al árbitro, y además se dice en voz alta con la voz del navegador (el tipo de voz depende de cada dispositivo). Las frases se cambian en la lista `FRASES` al principio de `index.html`, y la voz se desactiva poniendo `VOZ = false`. La tecla M silencia también la voz.

## Poner tus fotos

1. Copia las fotos en la carpeta `img/` (mejor cuadradas y con la cara centrada).
2. Abre `index.html` y edita la lista `FOTOS` del principio:

```js
const FOTOS = [
  'img/cara1.jpg',
  { src: 'img/paco.png', nombre: 'Paco' },  // con nombre: sale "¡FUERA, PACO!"
];
```

Si la lista está vacía, el juego usa caras dibujadas.

## Publicarlo en GitHub Pages

1. Sube `index.html`, `README.md` y la carpeta `img/` a un repositorio.
2. En el repositorio: **Settings → Pages → Build and deployment**, elige *Deploy from a branch*, rama `main`, carpeta `/ (root)`.
3. A los pocos minutos estará en `https://TU-USUARIO.github.io/NOMBRE-DEL-REPO/`.

## Detalles técnicos

- Un único archivo, sin dependencias ni proceso de build.
- La música (chiptune original) y los efectos se generan en el navegador con la Web Audio API: no hay archivos de audio ni problemas de derechos.
- El récord se guarda en el `localStorage` del navegador.
