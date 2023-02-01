FROM openjdk:8-jdk

RUN apt update && apt install --no-install-recommends maven -y && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/myapp
COPY compile-function.sh /
