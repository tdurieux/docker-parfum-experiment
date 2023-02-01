FROM gcc

RUN gcc --version

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . /app

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "test-integration", "--", "zookeeper:2181"]
