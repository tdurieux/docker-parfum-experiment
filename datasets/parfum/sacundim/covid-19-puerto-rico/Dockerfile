FROM python:3.9-slim AS base

FROM base AS poetry
ARG POETRY_VERSION="1.1.13"
RUN pip install poetry=="${POETRY_VERSION}"


FROM poetry AS requirements
ENV POETRY_VIRTUALENVS_CREATE=false
WORKDIR /covid-19-puerto-rico
COPY pyproject.toml poetry.lock ./
RUN poetry export \
    --without-hashes \
    -f requirements.txt >requirements.txt


FROM requirements AS build
WORKDIR /covid-19-puerto-rico
COPY src src
RUN poetry build


FROM base AS chromium
RUN apt-get update
RUN apt-get install -y chromium-driver
RUN apt-get install -y libmagickwand-dev


FROM chromium AS app
WORKDIR /covid-19-puerto-rico
COPY --from=requirements /covid-19-puerto-rico/requirements.txt ./
RUN pip install -r requirements.txt && rm requirements.txt
COPY --from=build /covid-19-puerto-rico/dist/covid_19_puerto_rico-*.whl .
RUN pip install covid_19_puerto_rico-*.whl && rm covid_19_puerto_rico-*.whl
ENTRYPOINT ["covid19pr"]