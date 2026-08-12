-- ============================================================
-- Jai Restaurant — Supabase schema for table_bookings
-- Run this once in your Supabase project's SQL Editor
-- (Dashboard → SQL Editor → New query → paste → Run)
-- ============================================================

-- 1. Table
create table if not exists public.table_bookings (
  id              uuid primary key default gen_random_uuid(),
  full_name       text not null check (char_length(trim(full_name)) >= 2),
  phone           text not null check (phone ~ '^\+?[0-9\s-]{10,15}$'),
  email           text check (email is null or email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  booking_date    date not null,
  booking_time    time not null,
  guests          integer not null check (guests >= 1 and guests <= 50),
  special_request text check (char_length(special_request) <= 500),
  status          text not null default 'pending'
                    check (status in ('pending', 'confirmed', 'cancelled', 'completed')),
  created_at      timestamptz not null default now()
);

-- Helpful index for an eventual admin dashboard (filter by date/status)
create index if not exists idx_table_bookings_date on public.table_bookings (booking_date);
create index if not exists idx_table_bookings_status on public.table_bookings (status);

-- 2. Row Level Security
alter table public.table_bookings enable row level security;

-- Public (anon) visitors may INSERT a booking (submit the form)…
create policy "Public can create bookings"
  on public.table_bookings
  for insert
  to anon
  with check (
    status = 'pending'  -- customers can only ever create a pending booking
  );

-- …but may NOT read, update, or delete any booking (protects other customers' data).
-- No select/update/delete policy is created for the anon role, so those
-- actions are denied by default once RLS is enabled.

-- 3. (Later) Admin access
-- When you build an admin dashboard, use a authenticated/service role and
-- add policies scoped to that role, e.g.:
--
-- create policy "Admins can view all bookings"
--   on public.table_bookings for select
--   to authenticated
--   using (auth.jwt() ->> 'role' = 'admin');
--
-- Never use the service_role key in frontend code — only in a secure
-- server context (Edge Function, backend API, etc).
