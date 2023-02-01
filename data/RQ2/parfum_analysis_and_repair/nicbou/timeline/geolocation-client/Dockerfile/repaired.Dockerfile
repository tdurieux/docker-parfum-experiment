FROM python:slim

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "/usr/src/app/main.py"]
