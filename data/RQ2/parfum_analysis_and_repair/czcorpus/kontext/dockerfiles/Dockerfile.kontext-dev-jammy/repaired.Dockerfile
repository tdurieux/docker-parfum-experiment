FROM czcorpus/kontext-manatee:2.208-jammy

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install --no-install-recommends -y sox libsox-fmt-mp3 nodejs npm python3-pip python3-icu && rm -rf /var/lib/apt/lists/*;

COPY ./pack*.json ./
RUN npm install && npm cache clean --force;

COPY requirements.txt dev-requirements.txt ./
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r requirements.txt -r

COPY ./conf ./conf
RUN python3 scripts/install/steps.py SetupKontext
RUN mkdir /var/log/rq && mkdir /var/local/corpora/query_persistence

COPY launcher-config.json launcher-menu.json tsconfig.json webpack.dev.js ./