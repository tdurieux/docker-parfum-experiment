FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

# Set working directory
WORKDIR /mlperf/ssd

# Necessary zone info for tzdata
ENV TZ=America/New_York
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-tk python-pip numactl git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

# Necessary pip packages
COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir cython \
 && pip install --no-cache-dir https://github.com/mlperf/logging/archive/9ea0afa.zip \
 && pip install --no-cache-dir -r /requirements.txt

# Copy SSD code
COPY ssd .
