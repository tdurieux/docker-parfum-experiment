FROM ubuntu:16.04
MAINTAINER The Stripe Observability Team <support@stripe.com>

RUN apt-get update && apt-get install --no-install-recommends -y build-essential python-dev curl lsb-release && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && python /tmp/get-pip.py && pip --version
RUN pip install --no-cache-dir virtualenv
RUN DD_API_KEY='foo' DD_INSTALL_ONLY=true bash -c "$( curl -f -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)" -f
RUN mkdir /src
ADD requirements.txt requirements-test.txt Makefile /src/
RUN make -C /src test-requirements

ADD . /src

CMD make -C /src test install
