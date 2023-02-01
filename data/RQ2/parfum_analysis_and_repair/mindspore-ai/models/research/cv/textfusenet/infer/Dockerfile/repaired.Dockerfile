ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}

RUN ln -s  /usr/local/python3.7.5/bin/python3.7 /usr/bin/python

RUN apt-get update && \
    apt-get install --no-install-recommends libglib2.0-dev -y && \
    apt-get install -y --no-install-recommends libgeos-dev && \
    pip install --no-cache-dir pytest-runner==5.3.0 && rm -rf /var/lib/apt/lists/*;
COPY sdk/requirements.txt .
RUN pip3.7 install -r requirements.txt
