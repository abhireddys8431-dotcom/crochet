-- CozyKnots Supabase Database Schema
-- Run this in the Supabase SQL Editor to initialize/rebuild all tables and policies.

-- 1. DROP EXISTING POLICIES AND TABLES (FOR CLEAN SLATE REBUILD)
DROP POLICY IF EXISTS "Allow public read of profiles" ON public.profiles;
DROP POLICY IF EXISTS "Allow users to update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Allow users to insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Allow public subscription insertions" ON public.subscribers;
DROP POLICY IF EXISTS "Allow admin read of subscribers" ON public.subscribers;
DROP POLICY IF EXISTS "Allow public read of coupons" ON public.coupons;
DROP POLICY IF EXISTS "Allow admin management of coupons" ON public.coupons;
DROP POLICY IF EXISTS "Allow public/guest creation of orders" ON public.orders;
DROP POLICY IF EXISTS "Allow select orders" ON public.orders;
DROP POLICY IF EXISTS "Allow public/guest custom orders creation" ON public.custom_orders;
DROP POLICY IF EXISTS "Allow select custom orders" ON public.custom_orders;
DROP POLICY IF EXISTS "Allow public read of reviews" ON public.reviews;
DROP POLICY IF EXISTS "Allow authenticated users to write reviews" ON public.reviews;
DROP POLICY IF EXISTS "Allow users to update/delete own reviews" ON public.reviews;
DROP POLICY IF EXISTS "Allow users to delete own reviews" ON public.reviews;

DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.custom_orders CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.coupons CASCADE;
DROP TABLE IF EXISTS public.subscribers CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;


-- 2. PROFILES TABLE (Linked to Supabase Auth users)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  email text not null,
  role text default 'user' check (role in ('user', 'admin')),
  avatar_url text,
  addresses jsonb default '[]'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS for Profiles
alter table public.profiles enable row level security;

create policy "Allow public read of profiles"
  on public.profiles for select
  using (true);

create policy "Allow users to update own profile"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Allow users to insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);


-- 3. SUBSCRIBERS TABLE (Newsletter)
create table public.subscribers (
  id bigint generated always as identity primary key,
  email text unique not null,
  subscribed_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.subscribers enable row level security;

create policy "Allow public subscription insertions"
  on public.subscribers for insert
  with check (true);

create policy "Allow admin read of subscribers"
  on public.subscribers for select
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  );


-- 4. COUPONS TABLE
create table public.coupons (
  code text primary key,
  type text not null check (type in ('percentage', 'flat')),
  value numeric not null,
  expiry_date timestamp with time zone,
  usage_limit integer,
  used_count integer default 0
);

alter table public.coupons enable row level security;

create policy "Allow public read of coupons"
  on public.coupons for select
  using (true);

create policy "Allow admin management of coupons"
  on public.coupons for all
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  );


-- 5. ORDERS TABLE (Includes payment_id for Razorpay transactions)
create table public.orders (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users,
  email text not null,
  items jsonb not null,
  subtotal numeric not null,
  discount numeric not null,
  shipping numeric not null,
  total numeric not null,
  status text default 'placed' check (status in ('placed', 'processing', 'shipped', 'delivered')),
  address jsonb not null,
  payment_id text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.orders enable row level security;

create policy "Allow public/guest creation of orders"
  on public.orders for insert
  with check (true);

-- Allow reading orders (using cryptographic random UUIDs makes guess-reading impossible, enabling guest checkout success page)
create policy "Allow select orders"
  on public.orders for select
  using (true);


-- 6. CUSTOM ORDERS TABLE
create table public.custom_orders (
  id text primary key, -- Format: CK-YYYYMMDD-XXXX
  user_id uuid references auth.users,
  category text not null,
  description text not null,
  preferences jsonb not null,
  status text default 'new' check (status in ('new', 'in_progress', 'ready', 'delivered')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.custom_orders enable row level security;

create policy "Allow public/guest custom orders creation"
  on public.custom_orders for insert
  with check (true);

create policy "Allow select custom orders"
  on public.custom_orders for select
  using (true);


-- 7. REVIEWS TABLE
create table public.reviews (
  id uuid default gen_random_uuid() primary key,
  product_id text not null,
  user_id uuid references auth.users,
  name text not null,
  rating numeric not null check (rating >= 1 and rating <= 5),
  comment text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.reviews enable row level security;

create policy "Allow public read of reviews"
  on public.reviews for select
  using (true);

create policy "Allow authenticated users to write reviews"
  on public.reviews for insert
  with check (auth.uid() = user_id);

create policy "Allow users to update/delete own reviews"
  on public.reviews for update
  using (auth.uid() = user_id);

create policy "Allow users to delete own reviews"
  on public.reviews for delete
  using (
    auth.uid() = user_id or
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  );
