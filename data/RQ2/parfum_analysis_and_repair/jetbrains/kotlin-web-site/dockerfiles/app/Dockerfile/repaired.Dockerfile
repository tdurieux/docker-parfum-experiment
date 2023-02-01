FROM python:3.8-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl git ruby-dev && rm -rf /var/lib/apt/lists/*;

# see markdown.py for kramdown version
RUN gem install kramdown -v 1.14.0

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install --global yarn && npm cache clean --force;

WORKDIR /var/www
COPY requirements.txt package.json yarn.lock ./
RUN pip install --no-cache-dir -r requirements.txt

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

EXPOSE 8080

ENTRYPOINT ["python", "kotlin-website.py"]
