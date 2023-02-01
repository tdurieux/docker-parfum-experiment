FROM yukinying/chrome-headless-browser-selenium:latest

USER root
RUN apt-get update && apt-get install --no-install-recommends -y libxi6 libgconf-2-4 && rm -rf /var/lib/apt/lists/*;
USER headless
