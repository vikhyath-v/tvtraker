-- Create a custom users table
create table public.users (
  id uuid default gen_random_uuid() primary key,
  email text unique not null,
  username text not null,
  password_hash text not null,
  email_verified boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security
alter table public.users enable row level security;

-- Create policies
create policy "Users can view their own data" on public.users
  for select using (auth.uid() = id);

create policy "Users can update their own data" on public.users
  for update using (auth.uid() = id);

-- Create function to handle user registration
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, username, password_hash)
  values (new.id, new.email, new.raw_user_meta_data->>'username', new.encrypted_password);
  return new;
end;
$$ language plpgsql security definer;

-- Create trigger for new user registration
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user(); 