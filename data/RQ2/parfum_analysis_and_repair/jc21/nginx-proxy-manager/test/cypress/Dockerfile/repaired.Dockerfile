FROM cypress/included:5.6.0

COPY --chown=1000 ./ /test

# mkcert
ENV MKCERT=1.4.2
RUN wget -O /usr/bin/mkcert "https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT}/mkcert-v${MKCERT}-linux-amd64" \
	&& chmod +x /usr/bin/mkcert

WORKDIR /test
RUN yarn install && yarn cache clean;
ENTRYPOINT []
CMD ["cypress", "run"]
