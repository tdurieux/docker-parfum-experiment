# Start of cached part
FROM python:3.6 as prod_base
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y \
    netcat \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

WORKDIR /bridge_adaptivity

COPY requirements_base.txt ./
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV DJANGO_SETTINGS_MODULE=config.settings.prod

FROM prod_base as stage_base

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -Ur requirements.txt
# Make static media dir:
RUN mkdir -p /www/static

FROM stage_base as local_base

COPY requirements_local.txt ./
RUN pip install --no-cache-dir -r requirements_local.txt
# End of cached part

# Start of not cached part
FROM prod_base as prod

ENTRYPOINT ["gunicorn"]
CMD ["config.wsgi:application", "-w", "2", "-b", ":8000"]
COPY . .
RUN python manage.py collectstatic -v 3 -c --noinput

FROM local_base as local

ENV DJANGO_SETTINGS_MODULE=config.settings.local

ENTRYPOINT ["/bridge_adaptivity/local_run.sh"]

COPY --from=prod /bridge_adaptivity /bridge_adaptivity

FROM stage_base as stage
ENTRYPOINT ["gunicorn"]
CMD ["config.wsgi:application", "-w", "2", "-b", ":8000"]
COPY --from=prod /bridge_adaptivity /bridge_adaptivity
COPY --from=prod /www/static /www/static

# End of not cached part
FROM prod
