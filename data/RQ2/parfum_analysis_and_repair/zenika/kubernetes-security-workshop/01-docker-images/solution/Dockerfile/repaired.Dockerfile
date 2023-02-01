FROM eu.gcr.io/kubernetes-security-workshop/ruby-deps:1.1

RUN apt update && apt install --no-install-recommends -y nodejs=4.8.2~dfsg-1 && rm -rf /var/lib/apt/lists/*;

RUN groupadd --gid 1000 rails \
  && useradd --uid 1000 --gid rails --shell /bin/bash --create-home rails
USER rails:rails

COPY --chown=rails:rails demo demo
WORKDIR demo

RUN bundle install

EXPOSE 3000

ENTRYPOINT ["rails","s","--binding","0.0.0.0"]
