FROM shellmanager/shellmanager

COPY . /src

ARG FORMAT
ARG SEED

# TODO: ease exfil of artifacts and config
RUN shell_manager install /src \
    && shell_manager deploy all -c -i ${SEED} -f ${FORMAT}

EXPOSE 5000
CMD ["xinetd", "-dontfork"]