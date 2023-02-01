FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends less -y && rm -rf /var/lib/apt/lists/*;
ARG habitus_host
ARG habitus_port
ARG habitus_password
ARG habitus_user
RUN echo http://$habitus_host:$habitus_port/v1/secrets/env/my_env_secret
RUN echo $habitus_user:$habitus_password
RUN curl -f -s -u $habitus_user:$habitus_password https://$habitus_host:$habitus_port/v1/secrets/env/my_env_secret