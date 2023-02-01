FROM tensorflow/tensorflow:2.3.0-gpu

ENV PYTHONPATH=/model/

RUN pip install --no-cache-dir importlib_resources

COPY wod_latency_submission/ /model/wod_latency_submission/
