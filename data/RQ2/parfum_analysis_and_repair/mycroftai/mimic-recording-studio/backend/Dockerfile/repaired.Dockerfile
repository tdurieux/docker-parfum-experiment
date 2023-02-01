# TODO
FROM python:3.6-alpine3.6

COPY requirements.txt /src/
WORKDIR /src
RUN apk update
RUN apk add --no-cache ffmpeg make automake gcc g++ subversion python3-dev
RUN pip install --no-cache-dir -r requirements.txt
CMD ["sh", "start_prod.sh"]
