FROM python:3
RUN pip3 install --no-cache-dir kfp
WORKDIR /app
ADD pipeline.py .
RUN chmod +x pipeline.py
