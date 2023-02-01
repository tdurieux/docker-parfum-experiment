FROM python:3.6
WORKDIR /code

RUN apt-get update && apt-get install --no-install-recommends -y \
    nginx apache2-utils && rm -rf /var/lib/apt/lists/*;

Add requirements.txt /code
RUN pip3 install --no-cache-dir -r requirements.txt

ADD chaperone.conf /etc/chaperone.d/chaperone.conf
ADD scrapyd.conf /etc/scrapyd/scrapyd.conf
ADD nginx.conf /etc/nginx/sites-enabled/default


EXPOSE 6810
ENTRYPOINT ["/usr/local/bin/chaperone"]