FROM ruby:2.6.3
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -

RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN curl -f https://deb.nodesource.com/setup_12.x | bash
RUN cat pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y build-essential nodejs yarn vim libpq-dev postgresql-client ffmpeg && rm -rf /var/lib/apt/lists/*;
# remove pubkey
RUN rm pubkey.gpg

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --no-cache-dir --upgrade pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 --no-cache-dir install --upgrade awscli
RUN mkdir /myapp
RUN mkdir /storage
WORKDIR /myapp
COPY . /myapp
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN bundle install
RUN yarn install --check-files && yarn cache clean;

ARG RAILS_MASTER_KEY
RUN if [ "$RAILS_MASTER_KEY" ] ; then RAILS_MASTER_KEY=${RAILS_MASTER_KEY} RAILS_ENV=production bundle exec rails assets:precompile ; fi

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
