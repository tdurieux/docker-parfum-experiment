FROM ubuntu:16.04

RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends -qq sudo && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get -qq update
RUN sudo apt-get -qq -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -qq -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-add-repository -y ppa:beineri/opt-qt57-xenial
RUN sudo apt-get -qq update
RUN sudo apt-get -qq -y --no-install-recommends install qt573d qt57charts-no-lgpl qt57datavis-no-lgpl qt57declarative qt57svg && rm -rf /var/lib/apt/lists/*;

# install packages needed by configure
RUN sudo apt-get -qq -y --no-install-recommends install patch git build-essential curl && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -qq -y --no-install-recommends install snapcraft && rm -rf /var/lib/apt/lists/*;
