# Start with CUDA Torch base image
FROM kaixhin/cuda-torch:6.5
MAINTAINER Kai Arulkumaran <design@kaixhin.com>

# Install Torch packages
RUN luarocks install torchx && \
  luarocks install dpnn && \
  luarocks install rnn && \
  luarocks install mnist

# Clone FGMachine repo for RAM example