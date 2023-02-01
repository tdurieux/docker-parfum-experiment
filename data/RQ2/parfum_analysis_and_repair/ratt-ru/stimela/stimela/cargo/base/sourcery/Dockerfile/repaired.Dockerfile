FROM stimela/base:1.2.0
RUN docker-apt-install pybdsf python-astro-tigger-lsm
RUN pip install --no-cache-dir git+git://github.com/radio-astro/sourcery
