FROM minidocks/librsvg
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add graphviz && clean

CMD [ "dot" ]
