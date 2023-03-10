################################################################################
## This Dockerfile builds an Elixir application for the Google App Engine
## Flexible Environment. It is meant for an application that uses Distillery
## releases for deployment.
## This Dockerfile may be modified and used as an App Engine "custom runtime",
## or even ported to a different Docker-based hosting environment such as
## Kubernetes.
##
## Generated at: <%= @timestamp %>
## From configuration: <%= @app_yaml_path %>
## Project: <%= @project_id_for_display %>
## Service: <%= @service_name %>
################################################################################


################################################################################
## 1. Release build
## From the builder image, installs any dependencies, builds the application
## release, and runs any additional requested build jobs such as
## preparation of JavaScript and CSS assets. This stage should prepare a
## release in the /opt/release directory.

FROM <%= @builder_image %> AS app-build

## If your build requires additional apt packages, install them here.
<%= if @builder_packages == "" do %>
# RUN apt-get update -y \
#     && apt-get install -y -q package-name another-package-name \
#     && apt-get clean \
#     && rm -f /var/lib/apt/lists/*_*
<% else %>
RUN apt-get update -y \
    && apt-get install -y -q <%= @builder_packages %> \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*
<% end %>

## Specify the versions of Erlang/OTP and Elixir.
## If you want to change which versions to use, you may do so, but make sure:
## 1. You make the corresponding change to the versions copied to the runtime
##    image at the bottom of this Dockerfile.
## 2. You update your .tool-versions file if you have one.
## For more information on the asdf tool that is used to manage Erlang and
## Elixir installation, see https://github.com/asdf-vm/asdf
ARG erlang_version="<%= @erlang_version %>"
ARG elixir_version="<%= @elixir_version %>"

<%= if @prebuilt_erlang_image do %>
## Install Erlang <%= @erlang_version %> from a prebuilt image.
## If a prebuilt image is not available, use the alternate installation method
## commented below.
COPY --from=<%= @prebuilt_erlang_image %> \
     /opt/asdf/installs/erlang/${erlang_version} \
     /opt/asdf/installs/erlang/${erlang_version}
RUN asdf reshim erlang ${erlang_version} \
    && asdf global erlang ${erlang_version}
## Alternate installation for Erlang versions that have no prebuilt image.
# RUN asdf plugin-update erlang \
#     && asdf install erlang ${erlang_version} \
#     && asdf global erlang ${erlang_version}
<% else %>
## Install Erlang <%= @erlang_version %> by building from source using asdf.
## If a prebuilt image is available, the alternate installation method
## commented below will probably be significantly faster.
RUN asdf plugin-update erlang \
    && asdf install erlang ${erlang_version} \
    && asdf global erlang ${erlang_version}
## Alternate installation for Erlang versions that have a prebuilt image.
# COPY --from=<%= @prebuilt_erlang_image %> \
#      /opt/asdf/installs/erlang/${erlang_version} \
#      /opt/asdf/installs/erlang/${erlang_version}
# RUN asdf reshim erlang ${erlang_version} \
#     && asdf global erlang ${erlang_version}
<% end %>

## Install Elixir <%= @elixir_version %> using asdf.
RUN asdf plugin-update elixir \
    && asdf install elixir ${elixir_version} \
    && asdf global elixir ${elixir_version} \
    && mix local.hex --force \
    && mix local.rebar --force

## Set gcloud project here if your build scripts need to use gcloud.
<%= if @project_id do %>
RUN gcloud config set project <%= @project_id %>
<% else %>
# RUN gcloud config set project <%= @project_id_for_example %>
<% end %>

## If your build scripts need any environment variables, set them here.
## Generally, these will come from the application's app engine configuration.
<%= if @env_variables == "" do %>
# ENV NAME="value"
<% else %>
ENV <%= @env_variables %>
<% end %>

## If your build scripts need access to your application's CloudSQL instances,
## list them here, comma-delimited. This environment variable tells the
## "access_cloud_sql" script which databases to connect to.
<%= if @cloud_sql_instances == "" do %>
# ENV BUILD_CLOUDSQL_INSTANCES="<%= @project_id_for_example %>:db-region:db-name"
<% else %>
ENV BUILD_CLOUDSQL_INSTANCES="<%= @cloud_sql_instances %>"
<% end %>

## Copy the application files.
COPY . /app/

## If your build scripts need credentials for access to cloud resources, you
## may provide an appropriate JSON credentials file and set the
## GOOGLE_APPLICATION_CREDENTIALS path accordingly. This is not necessary if
## you provide the cloudbuild service account with the needed privileges.
# COPY my-build-credentials.json /app/build-credentials.json
# ENV GOOGLE_APPLICATION_CREDENTIALS=/app/build-credentials.json

## Install dependencies and compile the application.
RUN mix do deps.get, deps.compile, compile

## Run application build scripts here.
## Scripts that require access to the application CloudSQL instances should
## run access_cloud_sql first to start the CloudSQL Proxy. e.g.
##   RUN access_cloud_sql && mix my_task
## Otherwise, simply run each build script in order in a separate RUN command.
<%= if @build_scripts != "" do %>
<%= @build_scripts %>
<% end %>

## Create the release.
RUN <%= @release_command %>


################################################################################
## 2. Application runtime image
## From the OS base image, installs the release built above, and sets the
## entrypoint. This is the final image executed by Google App Engine.

FROM <%= @os_image %>

## If your application needs additional apt packages at runtime, install
## them here.
<%= if @runtime_packages == "" do %>
# RUN apt-get update -y \
#     && apt-get install -y -q package-name another-package-name \
#     && apt-get clean \
#     && rm -f /var/lib/apt/lists/*_*
<% else %>
RUN apt-get update -y \
    && apt-get install -y -q <%= @runtime_packages %> \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*
<% end %>

## Copy built release from build stage into /app
COPY --from=app-build /app/_build/<%= @mix_env %>/rel/<%= @release_app %> /app/

## Command to start the release.