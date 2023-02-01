FROM python:3.8.6

WORKDIR /app
COPY . /app

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 && rm -rf /var/lib/apt/lists/*;

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN apt-get install --no-install-recommends -y unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgssapi-krb5-2 && rm -rf /var/lib/apt/lists/*;

# Install Poetry
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# Copy using poetry.lock* in case it doesn't exist yet
COPY ./pyproject.toml ./poetry.lock* /app/

RUN poetry install --no-root --no-dev

ENV MODULE_NAME=app.main

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

EXPOSE 80 2222
