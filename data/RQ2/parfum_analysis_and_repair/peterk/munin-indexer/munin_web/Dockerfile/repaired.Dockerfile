FROM python:3
ENV PYTHONUNBUFFERED 1
RUN apt-get update
RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
RUN mkdir -p /jobs
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/
RUN mkdir /dbbackup
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN yes Y | apt-get install -y --no-install-recommends postgresql-client-10 && rm -rf /var/lib/apt/lists/*;