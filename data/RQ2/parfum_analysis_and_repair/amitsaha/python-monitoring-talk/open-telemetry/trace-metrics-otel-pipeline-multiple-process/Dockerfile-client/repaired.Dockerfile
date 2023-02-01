FROM python:3.9
RUN apt-get -y update && apt-get -y --no-install-recommends install apache2-utils && rm -rf /var/lib/apt/lists/*;
ADD ./make-requests.sh /make-requests.sh

CMD ["/bin/sh", "/make-requests.sh"]
