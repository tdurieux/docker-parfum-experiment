# Docker file providing pytest
FROM python:3-alpine

COPY ./requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

VOLUME /src
WORKDIR /src

ENTRYPOINT ["python", "-m", "pytest", "-v"]
CMD ["--help"]