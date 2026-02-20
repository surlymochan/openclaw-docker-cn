FROM node:22-bookworm

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable
RUN npm config set registry https://registry.npmmirror.com/ && pnpm config set registry https://registry.npmmirror.com/

WORKDIR /app

ARG OPENCLAW_DOCKER_APT_PACKAGES=""
RUN if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then \
      apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $OPENCLAW_DOCKER_APT_PACKAGES && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    fi

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./
COPY ui/package.json ./ui/package.json
COPY patches ./patches
COPY scripts ./scripts

RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build
# Force pnpm for UI build (Bun may fail on ARM/Synology architectures)
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:build

ENV NODE_ENV=production

# Install Ops Tools and gettext (for envsubst) and gosu
RUN apt-get update && apt-get install -y vim curl wget procps net-tools iputils-ping jq less gettext-base gosu && rm -rf /var/lib/apt/lists/*

# Add OpenClaw CLI Wrapper
RUN echo '#!/bin/sh\nexec node /app/dist/index.js "$@"' > /usr/local/bin/openclaw && chmod +x /usr/local/bin/openclaw

# Copy MCP Server
COPY search-mcp /app/search-mcp
RUN cd /app/search-mcp && npm install --production

# Copy Config Template and Entrypoint
COPY openclaw.template.json /app/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Allow non-root user to write temp files during runtime/tests.
RUN chown -R node:node /app

# Start gateway server with default config.
ENTRYPOINT ["/entrypoint.sh"]
