FROM alpine

RUN mkdir -p /some/dir/ && echo 'first' > /some/dir/first.txt

RUN rm /some/dir/first.txt