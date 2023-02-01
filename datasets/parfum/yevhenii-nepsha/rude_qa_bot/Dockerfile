FROM python:3.7-slim-stretch as builder

WORKDIR /opt/app

COPY ["build", "Pipfile.lock", "Pipfile", "./"]
RUN ./pipenv-install.sh && ./cleanup.sh

FROM python:3.7-slim-stretch

WORKDIR /opt/app

COPY --from=builder ["/usr/local/lib/python3.7/site-packages", "/usr/local/lib/python3.7/site-packages"]

COPY ["src", "./"]

CMD ["python", "-u", "/opt/app/app.py"]
