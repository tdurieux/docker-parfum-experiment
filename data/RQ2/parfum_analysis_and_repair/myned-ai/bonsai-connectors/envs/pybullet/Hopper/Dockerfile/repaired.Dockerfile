# this is one of the cached base images available for ACI
FROM python:3.8.3

# Install libraries and dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends && \
  apt-get install --no-install-recommends -y git \
  && rm -rf /var/lib/apt/lists/*

# Install SDK3 Python
COPY connectors ./connectors
RUN pip3 install --no-cache-dir -U setuptools \
  && cd connectors \
  && pip3 install --no-cache-dir . \
  && pip3 install --no-cache-dir gym \
  && pip3 install --no-cache-dir microsoft-bonsai-api \
  && git clone https://github.com/myned-ai/pybullet-gym.git \
  && cd pybullet-gym \
  && pip3 install --no-cache-dir -e .

# Set up the simulator
WORKDIR /sim

# Copy simulator files to /sim
COPY envs/pybullet/Hopper/hopper.py \
     envs/pybullet/Hopper/simulator_interface.json \
     /sim/


# This will be the command to run the simulator
CMD ["python", "hopper.py", "--headless", "--verbose"]
