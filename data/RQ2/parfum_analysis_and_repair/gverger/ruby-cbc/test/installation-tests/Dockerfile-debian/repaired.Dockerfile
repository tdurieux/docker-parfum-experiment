FROM debian:bullseye-slim

RUN apt-get update && apt-get install --no-install-recommends -y gcc make coinor-libcbc-dev ruby-full && rm -rf /var/lib/apt/lists/*;

RUN gem install ruby-cbc

COPY ./cbc_test.rb /cbc_test.rb

CMD ["ruby", "/cbc_test.rb"]
