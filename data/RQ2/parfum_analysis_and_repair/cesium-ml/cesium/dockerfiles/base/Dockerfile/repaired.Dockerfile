FROM phusion/baseimage:0.9.15

CMD ["/sbin/my_init"]

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-numpy python-scipy \
                       python-matplotlib python-beautifulsoup \
                       python-parse python-yaml rabbitmq-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade






RUN pip install --no-cache-dir -U future cython
RUN pip install --no-cache-dir scikit-learn==0.16.1

# RUN apt-get install -y python3-dev python3-pip python3-numpy \
#                        python3-scipy python3-matplotlib
# RUN pip3 install psutil future cython parse scikit-learn beautifulsoup4 \
#                  flask requests

ENTRYPOINT ["/sbin/my_init", "--"]
