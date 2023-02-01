FROM python:3.6-slim
RUN mkdir -p ~/.kube && apt-get update && apt-get install --no-install-recommends -y curl && pip install --no-cache-dir --upgrade kubernetes && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://sdk.cloud.google.com | bash
RUN pip install --no-cache-dir --upgrade google-cloud-bigquery
RUN mkdir -p /opt/cron
COPY bigquery_user_info_updater /opt/cron/bigquery_user_info_updater
COPY bigquery_user_updater.sh /opt/cron/
CMD printenv >> /etc/environment && cron && tail -f /var/log/cron.log
