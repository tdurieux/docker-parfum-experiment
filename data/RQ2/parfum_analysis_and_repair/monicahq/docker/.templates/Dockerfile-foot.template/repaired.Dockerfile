COPY entrypoint.sh \
    queue.sh \
    cron.sh \
    /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["%%CMD%%"]