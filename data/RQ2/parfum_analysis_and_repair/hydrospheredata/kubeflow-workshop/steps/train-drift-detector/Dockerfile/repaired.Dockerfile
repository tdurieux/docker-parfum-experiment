FROM python:3.7-slim

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir boto3~=1.9.197
RUN pip install --no-cache-dir tensorflow~=1.13.1
RUN pip install --no-cache-dir wo~=0.1.5
RUN pip install --no-cache-dir mlflow==1.4.0

COPY *.py /src/
WORKDIR /src/

ENTRYPOINT [ "python", "train_drift_detector.py" ]
