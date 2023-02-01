FROM czcorpus/kontext-manatee:latest

SHELL ["/bin/bash", "--login", "-c"]
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
RUN nvm install 16

RUN apt-get update && apt-get install --no-install-recommends -y sox libsox-fmt-mp3 && rm -rf /var/lib/apt/lists/*;

COPY ./pack*.json ./
RUN npm install && npm cache clean --force;

COPY requirements.txt dev-requirements.txt ./
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r requirements.txt -r

COPY ./conf ./conf
RUN python3 scripts/install/steps.py SetupKontext
RUN mkdir /var/log/rq && mkdir /var/local/corpora/query_persistence

COPY launcher-config.json launcher-menu.json tsconfig.json webpack.dev.js ./