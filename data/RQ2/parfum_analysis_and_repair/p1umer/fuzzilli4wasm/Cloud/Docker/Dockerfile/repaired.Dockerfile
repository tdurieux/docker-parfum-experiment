FROM swift:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=bash

RUN apt-get -y update && apt-get install --no-install-recommends -y libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

# Required for jsc


RUN mkdir /home/fuzzer
WORKDIR /home/fuzzer

# Add JavaScriptCore binary
ADD JSCBuilder/out jsc
# Add Spidermonkey binary
ADD SpidermonkeyBuilder/out spidermonkey
# Add v8 binary
ADD V8Builder/out v8
# Add duktape binary
ADD DuktapeBuilder/out duktape
# Add JerryScript binary
ADD JerryScriptBuilder/out jerryscript

# Add Fuzzilli binaries
ADD FuzzilliBuilder/out/Fuzzilli Fuzzilli
ADD FuzzilliBuilder/out/REPRLRun REPRLRun
ADD FuzzilliBuilder/out/Benchmarks Benchmarks

RUN mkdir fuzz
