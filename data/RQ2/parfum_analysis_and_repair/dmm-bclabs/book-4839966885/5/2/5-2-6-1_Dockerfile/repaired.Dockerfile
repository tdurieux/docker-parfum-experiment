FROM ethereum/client-go:v1.8.14

COPY genesis.json /var/share/ethereum/
COPY keystore /var/share/ethereum/keystore/
COPY password /var/share/ethereum/
COPY entrypoint.sh /
RUN chmod 744 /entrypoint.sh

EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["/entrypoint.sh"]