FROM crossbario/autobahn-testsuite:0.8.2

RUN apt-get update && apt-get install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir wait-for-it

CMD ["wstest", "--mode", "fuzzingserver", "--spec", "/config/fuzzingserver.json"]
