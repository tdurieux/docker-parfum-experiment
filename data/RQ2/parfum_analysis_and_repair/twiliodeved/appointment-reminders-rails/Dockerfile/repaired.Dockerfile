FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile ./

COPY Makefile ./

COPY package.json ./

# Install a Javascript environment in the container to avoid ExecJS::RuntimeUnavailable
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN make install

COPY . .

RUN make database

EXPOSE 3000

CMD ["sh", "-c","./bin/delayed_job start && make serve"]
