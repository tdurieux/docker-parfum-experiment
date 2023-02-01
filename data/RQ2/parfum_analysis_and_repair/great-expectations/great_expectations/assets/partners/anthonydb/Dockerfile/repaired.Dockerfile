FROM --platform=linux/amd64 python:3.9-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /app
RUN apt-get update
RUN apt-get install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*;

# deps for mssql
RUN apt-get install --no-install-recommends -y curl apt-transport-https debconf-utils && rm -rf /var/lib/apt/lists/*;
# Add mssql repo
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
# mssql driver
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 mssql-tools && rm -rf /var/lib/apt/lists/*;

# used by requirements.txt: pyodbc, and enables mssql dialect
RUN apt-get install --no-install-recommends -y unixodbc-dev && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
RUN great_expectations -y init
CMD pytest run.py -vvv
