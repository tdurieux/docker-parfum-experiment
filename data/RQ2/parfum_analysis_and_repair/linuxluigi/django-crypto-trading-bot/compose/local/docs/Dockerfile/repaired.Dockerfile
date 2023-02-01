FROM python:3.10-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
    # dependencies for building Python packages \
    && apt-get install --no-install-recommends -y build-essential \
    # psycopg2 dependencies
    && apt-get install --no-install-recommends -y libpq-dev \
    # Translations dependencies
    && apt-get install --no-install-recommends -y gettext \
    # Uncomment below lines to enable Sphinx output to latex and pdf
    # && apt-get install -y texlive-latex-recommended \
    # && apt-get install -y texlive-fonts-recommended \
    # && apt-get install -y texlive-latex-extra \
    # && apt-get install -y latexmk \
    # cleaning up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
# All imports needed for autodoc.
RUN pip install --no-cache-dir -r /requirements/local.txt -r

WORKDIR /docs

CMD make livehtml