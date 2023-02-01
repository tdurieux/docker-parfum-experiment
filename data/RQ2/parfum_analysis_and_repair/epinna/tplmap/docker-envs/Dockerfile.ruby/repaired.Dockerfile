FROM ruby:2.5.1

RUN gem install slim tilt cuba rack
RUN apt-get update && apt-get install --no-install-recommends --upgrade dnsutils python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests PyYAML

COPY  . /apps/
WORKDIR /apps/tests/

EXPOSE 15005

CMD cd env_ruby_tests && rackup --host 0.0.0.0 --port 15005
