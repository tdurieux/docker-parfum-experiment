FROM alpine:3.2
ADD userservice /userservice
ENTRYPOINT [ "/userservice" ]
