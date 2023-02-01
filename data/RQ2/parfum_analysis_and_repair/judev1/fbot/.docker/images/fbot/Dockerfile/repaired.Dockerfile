FROM alpine:latest
WORKDIR /usr/src/app
RUN apk update
RUN apk add --no-cache bash git build-base python3-dev imagemagick jpeg-dev zlib-dev freetype-dev
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --no-cache --upgrade pip setuptools
RUN pip install --no-cache-dir discord dblpy dbfn python-dotenv nest_asyncio wand pillow requests
COPY . .

CMD [ "python3", "app.py" ]