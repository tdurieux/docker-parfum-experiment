FROM gcr.io/distroless/static

USER nonroot:nonroot

COPY build/functions /bin/functions

EXPOSE 5555

CMD ["/bin/functions"]