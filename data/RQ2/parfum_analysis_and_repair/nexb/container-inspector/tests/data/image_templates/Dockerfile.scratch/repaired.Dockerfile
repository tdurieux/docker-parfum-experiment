FROM scratch
MAINTAINER You Myself and I.
ADD hello /
COPY additions /additions
CMD rm /additions/foo
COPY additions /additions
CMD rm -rf /additions/baz
ADD hello /additions/hello