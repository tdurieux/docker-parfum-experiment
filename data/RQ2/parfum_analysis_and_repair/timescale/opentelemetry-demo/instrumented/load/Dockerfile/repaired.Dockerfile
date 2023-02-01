FROM python:latest
WORKDIR /code
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY load.py .
CMD ["python3", "load.py"]
