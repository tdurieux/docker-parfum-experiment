FROM python:2

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /usr/src/app/
WORKDIR /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED 1
EXPOSE 8000

COPY ampcrowd/docker-entrypoint.sh /usr/src/app/ampcrowd
ENTRYPOINT ["bash", "ampcrowd/docker-entrypoint.sh"]
CMD ["-s", "-f"]

