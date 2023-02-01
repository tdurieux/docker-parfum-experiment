FROM ubuntu:bionic

# Update base container install
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y

# Install GDAL dependencies
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;

# Install dependencies for other packages
RUN apt-get install -y --no-install-recommends gcc g++ && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install jpeg-dev zlib-dev

# Ensure locales configured correctly
RUN locale-gen en_US.UTF-8
ENV LC_ALL='en_US.utf8'

# Set python aliases for python3
RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# This will install latest version of GDAL
RUN apt-get -y --no-install-recommends install python3-gdal && rm -rf /var/lib/apt/lists/*;

# Build context
ADD test.py train.py evaluate.py src /

# Install dependencies for tiling
RUN pip3 install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED = '1'



