# run with:
# docker build -f Dockerfile -t brownie .
# docker run -v $PWD:/usr/src brownie pytest tests

FROM ubuntu:bionic
WORKDIR /usr/src

RUN apt-get update && apt-get install --no-install-recommends -y python3.6 python3-pip python3-venv python3-tk wget curl git npm nodejs && rm -rf /var/lib/apt/lists/*; # Timezone required for tkinter
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN pip3 install --no-cache-dir wheel pip setuptools virtualenv py-solc-x eth-brownie

RUN npm install -g ganache-cli@6.5.1 && npm cache clean --force;

# Fix UnicodeEncodeError error when running tests
ENV PYTHONIOENCODING=utf-8
