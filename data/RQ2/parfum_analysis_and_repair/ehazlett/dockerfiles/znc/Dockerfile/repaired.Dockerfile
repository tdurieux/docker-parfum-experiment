FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y znc && rm -rf /var/lib/apt/lists/*;
RUN useradd znc
USER znc
EXPOSE 6667
ENTRYPOINT ["znc"]
CMD ["exec", "znc", "-f"]
