FROM ubuntu

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y openjdk-7-jre wget python-pip
#RUN wget -qO- get.nextflow.io | bash
#ADD nextflow.config /

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://get.docker.com | sudo sh

ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# supply a default config
ADD endofday.conf /endofday.conf

ADD core /core
ADD tests /tests

ENV STAGING /staging
ENV STAGING_DIR /staging
# WORKDIR /staging

ENTRYPOINT ["/core/endofday.sh"]
