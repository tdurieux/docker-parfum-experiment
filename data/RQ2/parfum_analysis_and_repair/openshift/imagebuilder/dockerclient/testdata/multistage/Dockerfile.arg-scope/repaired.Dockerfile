FROM alpine
ARG SECRET
RUN echo "$SECRET"

FROM alpine
ARG FOO=test
ARG BAR=bartest
RUN echo "$FOO:$BAR"
RUN echo "$SECRET"