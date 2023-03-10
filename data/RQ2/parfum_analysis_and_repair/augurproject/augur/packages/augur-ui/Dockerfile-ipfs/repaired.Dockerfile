FROM ipfs/go-ipfs:latest

COPY packages/augur-ui/build /export

RUN ipfs init && ipfs add -r /export && chown -R ipfs:users /data

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/start_ipfs"]

# Execute the daemon subcommand by default
CMD ["daemon", "--migrate=true"]