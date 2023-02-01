ARG from_image
FROM ${from_image}

RUN apk add --no-cache build-base
