FROM ubuntu:18.04

ARG irods_pkg_dir
ARG server_py=${server_python_version}
ENV SERVER_PY "${server_py}"

RUN apt update
RUN apt install --no-install-recommends -y wget sudo lsb-release apt-transport-https gnupg2 postgresql-client python3 && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | sudo apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list
RUN apt update

SHELL [ "/bin/bash","-c" ]

COPY ICAT.sql /tmp
COPY pgpass root/.pgpass
RUN chmod 600 root/.pgpass

RUN apt install --no-install-recommends -y rsyslog gawk && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
ADD build_deps_list wait_on_condition send_oneshot install_python_rule_engine setup_python_rule_engine /tmp/

# At Runtime: 1. Install apt dependencies for the iRODS package files given.
#             2. Install the package files.
#             3. Wait on database container.
#             4. Configure iRODS provider and make sure it is running.
#             5. Open a server port, informing the client to start tests now that iRODS is up.
#             6. Configure shared folder for tests that need to register data objects.
#                (We opt out if /irods_shared does not exist, ie is omitted in the docker-compose.yml).
#             7. Wait forever.

CMD apt install -y $(/tmp/build_deps_list /irods_packages/irods*{serv,dev,icommand,runtime,database-*postgres}*.deb) && \
    dpkg -i /irods_packages/irods*{serv,dev,icommand,runtime,database-*postgres}*.deb && \
    /tmp/wait_on_condition -i 5 -n 12 "psql -h icat -U postgres -c '\\l' >/dev/null" && \
    psql -h icat -U postgres -f /tmp/ICAT.sql && \
    sed 's/localhost/icat/' < /var/lib/irods/packaging/localhost_setup_postgres.input \
        | python${SERVER_PY} /var/lib/irods/scripts/setup_irods.py && \
    { [ "${PYTHON_RULE_ENGINE_INSTALLED}" = '' ] || { /tmp/install_python_rule_engine "$PYTHON_RULE_ENGINE_INSTALLED" /irods_packages \
                                                     && /tmp/setup_python_rule_engine; } } && \
    { pgrep -u irods irodsServer >/dev/null || su irods -c '~/irodsctl start'; \
      env PORT=8888 /tmp/send_oneshot "iRODS is running..." & } && \
    { [ ! -d /irods_shared ] || { mkdir -p /irods_shared/reg_resc && mkdir -p /irods_shared/tmp && \
                                  chown -R irods.irods /irods_shared && chmod g+ws /irods_shared/tmp && \
                                  chmod 777 /irods_shared/reg_resc ; } } && \
    echo $'*********\n' $'*********\n' $'*********\n' $'*********\n' $'*********\n' IRODS IS UP  && \
    tail -f /dev/null
