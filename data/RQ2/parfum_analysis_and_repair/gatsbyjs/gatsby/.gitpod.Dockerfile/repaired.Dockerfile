FROM gitpod/workspace-full

RUN npm -g install gatsby-dev-cli && npm cache clean --force;
