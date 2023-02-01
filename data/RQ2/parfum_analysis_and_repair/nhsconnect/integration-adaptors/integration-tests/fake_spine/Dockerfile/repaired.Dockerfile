FROM python:3.7-slim
RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/src/app/mhs/fakespine && rm -rf /usr/src/app/mhs/fakespine
RUN pip install --no-cache-dir pipenv
COPY common/ /usr/src/app/common/
COPY integration-tests/fake_spine/ /usr/src/app/mhs/fakespine
WORKDIR /usr/src/app/mhs/fakespine
COPY integration-tests/fake_spine/Pipfile /usr/src/app
COPY integration-tests/fake_spine/Pipfile.lock /usr/src/app
RUN pip install --no-cache-dir pipenv
RUN pipenv install --deploy --ignore-pipfile
COPY . .
EXPOSE 80 443
ENTRYPOINT ["pipenv", "run", "start", "--logging=DEBUG"]
