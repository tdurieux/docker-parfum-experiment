FROM runmymind/docker-android-sdk
RUN apt-get update && apt-get install --no-install-recommends -y git rubygems && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

ADD . bugsnag-android-gradle-plugin
RUN cd bugsnag-android-gradle-plugin && ./gradlew clean build install -PVERSION_NAME=9000.0.0-test
RUN cd bugsnag-android-gradle-plugin/dexguard-test-project && bundle install
ADD dexguard-test-project/DexGuard-8.1.15/dexguard-license.txt /root/dexguard-license.txt
