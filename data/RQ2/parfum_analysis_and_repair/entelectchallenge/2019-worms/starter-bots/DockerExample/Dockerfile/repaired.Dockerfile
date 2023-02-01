FROM entelectchallenge/base:2019

RUN apt-get update -y

RUN apt-get install --no-install-recommends default-jre -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends default-jdk -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends maven -y && rm -rf /var/lib/apt/lists/*;
