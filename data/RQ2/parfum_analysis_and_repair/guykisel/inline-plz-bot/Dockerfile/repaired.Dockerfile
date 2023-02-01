FROM tiangolo/uwsgi-nginx-flask:flask

COPY * /app

RUN curl -f -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get update && apt-get install --no-install-recommends -y ruby-full haskell-platform shellcheck nodejs build-essential nodejs-legacy && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r /app/requirements.txt
