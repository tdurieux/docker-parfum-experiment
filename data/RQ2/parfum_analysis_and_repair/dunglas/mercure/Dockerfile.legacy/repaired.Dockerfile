FROM gcr.io/distroless/static
COPY mercure /
CMD ["/mercure"]
EXPOSE 80 443