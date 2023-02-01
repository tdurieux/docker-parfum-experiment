FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

RUN mkdir -p /app/storage/mlruns && touch mlflow-history.db

RUN pip install --no-cache-dir mlflow
RUN pip install --no-cache-dir pysftp

ENV SFTP_HOST=sftp.mlflow
RUN mkdir -p /root/.ssh

EXPOSE 5000

RUN chmod +x ./mlflow-entrypoint.sh

ENTRYPOINT [ "./mlflow-entrypoint.sh"]