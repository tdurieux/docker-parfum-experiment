FROM nikolaik/python-nodejs:python3.9-nodejs15

ADD . /app
ADD docker/config.js.docker /app/config.js

RUN apt-get update || : && apt-get install --no-install-recommends pdftk python-pypdf2 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir svglib
RUN npm install && npm cache clean --force;

CMD ["node", "server.js"]