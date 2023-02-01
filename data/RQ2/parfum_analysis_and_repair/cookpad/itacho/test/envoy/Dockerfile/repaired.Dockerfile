FROM envoyproxy/envoy:v1.9.0

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common curl && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get install --no-install-recommends -y ruby2.6 && rm -rf /var/lib/apt/lists/*;
COPY run.rb /run.rb

CMD ["ruby", "/run.rb"]
