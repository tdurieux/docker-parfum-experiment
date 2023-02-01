FROM python:2.7-slim-stretch
WORKDIR /
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /
ENTRYPOINT ["python", "noisy.py"]
CMD ["--config", "config.json"]
