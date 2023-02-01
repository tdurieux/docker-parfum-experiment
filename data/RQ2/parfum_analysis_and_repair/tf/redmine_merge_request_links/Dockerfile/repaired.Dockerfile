ARG REDMINE_VERSION=3.4
FROM redmine:${REDMINE_VERSION}
ARG PATCH_VERSION=3.4

COPY patches/view_hook_issues_show_after_details_redmine_${PATCH_VERSION}.patch \
     /view_hook_issues_show_after_details.patch

RUN git apply /view_hook_issues_show_after_details.patch

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    && bundle install --with test && rm -rf /var/lib/apt/lists/*;