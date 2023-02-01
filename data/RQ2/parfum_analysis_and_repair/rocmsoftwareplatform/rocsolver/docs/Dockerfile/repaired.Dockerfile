FROM readthedocs/build:latest

USER root:root
RUN apt-get install -y --no-install-recommends -qq doxygen && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir breathe sphinx sphinx_rtd_theme
