FROM debian:9-slim

RUN apt update && apt install --no-install-recommends curl jq -y && rm -rf /var/lib/apt/lists/*;
RUN groupadd -r user && useradd -m --no-log-init -r -g user user

USER user
COPY --chown=user:user gen.sh /home/user/
RUN chmod +x /home/user/gen.sh

CMD ["/home/user/gen.sh"]