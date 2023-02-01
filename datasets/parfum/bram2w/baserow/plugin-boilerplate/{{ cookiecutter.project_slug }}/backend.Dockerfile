FROM baserow/backend:1.10.2

USER root

COPY ./plugins/{{ cookiecutter.project_module }}/ $BASEROW_PLUGIN_DIR/{{ cookiecutter.project_module }}/
RUN /baserow/plugins/install_plugin.sh --folder $BASEROW_PLUGIN_DIR/{{ cookiecutter.project_module }}

USER $UID:$GID
