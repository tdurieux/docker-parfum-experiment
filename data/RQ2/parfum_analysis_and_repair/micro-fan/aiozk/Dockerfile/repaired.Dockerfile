FROM fan0/python:3.0.2

WORKDIR /code

RUN pip3 install --no-cache-dir fan_tools pytest-asyncio pytest-cov codecov
RUN apt install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;

ADD . /code
WORKDIR /code
