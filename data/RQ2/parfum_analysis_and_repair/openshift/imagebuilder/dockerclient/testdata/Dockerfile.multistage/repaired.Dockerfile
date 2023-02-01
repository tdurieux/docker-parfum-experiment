FROM alpine as multistagebase
COPY multistage/dir/a.txt /
WORKDIR /tmp
RUN touch /base.txt tmp.txt

FROM multistagebase as second
COPY dir/file /
RUN touch /second.txt

FROM alpine
COPY --from=1 /second.txt /third.txt

FROM alpine
COPY --from=2 /third.txt /fourth.txt

FROM alpine
COPY --from=multistagebase /base.txt /fifth.txt
COPY --from=multistagebase ./tmp/tmp.txt /tmp.txt
# "golang" has a default working directory of /go, and /go/src is a directory
COPY --from=golang         go/src /src

FROM multistagebase as final
COPY copy/script /
RUN touch /final.txt