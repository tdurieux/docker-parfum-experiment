FROM timbru31/ruby-node:2.6-14

WORKDIR /app
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update bundler && rm -rf /root/.gem;
COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY package.json package-lock.json /app/
RUN npm install && npm cache clean --force;

COPY . /app/

CMD ["npm", "start"]
