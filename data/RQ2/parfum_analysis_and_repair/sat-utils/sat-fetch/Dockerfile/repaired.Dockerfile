FROM developmentseed/geolambda:1.1.0-python36

# install requirements
WORKDIR /build
COPY requirements*txt /build/
RUN \
    pip install --no-cache-dir -r requirements.txt; \
    pip install --no-cache-dir -r requirements-dev.txt

# install app
COPY . /build
RUN \
    pip install --no-cache-dir . -v; \
    rm -rf /build/*;

WORKDIR /home/geolambda
