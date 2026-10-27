import { Pool } from 'pg';

// In development, Next.js reloads modules constantly. Keeping the pool on
// globalThis stops us from opening a new set of connections on every reload.
const g = globalThis as unknown as { pool?: Pool };

export const pool = g.pool ?? new Pool({ connectionString: process.env.DATABASE_URL });

if (process.env.NODE_ENV !== 'production') g.pool = pool;