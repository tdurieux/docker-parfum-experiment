# Start with both Halide and OpenCV
FROM mbuckler/cam-pipes
WORKDIR /root/packages

# Install image converter for JPEG/PNG conversion
RUN apt-get install --no-install-recommends python-pip python-dev build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade virtualenv
RUN pip install --no-cache-dir Pillow

# Install dependencies for OpenCV benchmarks
RUN pip install --no-cache-dir ipdb
RUN apt-get install --no-install-recommends python-matplotlib -y && rm -rf /var/lib/apt/lists/*;

# Install extra processing dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir psutil
RUN apt-get install -y --no-install-recommends rsync && rm -rf /var/lib/apt/lists/*;

# Install LibRaw
RUN wget https://www.libraw.org/data/LibRaw-0.18.2.tar.gz
RUN tar xzvf LibRaw-0.18.2.tar.gz && rm LibRaw-0.18.2.tar.gz
WORKDIR /root/packages/LibRaw-0.18.2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
RUN /sbin/ldconfig -v

# Install scheduling libraries
RUN pip install --no-cache-dir futures
RUN pip install --no-cache-dir findtools

# Reset our working directory
WORKDIR /
