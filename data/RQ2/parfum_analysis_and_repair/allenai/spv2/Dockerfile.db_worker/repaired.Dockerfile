FROM ubuntu:16.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /spv2

# Install dependencies
RUN apt-get update -y && \
    apt-get install --no-install-recommends apt-utils -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends git python3 python3-pip python3-cffi unzip wget -y && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# Install pip dependencies
COPY requirements.in .
RUN pip3 install --no-cache-dir -r requirements.in

# Copy model
COPY model/ model/

# Copy and build the stringmatch module
COPY stringmatch/ stringmatch/
RUN cd stringmatch && python3 stringmatch_builder.py && cd ..

# Copy the code itself
COPY *.py ./
COPY *.sh ./

# Install an optimized version of tensorflow
COPY tensorflow-cpu/ tensorflow-cpu/
RUN pip3 uninstall -y tensorflow && pip3 install --no-cache-dir tensorflow-cpu/tensorflow-1.3.1-cp35-cp35m-linux_x86_64.whl

CMD python3 db_worker.py
