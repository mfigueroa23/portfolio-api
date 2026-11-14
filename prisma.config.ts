import { existsSync } from 'node:fs';
import { defineConfig } from 'prisma/config';

// Locally DATABASE_URL comes from .env; in Docker and Kubernetes it is already
// in the environment, so the file is optional.
if (existsSync('.env')) {
  process.loadEnvFile();
}

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: { path: 'prisma/migrations' },
  datasource: {
    url: process.env.DATABASE_URL ?? '',
    // Only `migrate dev` uses the shadow database; CI and production run without
    // it, and Prisma rejects an empty string.
    shadowDatabaseUrl: process.env.SHADOW_DATABASE_URL || undefined,
  },
});
