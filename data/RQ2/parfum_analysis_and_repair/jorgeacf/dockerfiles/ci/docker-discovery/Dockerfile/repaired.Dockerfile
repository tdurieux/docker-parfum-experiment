FROM fedora:latest

RUN dnf install -y python python-pip

WORKDIR /app

COPY app/* /app/

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]
