FROM base_ubuntu

RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

COPY . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
