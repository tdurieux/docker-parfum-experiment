FROM ubuntu:16.04

# Install
RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pip cfv cksfv p7zip-full p7zip-rar unrar rar git && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install lit OutputCheck

# Build Preparation
RUN mkdir -p /src/
RUN mkdir -p /src/build/

# Build
WORKDIR /src/
COPY . /src/
RUN cd /src

# Run Tests
RUN git clone http://github.com/arfoll/unrarall.git unraralltest/
RUN ./unraralltest/tests/run.sh
