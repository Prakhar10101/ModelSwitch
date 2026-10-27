create table if not exists datasets (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  task_type text not null check (task_type in ('classification', 'extraction')),
  created_at timestamptz not null default now()
);

create table if not exists examples (
  id uuid primary key default gen_random_uuid(),
  dataset_id uuid not null references datasets(id) on delete cascade,
  position int not null,
  input text not null,
  expected text not null
);

create table if not exists runs (
  id uuid primary key default gen_random_uuid(),
  dataset_id uuid not null references datasets(id),
  system_prompt text not null,
  baseline_model text not null,
  candidate_model text not null,
  max_drop numeric not null default 0.03,
  created_at timestamptz not null default now()
);

create table if not exists run_items (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null references runs(id) on delete cascade,
  example_id uuid not null references examples(id) on delete cascade,
  model text not null,
  status text not null default 'pending'
    check (status in ('pending', 'running', 'done', 'error')),
  attempts int not null default 0,
  output text,
  input_tokens int,
  output_tokens int,
  latency_ms int,
  cost_usd numeric(12, 6),
  correct boolean,
  error text,
  created_at timestamptz not null default now(),
  unique (run_id, example_id, model)
);

create index if not exists run_items_queue_idx on run_items (status, created_at);