FROM ubuntu:20.04

# tzdata confirmation override
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade

# we need git to run as dev container
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# install compiler and build stuff
RUN apt-get -y --no-install-recommends install build-essential cmake clang-tidy clang && rm -rf /var/lib/apt/lists/*;

# install documentation stuff
RUN apt-get -y --no-install-recommends install doxygen plantuml graphviz && rm -rf /var/lib/apt/lists/*;

# other
RUN apt-get -y --no-install-recommends install lcov && rm -rf /var/lib/apt/lists/*;