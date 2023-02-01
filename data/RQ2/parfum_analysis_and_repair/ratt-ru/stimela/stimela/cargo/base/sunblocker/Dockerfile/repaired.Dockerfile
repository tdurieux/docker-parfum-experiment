FROM stimela/base:1.6.0
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10
RUN apt-get update && apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip setuptools \
    pyyaml
RUN pip install --no-cache-dir scabha
RUN pip install --no-cache-dir -I sunblocker==1.0.1
