FROM amd64/python:3.9-buster
RUN \
  echo "deb https://deb.nodesource.com/node_17.x buster main" > /etc/apt/sources.list.d/nodesource.list && \
  wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && \
  apt-get install --no-install-recommends -yqq nodejs yarn && \
  pip install --no-cache-dir -U pip && pip install --no-cache-dir pipenv && \
  npm i -g npm@^8 && \
  curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && ln -s /root/.poetry/bin/poetry /usr/local/bin && \
  rm -rf /var/lib/apt/lists/* && npm cache clean --force;
RUN python3.9 -m pip install py-tgcalls
RUN apt update && apt install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/installer
COPY linux_mount.sh /usr/src/installer
RUN chmod +x /usr/src/installer/linux_mount.sh
VOLUME ['/usr/src/installer']
