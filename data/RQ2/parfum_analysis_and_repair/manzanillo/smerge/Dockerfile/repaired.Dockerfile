# SMERGE
# Version: 1.0
FROM python:3
# Install Python and Package Libraries
RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
RUN apt-get install --no-install-recommends -y \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    net-tools && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
# Project Files and Settings
ARG PROJECT=snapmerge
ARG PROJECT_DIR=/var/www/${PROJECT}
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN npm install && npm cache clean --force;
# Server
EXPOSE 8000
STOPSIGNAL SIGINT
RUN chmod +x ./entrypoint.sh
RUN ./entrypoint.sh
ENTRYPOINT ["python", "snapmerge/manage.py"]
CMD ["runserver", "0.0.0.0:8000", "--settings=config.settings_docker"]