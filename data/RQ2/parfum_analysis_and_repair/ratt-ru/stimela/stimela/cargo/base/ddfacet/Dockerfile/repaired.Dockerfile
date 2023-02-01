FROM bhugo/ddfacet:0.6.0
MAINTAINER Ben Hugo "bhugo@ska.ac.za"
RUN pip3 install --no-cache-dir pyyaml
RUN apt install --no-install-recommends xvfb -y && rm -rf /var/lib/apt/lists/*;
COPY xvfb.init.d /etc/init.d/xvfb
RUN chmod 755 /etc/init.d/xvfb
RUN chmod 777 /var/run
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python
ENV DISPLAY :99
RUN DDF.py --help
ENTRYPOINT []
