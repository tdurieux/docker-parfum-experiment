FROM alpine
COPY . /code
RUN apk add --no-cache gcc libc-dev git make ncurses
WORKDIR code
