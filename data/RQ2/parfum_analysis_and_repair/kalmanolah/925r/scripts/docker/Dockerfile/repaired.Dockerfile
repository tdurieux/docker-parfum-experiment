FROM python:3.5
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
RUN apt-get update && apt-get install --no-install-recommends -y python-dev libldap2-dev libsasl2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/
