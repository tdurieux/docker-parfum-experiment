FROM pierreprinetti/wp-cli

# ENV PATH $PATH:/bin
RUN set -x \
      && apk add --no-cache --update bash jq curl

COPY ./scripts/ /scripts

ENTRYPOINT [""]

CMD ["echo"]
