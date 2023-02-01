FROM python:3.7-slim-stretch
#ARG USER
#ARG UID
# disable telemetry by default
ENV FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

RUN apt-get clean && apt-get update \
  && apt-get install --no-install-recommends -y ca-certificates curl apt-transport-https lsb-release gnupg libicu57 \
  && curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor \
    | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
  && AZ_REPO=$(lsb_release -cs) \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main"\
    | tee /etc/apt/sources.list.d/azure-cli.list \
  && echo "deb [arch=amd64] https://packages.microsoft.com/debian/9/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y azure-cli azure-functions-core-tools-3\
# Install NodeJS 10.x to test functions locally with func host
 && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install --no-install-recommends -y nodejs \
  && apt-get purge -y --auto-remove curl lsb-release gnupg && rm -rf /var/lib/apt/lists/*;

# https://github.com/moby/moby/issues/20295
# https://github.com/moby/moby/issues/20295
#ENV HOME=/home/${USER}
#RUN useradd --non-unique --uid ${UID} -m ${USER}\
#    && chown ${USER}:${USER} ${HOME}\
#    && chown ${USER}:${USER} /mnt
#WORKDIR ${HOME}
#USER ${USER}:${USER}

# Extension must be installed for a specific user, I guess.
# Installed with root does not work for user.
#RUN /usr/bin/az extension add --name application-insights

RUN apt-get -y --no-install-recommends install gosu && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /sebs/
COPY docker/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh

ENV SCRIPT_FILE=/mnt/function/package.sh
#ENV CMD='/usr/bin/ extension add --name application-insights'
ENTRYPOINT ["/sebs/entrypoint.sh"]
