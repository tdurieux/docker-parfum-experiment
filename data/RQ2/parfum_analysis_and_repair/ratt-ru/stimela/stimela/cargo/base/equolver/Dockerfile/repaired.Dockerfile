FROM stimela/base:1.6.0
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10
RUN apt-get update
RUN pip3 install --no-cache-dir -U pip setuptools \
    pyyaml
RUN pip install --no-cache-dir scabha
RUN pip install --no-cache-dir -I equolver==0.0.8
RUN pip install --no-cache-dir https://www.astro.rug.nl/software/kapteyn/kapteyn-3.0.tar.gz
RUN equolver -h -v
