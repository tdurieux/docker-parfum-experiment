FROM python:3.7

# Create app directory
WORKDIR /usr/src/app

# Copy app to directory
COPY . /usr/src/app

# newer versions of tox fail on circleci for some reason
# https://discuss.circleci.com/t/python-tox-doesnt-build-anymore/35059
RUN pip install --no-cache-dir tox==3.15.0
RUN pip install --no-cache-dir -r requirements.txt

CMD ["make", "test"]

