FROM ghcr.io/ledgerhq/speculos

RUN apt-get update && apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN wget "https://github.com/LedgerHQ/speculos/blob/master/apps/nanos%23btc%232.1%231c8db8da.elf?raw=true" -O /speculos/btc.elf
ADD automation.json /speculos/automation.json

ENTRYPOINT ["python", "./speculos.py", "--automation", "file:automation.json", "--display", "headless", "--vnc-port", "41000", "btc.elf"]
