# For live version
FROM burnysc2/python-sc2-docker

# Copy files from the current commit (the python-sc2 folder) to root
ADD . /root/python-sc2

# Install the python-sc2 library and its requirements (s2clientprotocol etc.) to python
WORKDIR /root/python-sc2
RUN python -m pip install .

# This will be executed during the container run instead:
# docker run test_image -c "python examples/protoss/cannon_rush.py"