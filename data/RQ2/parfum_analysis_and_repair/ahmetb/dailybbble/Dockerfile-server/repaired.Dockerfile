FROM python:2.7
RUN apt-get -qqy update && \
	apt-get -qqy --no-install-recommends install libmemcached-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR	/app
COPY	requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY	. /app

CMD	["python", "./runserver.py"]
EXPOSE	5000/tcp
