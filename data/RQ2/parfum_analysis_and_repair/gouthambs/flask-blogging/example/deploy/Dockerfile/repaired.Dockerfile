FROM python:3.4
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
ADD docker-requirements.txt /app/
RUN apt-get update && apt-get install -y --no-install-recommends sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r docker-requirements.txt
ADD . /app/