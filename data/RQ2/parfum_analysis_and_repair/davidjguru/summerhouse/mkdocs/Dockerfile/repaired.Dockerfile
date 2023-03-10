FROM python:3.8 AS development

# Running pip for dependencies.
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir mkdocs
RUN pip install --no-cache-dir mkdocs-material
RUN pip install --no-cache-dir mkdocs-pdf-export-plugin
RUN pip install --no-cache-dir mkdocs-rtd-dropdown
RUN pip install --no-cache-dir mkdocs-git-revision-date-plugin
RUN pip install --no-cache-dir mkdocs-git-revision-date-localized-plugin

# Exposing port.
EXPOSE 8000
WORKDIR /home
COPY . .

# Entrypoint and commands.
ENTRYPOINT ["mkdocs"]
CMD ["build"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]