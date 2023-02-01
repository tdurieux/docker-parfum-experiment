FROM makeflow/remote-workspace

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt install -y --no-install-recommends --assume-yes nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install --global yarn &&\
  yarn config set prefix /root/.yarn &&\
  yarn config set cache-folder /root/.yarn-cache && \
  echo 'export PATH="/root/.yarn/bin:${PATH}"' >> /root/.bashrc && npm cache clean --force; && yarn cache clean;
