FROM python:3.8
COPY . .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir elasticsearch
ENTRYPOINT ["python", "transfer.py"]