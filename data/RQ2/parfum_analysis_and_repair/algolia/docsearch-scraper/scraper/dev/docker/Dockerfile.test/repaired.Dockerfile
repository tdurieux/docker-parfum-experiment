FROM algolia/docsearch-scraper-base
LABEL maintainer="docsearch@algolia.com"

WORKDIR /root

# Copy DocSearch files
COPY . .
RUN touch .env
ENTRYPOINT ["pipenv", "run", "./docsearch", "test", "no_browser"]