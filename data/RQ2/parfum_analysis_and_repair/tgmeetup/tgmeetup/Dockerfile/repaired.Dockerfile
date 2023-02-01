FROM ubuntu:16.04
ENV LC_ALL=C.UTF-8
RUN apt update && apt install --no-install-recommends python-setuptools git make tree vim python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/TGmeetup/TGmeetup.git
WORKDIR TGmeetup
COPY API.cfg .
RUN sed -i "s/sudo//g" install.sh
RUN make install
