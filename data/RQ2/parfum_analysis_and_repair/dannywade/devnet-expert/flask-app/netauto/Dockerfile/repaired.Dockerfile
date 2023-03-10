FROM python:3.9.10-slim-buster

COPY . /netauto
WORKDIR /netauto
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080:5000

ENTRYPOINT [ "python", "app.py" ]