# workspace development helpers
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    byobu \
    emacs \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;
