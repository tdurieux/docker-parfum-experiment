FROM paulinus/opensfm-docker-base

COPY . /source/OpenSfM

WORKDIR /source/OpenSfM

RUN pip install --no-cache-dir -r requirements.txt && \
    python setup.py build
