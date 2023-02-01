FROM python:3.7-buster

LABEL "version"="0.1.0"
LABEL "maintainer"="Carlos Pereira Atencio <carlosperate@embeddedlog.com>"
LABEL "repository"="https://github.com/carlosperate/awesome-microbit"
LABEL "homepage"="https://github.com/carlosperate/awesome-microbit"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade --no-cache-dir pipenv
COPY entrypoint.sh Pipfile* /
RUN cd / && pipenv install --dev --system --ignore-pipfile
ENTRYPOINT [ "/entrypoint.sh" ]
