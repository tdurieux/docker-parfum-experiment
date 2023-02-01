FROM becheran/mlc:0.15.2

LABEL repository="https://github.com/becheran/mlc"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY LICENSE README.md /

ENTRYPOINT ["/entrypoint.sh"]