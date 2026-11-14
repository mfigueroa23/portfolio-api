// @prisma/client declares the Prisma CLI and TypeScript as optional peer dependencies. Both are
// devDependencies here, so the lockfile linked them to @prisma/client and a production install
// kept them, with the whole CLI tree (Studio, engines, effect, pglite...). The runtime only needs
// @prisma/client/runtime, so the peers are dropped and they stay development-only.
module.exports = {
  hooks: {
    readPackage(pkg) {
      if (pkg.name === '@prisma/client') {
        // pnpm still treats a name left in peerDependenciesMeta as an optional peer.
        for (const field of ['peerDependencies', 'peerDependenciesMeta']) {
          if (pkg[field]) {
            delete pkg[field].prisma;
            delete pkg[field].typescript;
          }
        }
      }
      return pkg;
    },
  },
};
