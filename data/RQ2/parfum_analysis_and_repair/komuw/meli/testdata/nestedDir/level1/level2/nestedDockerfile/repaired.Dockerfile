FROM busybox

# refer to a file that is in the specified user context
ADD file2 /usr/share/file2

CMD tail -fn3 .dockerenv