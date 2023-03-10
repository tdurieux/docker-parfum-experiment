# Dockerfile for running test games within Github Actions

FROM burnysc2/python-sc2-docker:release-python_3.7-sc2_4.10

# Copy files from current commit to root
ADD . /root/sharpy-sc2

WORKDIR /root/sharpy-sc2

# Install the sharpy-sc2 library and its requirements (s2clientprotocol etc.) to python