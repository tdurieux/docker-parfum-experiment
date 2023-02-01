FROM klokantech/supervisord

COPY . /usr/local/src/hawk/

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install \
    python-pip \
    uwsgi \
    uwsgi-plugin-python \
&& pip install --no-cache-dir -q -r /usr/local/src/hawk/requirements.txt && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000

COPY supervisord.conf /etc/supervisord/
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf"]
