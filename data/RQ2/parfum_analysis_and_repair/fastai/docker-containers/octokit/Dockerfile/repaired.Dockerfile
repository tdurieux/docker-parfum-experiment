FROM fastai/ubuntu
RUN apt update && apt install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g @octokit/rest && npm cache clean --force;
ENV NODE_PATH="/usr/local/lib/node_modules/"
