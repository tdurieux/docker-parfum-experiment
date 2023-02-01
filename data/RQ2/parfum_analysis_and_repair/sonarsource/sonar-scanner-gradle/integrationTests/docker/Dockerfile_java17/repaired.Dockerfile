FROM us.gcr.io/sonarqube-team/base:j17-latest

USER root

RUN apt-get update && apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;

ENV SDK_TOOLS=commandlinetools-linux-8092744_latest.zip

#Installing android sdk
RUN echo "Installing android-sdk" \
  && mkdir --parent /opt/android-sdk-linux/{add-ons,platforms,platform-tools,temp} \
  && cd /opt/android-sdk-linux \
  && curl -f --remote-name https://dl.google.com/android/repository/$SDK_TOOLS \
  && unzip $SDK_TOOLS \
  && rm $SDK_TOOLS

ENV ANDROID_HOME=/opt/android-sdk-linux  PATH=$PATH:/opt/android-sdk-linux/cmdline-tools/bin

RUN yes |sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "extras;android;m2repository" \
  && yes |sdkmanager --sdk_root=$ANDROID_HOME --licenses

RUN chmod -R 755 $ANDROID_HOME \
  && chown -R sonarsource: $ANDROID_HOME

# Back to the user of the base image
USER sonarsource
