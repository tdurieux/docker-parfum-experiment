FROM marcskovmadsen/awesome-panel_base:latest

WORKDIR /app
ADD . ./

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
RUN pip uninstall -y awesome-panel-extensions && pip install --no-cache-dir awesome-panel-extensions -U

# Default port for Azure Web App for containers is 80
EXPOSE 80

# RUN invoke sphinx.copy-from-project-root
WORKDIR /app

ENTRYPOINT [ "panel", "serve", "awesome_panel/apps/*.py", "awesome_panel/apps/*.ipynb", "--glob", "--address", "0.0.0.0", "--port", "80", "--num-procs", "4", "--index", "home.py"]