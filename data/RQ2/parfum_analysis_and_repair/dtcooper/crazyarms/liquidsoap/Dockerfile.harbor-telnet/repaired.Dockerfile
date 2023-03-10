FROM tsl0922/ttyd:alpine

# Add in rlwrap to enable arrow keys
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ rlwrap

CMD ["ttyd", "-t", "titleFixed=Harbor Telnet", "rlwrap", "--no-warnings", "sh", "-c", "echo '# Welcome to the Harbor telnet. Enter \"help\" + [ENTER] for more info.' && exec nc harbor 1234"]