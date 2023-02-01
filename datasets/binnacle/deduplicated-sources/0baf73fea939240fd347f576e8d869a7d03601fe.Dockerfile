# run with:
# docker build -f Dockerfile -t brownie .
# docker run -v $PWD:/usr/src brownie brownie test
# If you need to update the version of brownie then add the --no-cache
#  flag to the docker build command

FROM ubuntu:bionic
WORKDIR /usr/src

RUN  apt-get update

# Timezone required for tkinter
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y python3.6 python3-pip python3-venv python3-tk wget curl git npm nodejs
RUN pip3 install wheel pip setuptools virtualenv py-solc-x eth-brownie

RUN npm install -g ganache-cli@6.4.3

# Brownie installs compilers at runtime so ensure the updates are
# in the compiled image so it doesn't do this every time
RUN brownie init; true
RUN brownie test

# Fix UnicodeEncodeError error when running tests
ENV PYTHONIOENCODING=utf-8
