FROM python

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends apt-transport-https ca-certificates -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get --no-install-recommends install msodbcsql17 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends unixodbc-dev -y && rm -rf /var/lib/apt/lists/*;

COPY ./features/ /app/features
COPY ./simqle /app/simqle
COPY ./setup.py /app
COPY ./test-requirements.txt /app
COPY ./README.md /app
COPY ./.coveragerc /app

RUN pip install --no-cache-dir -r test-requirements.txt
RUN pip install --no-cache-dir .
