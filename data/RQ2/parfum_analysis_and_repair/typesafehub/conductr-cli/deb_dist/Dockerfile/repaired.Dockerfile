FROM ubuntu:14.10

RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-setuptools && rm -rf /var/lib/apt/lists/*;

RUN easy_install3 pip
RUN pip3 install --no-cache-dir stdeb

# Needed for stdeb
RUN apt-get install --no-install-recommends -y debhelper python-all python3-all && rm -rf /var/lib/apt/lists/*;

WORKDIR /source

# build deb package and change owner of the created files to the original owner
CMD python3 setup.py --command-packages=stdeb.command bdist_deb && chown -R $(stat -c '%u:%g' ./) deb_dist/
