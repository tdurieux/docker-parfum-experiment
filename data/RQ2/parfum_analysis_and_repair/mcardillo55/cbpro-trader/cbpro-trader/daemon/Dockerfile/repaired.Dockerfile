FROM ubuntu:18.04

# Set locale
ENV LANG C.UTF-8
# Allow for curses interface
ENV TERM xterm

# Update Ubuntu & install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip git locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


# Build and install ta-lib
ADD https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz /
RUN tar xzvf ta-lib-0.4.0-src.tar.gz && rm ta-lib-0.4.0-src.tar.gz
WORKDIR /ta-lib/
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr
RUN make
RUN make install

# Copy bot files
RUN mkdir -p /cbpro-trader
COPY ./requirements.txt /

# Install Python dependencies
WORKDIR /
RUN pip3 install --no-cache-dir numpy==1.15.2
RUN pip3 install --no-cache-dir -r ./requirements.txt
WORKDIR /cbpro-trader/