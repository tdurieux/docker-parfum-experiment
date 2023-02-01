FROM load/yandex-tank-pip:testing
WORKDIR /yandextank
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pytest
CMD pip3 install . && pytest -s
# docker run -v /path/to/yandextank:/yandextank --name my_container my_image
