FROM python:3.9

ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

COPY package.json requirements.txt .stylelintrc.js .stylelintignore /app/
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN npm install . && npm cache clean --force;
