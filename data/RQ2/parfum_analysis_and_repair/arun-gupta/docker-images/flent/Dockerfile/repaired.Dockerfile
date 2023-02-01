FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y sudo && sudo apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN sudo add-apt-repository ppa:tohojo/flent
RUN sudo apt-get update

