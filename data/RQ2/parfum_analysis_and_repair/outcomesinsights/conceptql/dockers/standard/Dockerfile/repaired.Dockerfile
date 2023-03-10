FROM ruby:2.4.5-stretch

WORKDIR /app

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  libpq-dev python-pip python-setuptools git krb5-user krb5-config \
  && pip install --no-cache-dir wheel \
  && pip install --no-cache-dir --user \
  wheel pyOpenSSL cryptography idna certifi "urllib3[secure]" sqlparse && rm -rf /var/lib/apt/lists/*;


COPY .ci.Gemfile conceptql.gemspec ./
COPY ./lib/ ./lib
RUN ls && bundle config github.https true && bundle install --gemfile .ci.Gemfile

COPY . ./

CMD ["bash"]
