ARG GIT_SHA=local
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7 as base

# Based on https://sourcery.ai/blog/python-docker/
FROM base AS python-deps
ARG GIT_SHA

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Install python dependencies in /.venv
WORKDIR /
COPY Pipfile .
COPY Pipfile.lock .
ENV PIPENV_VENV_IN_PROJECT=1
RUN if [ "$GIT_SHA" = "local" ]; then pipenv install --dev; else pipenv install --deploy; fi


FROM base AS runtime
ARG GIT_SHA

# Copy virtual env from python-deps stage
COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Create and switch to a new user
RUN useradd --create-home appuser
USER appuser

# FastAPI config
ENV PORT=8000
EXPOSE $PORT

#Sentry GITSHA
ENV GIT_SHA=$GIT_SHA

# Install application into container
WORKDIR /
COPY ./app /app
