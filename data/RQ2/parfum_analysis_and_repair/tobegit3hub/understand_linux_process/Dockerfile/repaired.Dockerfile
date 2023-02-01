FROM ubuntu:14.10
MAINTAINER tobe tobeg3oogle@gmail.com

RUN apt-get -y update

# Install gitbook
RUN apt-get install --no-install-recommends -y curl && \
    curl -f -sL https://deb.nodesource.com/setup | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install gitbook -g && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Add the book
ADD . /understand_linux_process
WORKDIR /understand_linux_process

EXPOSE 4000

CMD ["gitbook", "serve", "."]
