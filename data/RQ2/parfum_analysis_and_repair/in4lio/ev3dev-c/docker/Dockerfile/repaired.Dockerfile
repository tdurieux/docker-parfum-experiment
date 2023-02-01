FROM ev3dev/debian-stretch-cross:latest

RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y swig3.0 python-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo rm -rf /var/lib/apt/lists/*
