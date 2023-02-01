FROM debian:stretch

COPY stretch_deps.sh /deps.sh
RUN /deps.sh && rm /deps.sh
VOLUME /walletcrx
CMD cd /walletcrx && ./makePackages.sh
