FROM python:3.8

ENV PYTHONUNBUFFERED 1
RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y gettext python3-dev libpq-dev wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

# githubusercontent 无法访问，使用 jsdelivr 加速
# 从 Gitub 下载 realease 非常慢，使用 fastgit 镜像加速
RUN curl -f -sSL https://cdn.jsdelivr.net/gh/python-poetry/poetry/get-poetry.py | sed 's+https://github.com/python-poetry/poetry+https://download.fastgit.org/python-poetry/poetry+g' | sed 's+https://github.com/sdispater/poetry/releases/download/+https://download.fastgit.org/python-poetry/poetry/releases/download/+g' | python -
ENV PATH "/root/.poetry/bin:${PATH}"
RUN poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml /app/
RUN poetry install --no-root --no-interaction

COPY ./compose/local/django/celery/worker/start.sh /start-celeryworker.sh
RUN sed -i 's/\r$//g' /start-celeryworker.sh
RUN chmod +x /start-celeryworker.sh

COPY ./compose/local/django/celery/beat/start.sh /start-celerybeat.sh
RUN sed -i 's/\r$//g' /start-celerybeat.sh
RUN chmod +x /start-celerybeat.sh