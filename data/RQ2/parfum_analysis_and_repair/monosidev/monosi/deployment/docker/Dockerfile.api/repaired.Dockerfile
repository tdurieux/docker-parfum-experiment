FROM python:3.9
WORKDIR /app

COPY ./requirements.txt ./
COPY ./requirements.api.txt ./
COPY ./src .
RUN rm -rf ./src/ui
RUN pip install --no-cache-dir -r ./requirements.txt
RUN pip install --no-cache-dir -r ./requirements.api.txt

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server.wsgi:app"]
