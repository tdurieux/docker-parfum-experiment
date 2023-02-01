FROM envoyproxy/envoy:3122ee8361a3c339c906554f1bb56f68a8e692a9

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common curl && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get install --no-install-recommends -y ruby2.4 && rm -rf /var/lib/apt/lists/*;
COPY run.rb /run.rb

CMD ["ruby", "/run.rb"]
