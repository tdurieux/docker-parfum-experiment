FROM python:3.6

WORKDIR /itbapp

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt


ENTRYPOINT ["sh"]
