CREATE TABLE IF NOT EXISTS restaurants (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  rating NUMERIC(2, 1) NOT NULL DEFAULT 0,
  delivery_minutes INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  customer TEXT NOT NULL,
  total NUMERIC(10, 2) NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'Draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO restaurants (name, category, rating, delivery_minutes)
VALUES
  ('Bon Bakery', 'Bakery and desserts', 4.8, 25),
  ('Meal Monkey Legacy', 'Food delivery reference', 4.6, 32)
ON CONFLICT DO NOTHING;

INSERT INTO orders (code, customer, total, status)
VALUES
  ('BA-0001', 'Internal QA', 42.50, 'Draft'),
  ('BA-0002', 'Kitchen test', 18.90, 'Queued')
ON CONFLICT DO NOTHING;
