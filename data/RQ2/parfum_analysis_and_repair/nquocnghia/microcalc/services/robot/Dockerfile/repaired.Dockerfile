FROM python:3-alpine

RUN pip install --no-cache-dir requests robotframework robotframework-requests

COPY . /app
WORKDIR /app
VOLUME /results

CMD ["robot", "--outputdir=/results", "tests.robot"]