FROM debian:10.2
CMD ["command", "one"]
CMD ["command", "two"]
CMD echo "hello"

ENTRYPOINT ["execute", "something"]
ENTRYPOINT ["execute", "entrypoint"]