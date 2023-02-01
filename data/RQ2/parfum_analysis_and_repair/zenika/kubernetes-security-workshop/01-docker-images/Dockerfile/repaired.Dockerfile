FROM eu.gcr.io/kubernetes-security-workshop/ruby-deps:1.0

RUN apt update && apt install --no-install-recommends -y nodejs=4.8.2~dfsg-1 && rm -rf /var/lib/apt/lists/*;

COPY demo demo
WORKDIR demo

RUN bundle install

EXPOSE 3000

ENTRYPOINT ["rails","s","--binding","0.0.0.0"]
