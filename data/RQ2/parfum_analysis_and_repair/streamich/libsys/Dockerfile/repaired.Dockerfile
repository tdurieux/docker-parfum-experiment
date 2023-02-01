FROM ubuntu:18.10

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
