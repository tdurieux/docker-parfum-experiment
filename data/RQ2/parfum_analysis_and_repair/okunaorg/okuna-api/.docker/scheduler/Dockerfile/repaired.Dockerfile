FROM python:3.7.3

RUN apt-get -y update && apt-get -y upgrade && apt-get install --no-install-recommends -y ffmpeg && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

COPY wait-for-it.sh /wait-for-it.sh

# Copy any files over
COPY entrypoint.sh /entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Change permissions
RUN chmod +x /entrypoint.sh
RUN chmod +x /wait-for-it.sh

ENTRYPOINT ["/entrypoint.sh"]

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

VOLUME ["/opt/okuna-api"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]