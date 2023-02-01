FROM mosquito/fpm:debian8

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip virtualenv sh plumbum
RUN apt-get install --no-install-recommends -y \
    libcurl4-openssl-dev \
    libffi-dev \
    libmysqlclient-dev \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev && rm -rf /var/lib/apt/lists/*;
