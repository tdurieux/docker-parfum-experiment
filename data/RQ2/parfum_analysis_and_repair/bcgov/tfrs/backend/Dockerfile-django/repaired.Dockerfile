FROM python:3.7-stretch
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y git supervisor && rm -rf /var/lib/apt/lists/*;
ADD https://github.com/vishnubob/wait-for-it/compare/master...HEAD /dev/null
RUN git clone https://github.com/vishnubob/wait-for-it.git /wfi
