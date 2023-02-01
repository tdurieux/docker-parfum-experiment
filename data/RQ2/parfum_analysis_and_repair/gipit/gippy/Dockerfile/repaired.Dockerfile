FROM developmentseed/geolambda:latest

WORKDIR /build

RUN \
    yum install -y swig; rm -rf /var/cache/yum

COPY requirements*txt /build/
RUN \
    pip2 install --no-cache-dir -r requirements.txt; \
    pip2 install --no-cache-dir -r requirements-dev.txt; \
    pip3 install --no-cache-dir -r requirements.txt; \
    pip3 install --no-cache-dir -r requirements-dev.txt;

COPY . /build
RUN \
    git clean -xfd; \
    pip2 install --no-cache-dir .; \
    git clean -xfd; \
    pip3 install --no-cache-dir .; \
    rm -rf /build/*;

WORKDIR /home/geolambda
