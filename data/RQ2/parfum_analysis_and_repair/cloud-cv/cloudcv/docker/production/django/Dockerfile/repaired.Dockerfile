FROM python:2.7
MAINTAINER CloudCV Team
ENV PYTHONUNBUFFERED 1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y

RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN groupadd webapps
RUN useradd cloudcv -G webapps
RUN mkdir -p /var/log/cloudcv/ && chown -R cloudcv /var/log/cloudcv/ && chmod -R u+rX /var/log/cloudcv/
RUN mkdir -p /var/run/cloudcv/ && chown -R cloudcv /var/run/cloudcv/ && chmod -R u+rX /var/run/cloudcv/

WORKDIR /code

COPY /requirements /code/requirements
RUN pip install --no-cache-dir -r requirements/prod.txt

COPY ./ /code/

CMD ["/bin/bash", "/code/docker/production/django/container-start.sh"]
EXPOSE 8000
