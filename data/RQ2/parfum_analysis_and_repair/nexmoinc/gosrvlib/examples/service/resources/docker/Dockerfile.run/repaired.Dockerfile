FROM scratch
ADD ./ /
ENTRYPOINT ["/usr/bin/gosrvlibexample"]