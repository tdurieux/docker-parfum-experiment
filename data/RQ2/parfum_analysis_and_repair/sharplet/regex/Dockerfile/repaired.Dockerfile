FROM swift:4.2

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full lsb-release clang libicu-dev && rm -rf /var/lib/apt/lists/*;
