################################################################################
## This Dockerfile builds a Ruby application for the Google App Engine
## Flexible Environment. It may be modified and used as an App Engine "custom
## runtime", or even ported to a different Docker-based hosting environment.
##
## Generated at: <%= timestamp %>
## From configuration: <%= app_yaml_path %>
## Project: <%= project_id_for_display %>
## Service: <%= service_name %>
################################################################################


################################################################################
## 1. Augmented base image
## From a specific snapshot of the Ruby base image, installs the application's
## desired version of Ruby and any needed Ubuntu packages. Any software needed
## by both the application's build scripts and the final application runtime
## should be installed here.

FROM <%= base_image %> AS augmented-base

## If your application needs to install additional Ubuntu packages, do so here.
<% if install_packages.empty? %>
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update -y \
#     && apt-get install -y -q package-name another-package-name \
#     && apt-get clean \
#     && rm -f /var/lib/apt/lists/*_*
<% else %>
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y -q <%= install_packages.join(' ') %> \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*
<% end %>

## Specify the version of Ruby to use here. This setting is required.
## If you have a `.ruby-version` file in your application directory and/or a
## Ruby version specification in your Gemfile, they must match this value.
ARG ruby_version="<%= ruby_version %>"

## Commonly installed gems (e.g. bundler) are available from this image.
COPY --from=<%= build_tools_image %> /opt/gems/ /opt/gems/

<% if prebuilt_ruby_image %>
## Install Ruby <%= ruby_version %> from a prebuilt image. If a prebuilt image
## is not available, use the alternate installation method commented below.
COPY --from=<%= prebuilt_ruby_image %> \
     /opt/rbenv/versions/${ruby_version} \
     /opt/rbenv/versions/${ruby_version}
RUN rbenv global ${ruby_version} \
    && rbenv rehash \
    && (gem install /opt/gems/bundler-<%= @bundler1_version %>.gem ; \
        gem install /opt/gems/bundler-<%= @bundler2_version %>.gem ; \
        rbenv rehash)
## Alternate installation for Ruby versions that have no prebuilt image.
# RUN if [ ! -x ${RBENV_ROOT}/versions/${ruby_version}/bin/ruby ]; \
#     then \
#       cd ${RBENV_ROOT}/plugins/ruby-build \
#         && git pull \
#         && rbenv install -s ${ruby_version} \
#         && rbenv global ${ruby_version} \
#         && rbenv rehash \
#         && (gem install /opt/gems/bundler-<%= @bundler1_version %>.gem ; \
#             gem install /opt/gems/bundler-<%= @bundler2_version %>.gem ; \
#             rbenv rehash); \
#     fi
<% else %>
## Install Ruby <%= ruby_version %> by building from source using rbenv and
## ruby-build. If a prebuilt image is available, the alternate installation
## method commented below will probably be significantly faster.
RUN if [ ! -x ${RBENV_ROOT}/versions/${ruby_version}/bin/ruby ]; \
    then \
      cd ${RBENV_ROOT}/plugins/ruby-build \
        && git pull \
        && rbenv install -s ${ruby_version} \
        && rbenv global ${ruby_version} \
        && rbenv rehash \
        && (gem install /opt/gems/bundler-<%= @bundler1_version %>.gem ; \
            gem install /opt/gems/bundler-<%= @bundler2_version %>.gem ; \
            rbenv rehash); \
    fi
## Alternate installation for Ruby versions that have a prebuilt image.
# COPY --from=PATH-TO-PREBUILT-IMAGE \
#      /opt/rbenv/versions/${ruby_version} \
#      /opt/rbenv/versions/${ruby_version}
# RUN rbenv global ${ruby_version} \
#     && rbenv rehash \
#     && (gem install /opt/gems/bundler-<%= @bundler1_version %>.gem ; \
#         gem install /opt/gems/bundler-<%= @bundler2_version %>.gem ; \
#         rbenv rehash)
<% end %>

## Feel free to install any other software needed by both the build process
## (stage 2 below) and the final application runtime.

## Set environment variables requested in the app engine configuration.
<% if env_variables.empty? %>
# ENV NAME="value"
<% else %>
ENV <%= render_env env_variables %>
<% end %>


################################################################################
## 2. Application build
## From the augmented base image, installs any provided bundle, and runs any
## requested build jobs, such as preparation of JavaScript and CSS assets.
## This stage should prepare the /app directory exactly the way needed to run
## the final application.

FROM augmented-base AS app-build

## Obtain common build tools, including yarn, gcloud, cloud_sql_proxy,
## and the access_cloud_sql script, from this image.
COPY --from=<%= build_tools_image %> /opt/ /opt/

## Ensure the above tools are in the PATH
ENV PATH /opt/bin:/opt/google-cloud-sdk/bin:/opt/yarn/bin:${PATH}

## For compatibility with earlier versions of the builder.
## You can delete this if your custom build steps don't depend on older paths
## that include /build_tools.
RUN ln -s /opt /build_tools \
    && ln -s /opt/bin/cloud_sql_proxy /opt/cloud_sql_proxy \
    && ln -s /opt/bin/access_cloud_sql /opt/access_cloud_sql

## Set gcloud project here if your build scripts need to use gcloud.
<% if project_id %>
RUN gcloud config set project <%= project_id %>
<% else %>
# RUN gcloud config set project <%= project_id_for_example %>
<% end %>

## Copy the application files.
COPY . /app/

## If your build scripts need access to your application's CloudSQL instances,
## list them here, comma-delimited. This environment variable tells the
## "access_cloud_sql" script which databases to connect to.
## Also, make sure the /cloudsql directory is created because the CloudSQL
## Proxy will open sockets in that directory.
<% if cloud_sql_instances.empty? %>
# ARG BUILD_CLOUDSQL_INSTANCES="<%= project_id_for_example %>:db-region:db-name"
# RUN mkdir /cloudsql
<% else %>
ARG BUILD_CLOUDSQL_INSTANCES="<%= cloud_sql_instances.join(',') %>"
RUN mkdir /cloudsql
<% end %>

## If your build scripts need credentials for access to cloud resources, you
## may provide an appropriate JSON credentials file and set the
## GOOGLE_APPLICATION_CREDENTIALS path accordingly:
# COPY my-build-credentials.json /build_tools/credentials.json
# ENV GOOGLE_APPLICATION_CREDENTIALS=/build_tools/credentials.json

## If the application uses bundler, install the bundle here.
<% if has_gemfile %>
RUN bundle install --deployment --without="development test" && rbenv rehash
<% else %>
# RUN bundle install --deployment --without="development test" && rbenv rehash
<% end %>

## Run application build scripts here.
## Scripts that require access to the application CloudSQL instances should
## run access_cloud_sql first to start the cloud_sql_proxy. e.g.
##   RUN access_cloud_sql && bundle exec rake my_task
## Otherwise, simply run each build script in order in a separate RUN command.
<% if build_scripts.empty? %>
<% if cloud_sql_instances.empty? %>
# RUN bundle exec rake assets:precompile
<% else %>
# RUN access_cloud_sql && bundle exec rake assets:precompile
<% end %>
<% else %>
<% build_scripts.each do |script| %>
RUN <%= script %>
<% end %>
<% end %>


################################################################################
## 3. Application image
## From the augmented base image, installs the application directory built in
## stage 2 above, and sets the entrypoint. This is the final image that is
## executed by Google App Engine.

FROM augmented-base

## Copy built application from build stage
COPY --from=app-build /app/ /app/

## Command to start application.