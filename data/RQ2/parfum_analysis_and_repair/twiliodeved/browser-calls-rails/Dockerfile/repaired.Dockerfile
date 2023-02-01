FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile ./

COPY Makefile ./

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN make install

COPY . .

RUN make setup-serve

EXPOSE 3000

CMD ["make", "serve"]
