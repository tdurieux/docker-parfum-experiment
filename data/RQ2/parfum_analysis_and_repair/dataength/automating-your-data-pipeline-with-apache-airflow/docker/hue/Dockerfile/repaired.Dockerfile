FROM gethue/hue:4.4.0

RUN apt-get update && \
    apt-get install --no-install-recommends -yqq \
    netcat && rm -rf /var/lib/apt/lists/*;

COPY ./entrypoint.sh .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["./startup.sh"]