FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install --no-install-recommends -y curl bash \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -

RUN apt-get update && apt-get install --no-install-recommends -y git python3-dev gcc nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g serverless && npm cache clean --force;

RUN pip install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir awscli --upgrade --user --no-warn-script-locatio

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app app/

EXPOSE 5562

# ENTRYPOINT ["python", "app/server.py"]
