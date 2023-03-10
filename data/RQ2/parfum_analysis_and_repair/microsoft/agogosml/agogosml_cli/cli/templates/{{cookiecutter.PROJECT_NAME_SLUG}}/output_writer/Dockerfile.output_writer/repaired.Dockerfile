ARG CONTAINER_REG
ARG AGOGOSML_TAG="latest"

FROM ${CONTAINER_REG}agogosml:${AGOGOSML_TAG} as builder

# Copy the app
WORKDIR /usr/src/agogosml
COPY . ./output_writer

# Add SSL Certificate
RUN apk add --no-cache ca-certificates

# Release
FROM ${CONTAINER_REG}agogosml:${AGOGOSML_TAG} AS output_writer

WORKDIR /output_writer
COPY --from=builder /usr/src/agogosml/output_writer /output_writer

CMD ["python", "main.py"]
