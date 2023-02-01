FROM paulinus/opensfm-docker-base:python3

COPY . /source/OpenSfM

WORKDIR /source/OpenSfM

RUN pip3 install --no-cache-dir -r requirements.txt && \
    python3 setup.py build
