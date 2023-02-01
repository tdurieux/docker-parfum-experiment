FROM python:3.6.3

RUN apt-get update

RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y less && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir spacy
RUN python -m spacy download en_core_web_md
RUN find /usr/local/lib/python3.6 -name oov_prob -exec sed -i '1 s/-[0-9.]*/-100000000/g' {} \;
RUN pip install --no-cache-dir mqtag==0.6.6

COPY ./mqgo/bin/linux_amd64/* /usr/local/bin/
