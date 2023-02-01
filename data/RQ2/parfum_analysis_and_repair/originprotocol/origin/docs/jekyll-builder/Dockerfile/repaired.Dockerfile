FROM gcr.io/cloud-builders/gcloud-slim

RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev build-essential zlib1g zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install jekyll bundler

ENTRYPOINT ["bundle"]
