FROM python:3.6

WORKDIR /app

# Intall dependencies
COPY requirements.txt /app/

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt update && \
  apt install --no-install-recommends -y git ruby-dev nodejs postgresql-client redis-server wkhtmltopdf && \
  apt clean && \
  gem install compass sass && \
  npm -g install less && \
  pip install --no-cache-dir -r requirements.txt && \
  pip install --no-cache-dir redis && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY . /app/

RUN chmod +x /app/entrypoint.sh \
  /app/wait-for-postgres.sh
ENTRYPOINT ["/app/entrypoint.sh"]