FROM alpine
WORKDIR /subdir
COPY file1.txt /subdir
RUN ls