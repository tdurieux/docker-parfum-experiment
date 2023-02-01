FROM python:3.6
SHELL ["/bin/bash","-c"]

# Update installation utility
RUN apt-get update -yqq && apt-get install --no-install-recommends -yqq postgresql-client && rm -rf /var/lib/apt/lists/*;

# Create working directory
RUN mkdir /app
WORKDIR /app

# Install the requirements
COPY requirements.txt .
RUN set -x && \
    pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Run the server
EXPOSE 5001 9191
ENTRYPOINT [ "./init-migrate.sh"]
CMD ["flask", "db", "upgrade"]
