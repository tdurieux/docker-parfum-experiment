FROM scratch
ARG SVC
COPY orb-$SVC /exe
ENTRYPOINT ["/exe"]