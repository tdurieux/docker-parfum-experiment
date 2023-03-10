# Build + minify frontend assets.
FROM {{ cookiecutter.project_package }}_app AS frontend

# Python application container.
FROM python:3.7 AS app

WORKDIR /src/app

ARG REQUIREMENTS=requirements.txt

RUN useradd app && chown -R app:app .

COPY ./requirements.* ./
RUN pip install --no-cache-dir -r ${REQUIREMENTS}

COPY --chown=app:app . .

COPY --from=frontend --chown=app:app /src/app/dist ./frontend/dist

USER app

RUN mkdir -p public && python manage.py collectstatic

CMD gunicorn {{ cookiecutter.project_package }}.wsgi --bind 0.0.0.0:8000
