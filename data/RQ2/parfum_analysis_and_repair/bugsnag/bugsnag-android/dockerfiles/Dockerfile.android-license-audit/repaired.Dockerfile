ARG BRANCH_NAME
FROM 855461928731.dkr.ecr.us-west-1.amazonaws.com/android:ci-${BRANCH_NAME} as android

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full npm && rm -rf /var/lib/apt/lists/*;
RUN gem install license_finder
