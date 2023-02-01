FROM python:2.7-alpine

WORKDIR /root/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY index.py .

CMD ["python", "-u", "index.py"]
