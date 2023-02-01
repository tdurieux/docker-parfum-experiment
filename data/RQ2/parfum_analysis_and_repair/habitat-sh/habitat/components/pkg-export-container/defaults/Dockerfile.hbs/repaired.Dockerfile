FROM {{base_image}}
ENV PATH {{path}}

{{~ #if multi_layer }}
# TODO (CM): If package-per-layer becomes an issue, we could gain a
# bit of headspace by putting all the Supervisor-related packages and
# dependencies in one layer, and then add user packages in subsequent
# layers.
#
# Alternatively, we might take advantage of a Supervisor-only
# container as a base image:
# https://github.com/habitat-sh/habitat/issues/4977
{{~ #each packages as |pkg|}}
COPY {{../rootfs}}/hab/pkgs/{{pkg}} /hab/pkgs/{{pkg}}
{{ /each }}
{{~ else }}
ADD {{rootfs}}/hab /hab
{{~ /if }}

# Contains all our busybox userspace links, hab binary link, and any user
# package binary links
#
# TODO: The creation of this directory and the links therein could be
# executed directly in this Dockerfile, in a series of commands
# executed at the beginning of the following RUN directive. This could
# simplify Rust code, as well as save an additional layer.
COPY {{rootfs}}/bin /bin

RUN \
    # Remember, in order to be able to run a Supervisor as non-root,
    # we must at least have write access to the /hab directory. If you
    # further wish to run an *updating* Supervisor (or one that
    # updates its services), you will (generically) require write
    # access to everything under `/hab/pkgs` as well.
    #
    # (One final note: we run this `find` command *after* we set up /bin
    # to avoid having to call our busybox binary directly.)
    find /hab -type d -exec chmod g=u {} \; && \
    # Create the minimum amount of directories for things to work.
    #
    # /tmp is particularly required for the Supervisor / Launcher
    # communication pipe.
    mkdir /root && chmod 750 root && \
    mkdir /tmp && chmod 1777 /tmp && \
    mkdir -p /var/tmp && chmod 1777 /var/tmp && \

    # This is currently needed in order for non-root containers to
    # function... this ends up being their home directory, and we
    # expect to find key cache directory there right now.
    mkdir -p /.hab/cache/keys && chmod -R 770 /.hab

# Ensure our custom /etc content (notably `passwd` and `group` files,
# but also our linked cacerts in /etc/ssl) are present.
#
# TODO: The creation of everything in this directory could potentially
# be taken entirely out of Rust and implemented here in the Dockerfile.
COPY {{rootfs}}/etc /etc
COPY {{rootfs}}/init.sh /init.sh

EXPOSE 9631 {{exposes}}
RUN HAB_FEAT_OFFLINE_INSTALL=ON \
    {{~ #if environment}}
    {{~ #each environment}}
        {{@key}}={{{this}}} \
    {{~ /each}}
    {{~ /if}}
    {{hab_path}} pkg install {{installed_primary_svc_ident}}
ENTRYPOINT ["/init.sh"]
CMD ["run", "{{primary_svc_ident}}"]