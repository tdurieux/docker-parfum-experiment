FROM debian:10.2 AS first
CMD ["mycmd"]
FROM first
ENTRYPOINT ["myentrypoint"] # This should clear out CMD in the config metadata