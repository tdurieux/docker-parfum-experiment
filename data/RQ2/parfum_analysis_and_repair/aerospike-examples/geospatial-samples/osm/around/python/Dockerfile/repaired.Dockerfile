FROM python:2.7
RUN apt-get update && apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["/code/docker-entrypoint.sh"]
CMD ["python"]
