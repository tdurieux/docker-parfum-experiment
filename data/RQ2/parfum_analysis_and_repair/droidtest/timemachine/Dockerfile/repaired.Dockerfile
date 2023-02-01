FROM caixb1234567890/ubuntu18.04_android_25:latest

WORKDIR workspace/TimeMachine/fuzzingandroid

RUN avdmanager create avd -n avd0 -k "system-images;android-25;google_apis;x86" -d pixel_2_xl -c 1000M -f && \
    apt-get update && apt-get install --no-install-recommends -y expect && pip install --no-cache-dir enum uiautomator && rm -rf /var/lib/apt/lists/*;