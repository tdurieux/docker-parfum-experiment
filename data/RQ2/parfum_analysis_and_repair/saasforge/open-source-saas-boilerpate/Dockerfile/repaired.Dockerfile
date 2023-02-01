FROM python:3.5-alpine

RUN apk update && \
    apk add --no-cache \
      gcc \
      musl-dev \
      npm \
      postgresql-dev \
      python3-dev

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --requirement requirements.txt

COPY package.json package.json

COPY . /app

RUN npm install --global npm && \
    npm update && \
    npm install && \
    npm run dev && npm cache clean --force;


ENTRYPOINT [ "./entrypoint.sh" ]

CMD [ "run" ]
