FROM ubuntu:xenial

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        python3 \
        python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /kuyruk

# install test requirements
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# install project requirements
ADD setup.py MANIFEST.in README.rst ./
RUN mkdir kuyruk && touch kuyruk/__init__.py
RUN pip3 install --no-cache-dir -e .

# add test and package files
ADD tests tests
ADD kuyruk kuyruk
ADD setup.cfg setup.cfg
ADD test_config_docker.py /tmp/kuyruk_config.py

# run tests
ENTRYPOINT ["pytest", "-v", "--cov=kuyruk"]
CMD ["tests/"]
