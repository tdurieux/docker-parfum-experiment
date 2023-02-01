FROM python:2.7
MAINTAINER "Shekhar Gulati"
RUN apt-get update -y && apt-get install --no-install-recommends cron -yqq && rm -rf /var/lib/apt/lists/*;
COPY crontab /tmp/my_cron
COPY run-crond.sh run-crond.sh
RUN chmod -v +x /run-crond.sh
RUN touch /var/log/cron.log
ENV APP_DIR /app
COPY app.py requirements.txt $APP_DIR/
WORKDIR $APP_DIR
RUN pip install --no-cache-dir -r requirements.txt
# Run the command on container startup
CMD ["/run-crond.sh"]
