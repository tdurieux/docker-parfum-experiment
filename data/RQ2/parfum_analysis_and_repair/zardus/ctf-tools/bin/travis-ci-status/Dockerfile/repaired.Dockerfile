FROM ubuntu:xenial

RUN apt-get update
RUN apt-get -y --no-install-recommends install python-software-properties software-properties-common build-essential git python-pip ipython vim && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get -y --no-install-recommends install ruby2.1 ruby2.1-dev ruby-switch && rm -rf /var/lib/apt/lists/*;
RUN ruby-switch --set ruby2.1

RUN gem install travis -v 1.8.8 --no-rdoc --no-ri
RUN pip install --no-cache-dir binpacking

WORKDIR /gitdata
