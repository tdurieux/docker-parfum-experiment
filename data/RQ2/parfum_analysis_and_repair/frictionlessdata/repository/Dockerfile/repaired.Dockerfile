FROM python:3

COPY . .

RUN \
  curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && \
  npm install --production && \
  pip install --no-cache-dir -r requirements.txt && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["node", "/lib/main.js"]
