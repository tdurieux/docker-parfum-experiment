FROM ruby:2

# ChromeDriver
RUN apt-get update && apt-get -y --no-install-recommends install xvfb chromedriver && rm -rf /var/lib/apt/lists/*;
ENV PATH $PATH:/usr/lib/chromium

# Go, with build-essential for gcc
RUN apt-get update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
ADD go*.tar.gz /usr/local
ENV PATH $PATH:/usr/local/go/bin
