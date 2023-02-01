FROM cirrusci/flutter:stable

RUN sudo apt-get update -y

RUN sudo apt-get install -y --no-install-recommends gnupg && rm -rf /var/lib/apt/lists/*;

# Add repo for gcloud sdk and install it
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y google-cloud-sdk && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && rm -rf /var/lib/apt/lists/*;

RUN yes | sdkmanager \
    "platforms;android-29" \
    "build-tools;29.0.2" \
    "extras;google;m2repository" \
    "extras;android;m2repository"

RUN yes | sdkmanager \
    "platforms;android-28" \
    "build-tools;28.0.3" \
    "extras;google;m2repository" \
    "extras;android;m2repository"

RUN yes | sdkmanager --licenses
