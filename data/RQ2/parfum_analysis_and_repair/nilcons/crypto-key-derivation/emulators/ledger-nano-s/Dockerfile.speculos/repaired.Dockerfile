FROM ledgerhq/speculos
RUN apt-get update && apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN mkdir /ledger-cli
WORKDIR /ledger-cli
RUN npm install ledger-live && npm cache clean --force;
RUN echo '#!/bin/bash\n\
set -e\n\
python /speculos/speculos.py --model nanos --seed "$1" --apdu-port 40000 --display headless -l Bitcoin:/apps/btc.elf /apps/$2.elf >/speculos.log 2>&1 &\n\
SPECULOS_APDU_PORT=40000 node_modules/ledger-live/bin/index.js sync -f basic -c $2\n\
' >/get-address.sh
COPY apps-out /apps
ENTRYPOINT [ "bash", "/get-address.sh" ]
