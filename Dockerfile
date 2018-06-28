FROM openjdk:8

ARG ANDROID_COMPILE_SDK=27
ARG ANDROID_BUILD_TOOLS=27.0.3

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_COMPILE_SDK=${ANDROID_COMPILE_SDK}
ENV ANDROID_BUILD_TOOLS=${ANDROID_BUILD_TOOLS}

# Download Android SDK
RUN mkdir -p "$ANDROID_HOME" .android /root/.android

WORKDIR "$ANDROID_HOME"

RUN touch /root/.android/repositories.cfg
RUN curl -o sdk.zip $SDK_URL
RUN unzip sdk.zip && rm sdk.zip
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" "extras;google;m2repository" "extras;android;m2repository" "extras;google;google_play_services"
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager --licenses > android-licences.log

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install --yes nodejs gradle make

RUN mkdir /app

WORKDIR /app
