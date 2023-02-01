FROM python:version-number
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk
RUN pipenv install --dev --skip-lock
RUN pip --version
ENTRYPOINT ["sh", "-c","pipenv run tests"]
