FROM busybox

# refer to a file that is in the specified user context
ADD .startWithDot /usr/share/.startWithDot

RUN cat /usr/share/.startWithDot

CMD tail -fn3 .dockerenv