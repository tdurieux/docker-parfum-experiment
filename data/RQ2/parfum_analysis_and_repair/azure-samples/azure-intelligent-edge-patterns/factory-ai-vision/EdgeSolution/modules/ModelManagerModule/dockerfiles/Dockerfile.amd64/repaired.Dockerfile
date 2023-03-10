FROM python:3.8.6-slim-buster

COPY app/entry.sh /app/
COPY app/workspace /app/workspace/

COPY app/requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY app/cascade/*.py /app/cascade/
COPY app/*.py /app/
COPY app/downloader /app/downloader/

EXPOSE 8585

WORKDIR /app/
ENTRYPOINT ["bash", "entry.sh"]
