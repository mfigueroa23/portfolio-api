# dist/ is compiled outside the image (`pnpm build`, the release's build job); the image only
# installs the production dependencies.
FROM node:26-alpine AS deps
RUN npm install -g pnpm@12.6.0
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .pnpmfile.cjs ./
RUN pnpm install --frozen-lockfile --prod

FROM node:26-alpine
ENV NODE_ENV=production
# Alpine fixes published after the base image, and no npm/npx/corepack: the API only runs `node`
# and the bundled npm only brings vulnerable packages.
RUN apk upgrade --no-cache \
 && rm -rf /usr/local/lib/node_modules /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack
WORKDIR /app
COPY package.json ./
COPY --from=deps /app/node_modules ./node_modules
COPY dist ./dist
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]
