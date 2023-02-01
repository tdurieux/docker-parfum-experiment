FROM python:3

LABEL maintainer="AnhellO"

WORKDIR /usr/src/app
COPY find.py .
COPY populate.py .

RUN pip install --no-cache-dir pymongo

CMD python ./populate.py ; python ./find.py