-- =====================================================================
--  Ranking online de Árbitro Implacable
--  Pegar en Supabase → SQL Editor → New query → Run
-- =====================================================================

create table if not exists public.ranking (
  id      uuid primary key default gen_random_uuid(),
  nombre  text not null check (char_length(nombre) between 1 and 12),
  puntos  integer not null check (puntos > 0),
  nivel   integer not null check (nivel between 1 and 500),
  creado  timestamptz not null default now(),
  -- Filtro anti-trampas básico: con nivel N es imposible pasar de estos puntos
  constraint puntos_posibles check (puntos <= 1000 * nivel * (nivel + 1))
);

create index if not exists ranking_puntos_idx on public.ranking (puntos desc, creado asc);

-- Seguridad: cualquiera puede ver el ranking y añadir su puntuación,
-- pero nadie puede modificar ni borrar puntuaciones desde el juego.
alter table public.ranking enable row level security;

drop policy if exists "Ver ranking" on public.ranking;
create policy "Ver ranking" on public.ranking
  for select to anon using (true);

drop policy if exists "Guardar puntuacion" on public.ranking;
create policy "Guardar puntuacion" on public.ranking
  for insert to anon with check (true);

grant select, insert on public.ranking to anon;

-- ---------------------------------------------------------------------
--  Mantenimiento (ejecutar a mano solo si hace falta)
-- ---------------------------------------------------------------------
-- Borrar una puntuación concreta:
--   delete from public.ranking where nombre = 'TRAMPOSO';
-- Empezar el ranking de cero:
--   truncate public.ranking;
