FROM circleci/python:3.7.3-node-browsers

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y
RUN sudo apt-get install --no-install-recommends -y default-mysql-client && rm -rf /var/lib/apt/lists/*;
