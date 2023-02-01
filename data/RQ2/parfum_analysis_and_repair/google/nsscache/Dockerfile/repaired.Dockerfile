FROM python:3
RUN apt-get update && apt-get install --no-install-recommends -y libnss-db libsasl2-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/

CMD [ "python", "./runtests.py" ]
