FROM cardstack/chrome as chrome
FROM portfolio

COPY --from=chrome /opt/google /opt/google
COPY --from=chrome /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
COPY --from=chrome /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu
RUN ln -s /opt/google/chrome/google-chrome /usr/bin/google-chrome
RUN rm -f /etc/log_files.yml

WORKDIR /srv/hub
COPY . ./
CMD yarn lint && yarn test