FROM rasa/rasa:1.10.0-full

COPY setup.py .
COPY requirements.txt .
COPY data /data
COPY nlu_hyperopt /nlu_hyperopt
COPY scripts /scripts

# Be root
USER root

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r requirements.txt && chmod -R +x /scripts

ENV PYTHONPATH "/"

ENTRYPOINT ["python"]

CMD ["-m", "nlu_hyperopt.app"]
