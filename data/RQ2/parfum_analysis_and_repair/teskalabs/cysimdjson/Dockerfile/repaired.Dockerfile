FROM ubuntu:20.10

RUN apt-get update -qq && apt-get install --no-install-recommends -y git python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir git+https://github.com/TeskaLabs/cysimdjson.git
RUN pip3 install --no-cache-dir ipython

CMD ["ipython"]
