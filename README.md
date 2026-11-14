# Portfolio API
Backend for [marco.figueroa-sanchez.com](https://marco.figueroa-sanchez.com), Marco Figueroa's personal portfolio, consumed by the [web](https://github.com/mfigueroa23/portfolio-web) and the management panel. It serves the site content in English and Spanish (experience, projects, posts, certifications, testimonials and more), renders Markdown, stores uploaded images and PDFs, and handles the contact form and visitor testimonials.

Built with [NestJS](https://nestjs.com) 12, TypeScript, PostgreSQL through [Prisma](https://www.prisma.io) 7, Vitest and pnpm.

## Getting started

### Requirements
- Node.js 26
- pnpm 12.6.0
- PostgreSQL

### Clone and install
```bash
git clone https://github.com/mfigueroa23/portfolio-api.git
cd portfolio-api
pnpm install
```

### Database
Create a role and a database (the role needs `CREATEDB` so Prisma can create its shadow database). Any names work; these match the examples:
```sql
CREATE ROLE portfolio_api LOGIN CREATEDB PASSWORD '<password>';
CREATE DATABASE portfolio_api OWNER portfolio_api;
```

Copy the environment file and set `DATABASE_URL` and `SHADOW_DATABASE_URL`:
```bash
cp .env.example .env
```
```dotenv
DATABASE_URL="postgresql://portfolio_api:<password>@localhost:5432/portfolio_api?schema=public"
SHADOW_DATABASE_URL="postgresql://portfolio_api:<password>@localhost:5432/portfolio_api_shadow?schema=public"
```

Apply the migrations:
```bash
pnpm prisma migrate deploy
```

Application secrets are not environment variables: they live in the `property` table. Sign-in and content writes need at least the JWT secret:
```sql
INSERT INTO property (key, value) VALUES ('jwt_secret', '<random secret>');
```
| Key | Used for |
|---|---|
| `jwt_secret` | Signing the admin tokens |
| `google_client_id` | Google sign-in of the panel |
| `admin_google_email` | The only Google account allowed to sign in |
| `brevo_api_key` | Sending the contact and testimonial emails |

Browsers are only allowed from the origins enabled in the `cors_origin` table, for example the local web:
```sql
INSERT INTO cors_origin (origin, enabled) VALUES ('http://localhost:4200', true);
```

### Run
```bash
pnpm start:dev   # http://localhost:3000
```

## Commands
| Command | Description |
|---|---|
| `pnpm start:dev` | Run in watch mode |
| `pnpm start:debug` | Run in watch mode with the debugger |
| `pnpm build` | Generate the Prisma client and compile to `dist/` |
| `pnpm start:prod` | Run the compiled build |
| `pnpm generate` | Generate the Prisma client |
| `pnpm test` | Unit tests |
| `pnpm test:e2e` | End-to-end tests |
| `pnpm test:cov` | Unit tests with coverage |
| `pnpm lint` | Lint with oxlint (type-aware) |
| `pnpm format` | Format with Prettier |
| `pnpm prisma migrate dev --name <name>` | Create and apply a new migration |
| `pnpm prisma migrate deploy` | Apply pending migrations |

### Docker
The image copies a compiled `dist/`, so build the application first:
```bash
pnpm build
docker build -t portfolio-api .
docker run --env-file .env -p 3000:3000 portfolio-api
```

## Endpoints
Routes marked with 🔒 require `Authorization: Bearer <accessToken>`. Public reads accept `?lang=en|es`. Errors always have the shape `{ error, fields? }`.

| Method & route | Description |
|---|---|
| `GET /` | Health check |
| `POST /auth/google` | Exchange a Google ID token for an access token |
| `POST /contact` | Send the contact form |
| `POST /testimonials` | Submit a testimonial for review |
| `GET /content/<collection>` | List a collection |
| `GET /content/<collection>/all` 🔒 | Owner list, including drafts and Spanish fields |
| `POST /content/<collection>` 🔒 | Create an item |
| `PUT /content/<collection>/:id` 🔒 | Replace an item |
| `DELETE /content/<collection>/:id` 🔒 | Delete an item |
| `GET /content/{projects,posts}/:slug` | A published project or post |
| `POST /content/{projects,posts}/:id/{publish,unpublish}` 🔒 | Publish or return to draft |
| `GET /content/posts/feed` | The 20 most recent posts |
| `GET /content/testimonials/pending-count` 🔒 | Testimonials waiting for review |
| `POST /content/testimonials/:id/approve` 🔒 | Approve a testimonial |
| `POST /markdown/render` 🔒 | Render Markdown to HTML |
| `POST /files?name=<name>` 🔒 | Upload an image or PDF |
| `GET /files` 🔒 | File library |
| `GET /files/:id` | Serve a file |
| `GET /files/:id/references` 🔒 | Items that use a file |
| `DELETE /files/:id` 🔒 | Delete a file |
| `GET /resume` | The current resume PDF |
| `GET /resume/assignments` 🔒 | Resume assigned to each language |
| `PUT /resume/assignments/:lang` 🔒 | Assign a resume |
| `DELETE /resume/assignments/:lang` 🔒 | Clear a resume |

`<collection>` is one of `experiences`, `projects`, `posts`, `certifications`, `testimonials`, `highlights`, `social-links`, `technologies` and `contact-info`.

### Examples
Health check:
```bash
curl http://localhost:3000/
# {"status":"ok"}
```

Published projects in Spanish:
```bash
curl "http://localhost:3000/content/projects?lang=es&limit=5"
```

Second page of posts with a tag:
```bash
curl "http://localhost:3000/content/posts?page=2&tag=nestjs"
```

Send the contact form:
```bash
curl -X POST http://localhost:3000/contact \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane","email":"jane@example.com","message":"Hello!"}'
```

Sign in and create a draft post:
```bash
TOKEN=$(curl -s -X POST http://localhost:3000/auth/google \
  -H "Content-Type: application/json" \
  -d '{"credential":"<Google ID token>"}' | jq -r .accessToken)

curl -X POST http://localhost:3000/content/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"My first post","slug":"my-first-post"}'
```

Upload an image:
```bash
curl -X POST "http://localhost:3000/files?name=cover.png" \
  -H "Authorization: Bearer $TOKEN" \
  --data-binary @cover.png
```

## License
[MIT](LICENSE) © 2026 Marco Antonio Figueroa Sanchez
