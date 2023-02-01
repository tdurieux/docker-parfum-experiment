FROM python:3.8

RUN apt update && apt install --no-install-recommends -y bedtools bcftools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir torch networkx

RUN git clone https://github.com/lgmgeo/AnnotSV.git --branch v2.3
WORKDIR /AnnotSV
RUN make PREFIX=. install

ENV ANNOTSV=/AnnotSV

RUN pip install --no-cache-dir deepsvp