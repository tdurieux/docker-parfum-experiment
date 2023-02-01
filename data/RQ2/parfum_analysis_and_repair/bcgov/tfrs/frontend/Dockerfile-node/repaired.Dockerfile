FROM node:8-jessie
RUN mkdir /app
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
ADD https://github.com/vishnubob/wait-for-it/compare/master...HEAD /dev/null
RUN git clone https://github.com/vishnubob/wait-for-it.git /wfi