FROM busybox

COPY . /home/

CMD tail -fn3 .dockerenv