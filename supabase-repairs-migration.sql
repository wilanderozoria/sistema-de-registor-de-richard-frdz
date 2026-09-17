-- Ejecuta este script una sola vez en el SQL Editor de Supabase.
-- Conserva los equipos entregados como historial en lugar de borrarlos.
ALTER TABLE public.repairs
  ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'recibido',
  ADD COLUMN IF NOT EXISTS final_price numeric(12,2),
  ADD COLUMN IF NOT EXISTS delivered_at timestamptz;

CREATE INDEX IF NOT EXISTS repairs_status_delivered_at_idx
  ON public.repairs (status, delivered_at DESC);
