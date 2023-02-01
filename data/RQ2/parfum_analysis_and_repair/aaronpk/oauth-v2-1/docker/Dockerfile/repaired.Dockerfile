FROM python:3-slim-buster

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir xml2rfc



RUN gem install kramdown
RUN gem install kramdown-rfc2629

WORKDIR /usr/local/bin

COPY convert-v2-1.sh /usr/local/bin/convert-v2-1.sh

WORKDIR /data

ENTRYPOINT [ "/bin/bash","/usr/local/bin/convert-v2-1.sh"]