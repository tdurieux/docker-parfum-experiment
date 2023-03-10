%YAML 1.2
--- |
  # Copyright 2021 The gRPC Authors
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  #
  #     http://www.apache.org/licenses/LICENSE-2.0
  #
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.

  FROM debian:stretch

  <%include file="../apt_get_basic.include"/>
  <%include file="../run_tests_python_deps.include"/>
  <%include file="../cmake.include"/>
  <%include file="../run_tests_addons.include"/>

  # Java required by Android SDK
  RUN apt-get update && apt-get -y --no-install-recommends install openjdk-8-jdk && apt-get clean && rm -rf /var/lib/apt/lists/*;

  # Install Android SDK
  ENV ANDROID_SDK_VERSION 4333796
  RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk && \
      wget -q https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_VERSION.zip && \
      unzip -q sdk-tools-linux-$ANDROID_SDK_VERSION.zip && \
      rm sdk-tools-linux-$ANDROID_SDK_VERSION.zip
  ENV ANDROID_SDK_PATH /opt/android-sdk

  # Install Android NDK and cmake using sdkmanager
  RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg
  RUN yes | $ANDROID_SDK_PATH/tools/bin/sdkmanager --licenses  # accept all licenses
  RUN $ANDROID_SDK_PATH/tools/bin/sdkmanager ndk-bundle 'cmake;3.6.4111459'
  ENV ANDROID_NDK_PATH $ANDROID_SDK_PATH/ndk-bundle
  ENV ANDROID_SDK_CMAKE $ANDROID_SDK_PATH/cmake/3.6.4111459/bin/cmake

  # Define the default command.
  CMD ["bash"]

