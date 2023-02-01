FROM circleci/golang:1.8

RUN sudo apt-get install -y --no-install-recommends python-pip && rm -rf /var/lib/apt/lists/*;
RUN sudo pip install --no-cache-dir pyyaml
