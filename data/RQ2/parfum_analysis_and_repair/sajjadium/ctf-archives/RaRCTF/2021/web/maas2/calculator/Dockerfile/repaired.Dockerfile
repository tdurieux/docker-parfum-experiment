FROM python:alpine3.8
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
COPY app.py app.py
COPY flag.txt /flag.txt
ENTRYPOINT ["python", "app.py"]
