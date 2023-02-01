FROM mdawar/rq-exporter:latest

USER root

RUN pip install --no-cache-dir gunicorn

USER exporter

ENTRYPOINT ["gunicorn", "rq_exporter:create_app()"]

CMD ["-b", "0.0.0.0:9726", "--threads", "2", "--log-level", "info", "--keep-alive", "3"]