FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir astor logzero coz-bytecode neo-boa

COPY compiler.py /compiler.py

CMD python3 compiler.py
