FROM radish34_logger

RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends python3-pip -y && \
  pip3 install --no-cache-dir bitstring==3.1.5 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY ./package.json ./package-lock.json ./.babelrc ./
RUN npm ci

EXPOSE 8001
EXPOSE 8101

CMD npm start
