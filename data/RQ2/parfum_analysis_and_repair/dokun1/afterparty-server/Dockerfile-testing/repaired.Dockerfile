# 1
FROM swift:5.2.4
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
  libssl-dev zlib1g-dev \
  && rm -r /var/lib/apt/lists/*
# 2
WORKDIR /package
# 3
COPY . ./
# 4
RUN swift package resolve
RUN swift package clean
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  libatomic1 libicu60 libxml2 libcurl4 libz-dev libbsd0 tzdata \
  && rm -r /var/lib/apt/lists/*
# 5
CMD ["swift", "test"]
