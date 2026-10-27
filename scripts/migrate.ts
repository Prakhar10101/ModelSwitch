import '../src/lib/load-env';
import { readFileSync } from 'node:fs';
import { pool } from '../src/lib/db';

async function main() {
  await pool.query(readFileSync('db/schema.sql', 'utf8'));
  console.log('Schema applied.');
  await pool.end();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});