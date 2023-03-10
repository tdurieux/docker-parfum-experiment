FROM francken/php-base

COPY queue.sh /usr/local/bin/run-queue
RUN chmod u+x /usr/local/bin/run-queue

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER $USER_ID

CMD ["/usr/local/bin/run-queue"]