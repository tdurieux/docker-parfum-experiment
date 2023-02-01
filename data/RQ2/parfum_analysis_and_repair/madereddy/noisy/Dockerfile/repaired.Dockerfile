FROM python:alpine
WORKDIR /
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /
ENTRYPOINT ["python", "noisy.py"]
CMD ["--config", "config.json"]

