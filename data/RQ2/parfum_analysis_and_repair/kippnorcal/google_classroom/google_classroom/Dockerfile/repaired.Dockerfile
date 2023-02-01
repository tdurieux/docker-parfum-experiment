FROM python:3.7
# SQLSorcery dependencies
RUN wget https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql17/msodbcsql17_17.5.2.1-1_amd64.deb
RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unixodbc unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN yes | dpkg -i msodbcsql17_17.5.2.1-1_amd64.deb
# Python dependencies
RUN pip install --no-cache-dir pipenv
COPY Pipfile .
RUN pipenv install --skip-lock
COPY google_classroom/ google_classroom/
COPY .env .env
WORKDIR /google_classroom
