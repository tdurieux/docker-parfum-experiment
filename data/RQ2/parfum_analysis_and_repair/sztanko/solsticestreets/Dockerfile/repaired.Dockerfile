FROM sztanko/solsticestreets_base:latest

ADD .devcontainer /.devcontainer
RUN pip install --no-cache-dir -r /.devcontainer/requirements.dev.txt
RUN /.devcontainer/install.sh