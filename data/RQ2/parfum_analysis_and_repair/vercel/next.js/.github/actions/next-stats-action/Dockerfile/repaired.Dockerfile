FROM node:14-buster

LABEL com.github.actions.name="Next.js PR Stats"
LABEL com.github.actions.description="Compares stats of a PR with the main branch"
LABEL repository="https://github.com/vercel/next-stats-action"

COPY . /next-stats

# Install node_modules
RUN npm i -g pnpm@7.2.1 && npm cache clean --force;
RUN cd /next-stats && pnpm install --production

RUN git config --global user.email 'stats@localhost'
RUN git config --global user.name 'next stats'

RUN apt update && apt install --no-install-recommends apache2-utils -y && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
