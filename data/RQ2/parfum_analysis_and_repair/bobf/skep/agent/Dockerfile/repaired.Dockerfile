FROM python:3.9-alpine
RUN pip install --no-cache-dir pipenv \
 && apk add --no-cache --update build-base gcc npm outils-md5 \
 && mkdir /skep
COPY Pipfile Pipfile.lock /skep/
WORKDIR /skep
RUN pipenv sync
ADD build.tar /skep
COPY ./skep/ /skep/skep
CMD ["pipenv", "run", "python", "app.py"]
