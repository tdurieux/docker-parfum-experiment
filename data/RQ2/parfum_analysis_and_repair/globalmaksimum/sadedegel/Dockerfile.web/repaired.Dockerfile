FROM python:3.8-slim
RUN pip install --no-cache-dir sadedegel==0.11.3

CMD python -m sadedegel.server --port $PORT