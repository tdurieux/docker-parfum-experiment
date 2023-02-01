FROM python:3.7.6-slim

WORKDIR /elkSyncer/

RUN pip install --no-cache-dir mongo-connector==3.1.1 \
    && pip install --no-cache-dir elasticsearch==7.5.1 \
    && pip install --no-cache-dir elastic2-doc-manager==1.0.0 \
    && pip install --no-cache-dir python-dotenv==0.11.0 \
    && pip install --no-cache-dir certifi==0.0.8

COPY mongo-connector-config.json .
COPY main.py .

CMD ["python", "main.py"]