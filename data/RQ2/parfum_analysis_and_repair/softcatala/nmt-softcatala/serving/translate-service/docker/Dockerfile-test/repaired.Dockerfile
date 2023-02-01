FROM translate-service

RUN apt-get install --no-install-recommends httping -y && rm -rf /var/lib/apt/lists/*;
COPY serving/translate-service/api-tst /srv/api-tst
COPY serving/translate-service/docker/entry-point.sh /srv/
COPY serving/translate-service/docker/entry-point-test.sh /srv/
RUN pip install --no-cache-dir -r /srv/api-tst/requirements.txt

ENTRYPOINT bash /srv/entry-point-test.sh

