FROM continuumio/miniconda3
WORKDIR /home
RUN pip install --no-cache-dir awscli boto3 mysql-connector
COPY entry.py .
ENTRYPOINT ["python", "entry.py"]
