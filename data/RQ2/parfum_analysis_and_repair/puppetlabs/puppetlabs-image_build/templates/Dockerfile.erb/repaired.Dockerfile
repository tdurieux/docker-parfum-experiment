<% if from %>FROM <%= from %><% end %>
<% if maintainer %>MAINTAINER <%= maintainer %><% end %>

<% if image_user && !image_user.empty? %>USER root<% end %>

<% if environment %>ENV <% environment.each do |name, value| %><%= name.upcase %>="<%= value %>" <% end %><% end %>

<% if rocker %>MOUNT /opt/puppetlabs /etc/puppetlabs /root/.gem<% end %>

<% if labels && !labels.empty? %>LABEL <%= labels.map { |g| g.split('=') }.map { |k,v| "#{k}=\"#{v}\"" }.join(' ') %><% end %>

<% if apt_proxy %>ARG APT_PROXY<% end %>

<% unless skip_puppet_install %>
<% if os %>
<% if os == 'ubuntu' or os == 'debian' %>
RUN <% if apt_proxy %>echo "Acquire::HTTP::Proxy \"$APT_PROXY\";" >> /etc/apt/apt.conf.d/01proxy && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && <% end %>apt-get update && \
    apt-get install --no-install-recommends -y lsb-release wget ca-certificates && \
    wget <%= package_address %> && \
    dpkg -i <%= package_name %> && \
    rm <%= package_name %> && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent="$PUPPET_AGENT_VERSION"-1"$CODENAME" && \
    apt-get remove --purge -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    mkdir -p /etc/puppetlabs/facter/facts.d/ && \
    rm -rf /var/lib/apt/lists/* <% if apt_proxy %>&& rm -f /etc/apt/apt.conf.d/01proxy<% end %>
<% elsif os == 'centos' %>
RUN rpm -Uvh <%= package_address %> && \
    yum upgrade -y && \
    yum update -y && \
    yum install -y puppet-agent-"$PUPPET_AGENT_VERSION" && \
    mkdir -p /etc/puppetlabs/facter/facts.d/ && \
    yum clean all
<% elsif os == 'alpine' %>
RUN apk add --update \
      ca-certificates \
      pciutils \
      ruby \
      ruby-irb \
      ruby-rdoc \
      && \
    echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && \
    apk add --update shadow && \
    rm -rf /var/cache/apk/* && \
    gem install puppet:"$PUPPET_VERSION" facter:"$FACTER_VERSION" && \
    <%= puppet_path %> module install puppetlabs-apk

# Workaround for https://tickets.puppetlabs.com/browse/FACT-1351
RUN rm /usr/lib/ruby/gems/2.3.0/gems/facter-"$FACTER_VERSION"/lib/facter/blockdevices.rb
<% end %>
<% end %>
<% end %>

<% if use_factfile %>
    COPY <%= factfile %> /etc/puppetlabs/facter/facts.d/custom_facts.txt
<% end %>

<% if use_puppetfile && !master %>
<% if os == 'ubuntu' or os == 'debian' %>
RUN <% if apt_proxy %>echo "Acquire::HTTP::Proxy \"$APT_PROXY\";" >> /etc/apt/apt.conf.d/01proxy && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && <% end %>apt-get update && \
    apt-get install --no-install-recommends -y git-core && \
    <%= gem_path %> install r10k:"$R10K_VERSION" --no-ri --no-rdoc && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* <% if apt_proxy %>&& rm -f /etc/apt/apt.conf.d/01proxy<% end %>
<% elsif os == 'centos' %>
RUN yum update -y && \
    yum install -y git && \
    <%= gem_path %> install r10k:"$R10K_VERSION" --no-ri --no-rdoc && \
    yum clean all && rm -rf /var/cache/yum
<% elsif os == 'alpine' %>
RUN apk add --update git && \
    <%= gem_path %> install r10k:"$R10K_VERSION" --no-ri --no-rdoc && \
    rm -rf /var/cache/apk/*
<% end %>
<% if r10k_yaml %>
COPY r10k.yaml /r10k.yaml
<% end %>
COPY <%= puppetfile %> /Puppetfile
RUN <%= r10k_path %> puppetfile install --moduledir /etc/puppetlabs/code/modules
<% end %>

<% if module_path && !master %>
COPY <%= module_path %> /etc/puppetlabs/code/modules/
<% end %>

<% if manifest && !master %>
COPY <%= File.dirname(manifest) %> /<%= File.dirname(manifest) %>
<% end %>

<% if use_hiera && !master %>
COPY <%= hiera_config %> /hiera.yaml
COPY <%= hiera_data %> /hieradata
<% end %>

<% if autosign_token %>ARG AUTOSIGN_TOKEN<% end %>

<% if os %>
  <% if master %>
    <% if os == 'ubuntu' or os == 'debian' %>
RUN <% if apt_proxy %>echo "Acquire::HTTP::Proxy \"$APT_PROXY\";" >> /etc/apt/apt.conf.d/01proxy && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && <% end %>apt-get update && \
<% if autosign_token %>printf 'custom_attributes:\n    challengePassword: "%s"\n' $AUTOSIGN_TOKEN >> /etc/puppetlabs/puppet/csr_attributes.yaml && <% end %><% if master_is_ip %>echo <%= master_host %> puppet >> /etc/hosts && <% end %>FACTER_hostname=<%= hostname %>.<%= DateTime.now.rfc3339.gsub(/[^0-9a-z]/i, '') %>.dockerbuilder <%= puppet_path %> agent --server <% if master_is_ip %>puppet<% else %><%= master_host %><% end %><% if master_port %> --masterport <%= master_port %><% end %> --verbose <% if puppet_debug %>--debug <% end %>--onetime --no-daemonize <% if show_diff %>--show_diff <% end %>--summarize<% if autosign_token %> && rm /etc/puppetlabs/puppet/csr_attributes.yaml<% end %> && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* <% if apt_proxy %>&& rm -f /etc/apt/apt.conf.d/01proxy<% end %>
    <% elsif os == 'centos' %>
RUN yum update -y && \
    <% if autosign_token %>printf 'custom_attributes:\n    challengePassword: "%s"\n' $AUTOSIGN_TOKEN >> /etc/puppetlabs/puppet/csr_attributes.yaml && <% end %><% if master_is_ip %>echo <%= master_host %> puppet >> /etc/hosts && <% end %>FACTER_hostname=<%= hostname %>.<%= DateTime.now.rfc3339.gsub(/[^0-9a-z]/i, '') %>.dockerbuilder <%= puppet_path %> agent --server <% if master_is_ip %>puppet<% else %><%= master_host %><% end %><% if master_port %> --masterport <%= master_port %><% end %> --verbose <% if puppet_debug %>--debug <% end %>--onetime --no-daemonize <% if show_diff %>--show_diff <% end %>--summarize<% if autosign_token %> && rm /etc/puppetlabs/puppet/csr_attributes.yaml<% end %> && \
    yum clean all
    <% elsif os == 'alpine' %>
RUN apk update && \
    <% if autosign_token %>printf 'custom_attributes:\n    challengePassword: "%s"\n' $AUTOSIGN_TOKEN >> /etc/puppetlabs/puppet/csr_attributes.yaml && <% end %><% if master_is_ip %>echo <%= master_host %> puppet >> /etc/hosts && <% end %>FACTER_hostname=<%= hostname %>.<%= DateTime.now.rfc3339.gsub(/[^0-9a-z]/i, '') %>.dockerbuilder <%= puppet_path %> agent --server <% if master_is_ip %>puppet<% else %><%= master_host %><% end %><% if master_port %> --masterport <%= master_port %><% end %> --verbose <% if puppet_debug %>--debug <% end %>--onetime --no-daemonize <% if show_diff %>--show_diff <% end %>--summarize<% if autosign_token %> && rm /etc/puppetlabs/puppet/csr_attributes.yaml<% end %> && \
    rm -rf /var/cache/apk/*
    <% end %>
  <% else %>
    <% if os == 'ubuntu' or os == 'debian' %>
RUN <% if apt_proxy %>echo "Acquire::HTTP::Proxy \"$APT_PROXY\";" >> /etc/apt/apt.conf.d/01proxy && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && <% end %>apt-get update && \
    FACTER_hostname=<%= hostname %> <%= puppet_path %> apply <%= manifest %> --detailed-exitcodes --verbose <% if puppet_debug %>--debug <% end %><% if show_diff %>--show_diff <% end %>--summarize <% if use_hiera %>--hiera_config=/hiera.yaml<% end %> --app_management ; \
    rc=$?; if [ $rc -ne 0 ] && [ $rc -ne 2 ]; then exit 1; fi && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* <% if apt_proxy %>&& rm -f /etc/apt/apt.conf.d/01proxy<% end %>
    <% elsif os == 'centos' %>
RUN yum update -y && \
    FACTER_hostname=<%= hostname %> <%= puppet_path %> apply <%= manifest %> --verbose <% if puppet_debug %>--debug <% end %><% if show_diff %>--show_diff <% end %>--summarize <% if use_hiera %>--hiera_config=/hiera.yaml<% end %> --app_management && \
    yum clean all
    <% elsif os == 'alpine' %>
RUN apk update && \
    FACTER_hostname=<%= hostname %> <%= puppet_path %> apply <%= manifest %> --verbose <% if puppet_debug %>--debug <% end %><% if show_diff %>--show_diff <% end %>--summarize <% if use_hiera %>--hiera_config=/hiera.yaml<% end %> --app_management && \
    rm -rf /var/cache/apk/*
    <% end %>
  <% end %>
<% end %>

<% if inventory %>
LABEL com.puppet.inventory="/inventory.json"
RUN <%= puppet_path %> module install puppetlabs-inventory && \
    <%= puppet_path %> inventory all > /inventory.json
<% end %>

<% if expose && !expose.empty? %>EXPOSE <%= expose.join(' ') %><% end %>
<% if volume && !volume.empty? %>VOLUME <%= volume.join(' ') %><% end %>

<% if entrypoint && !entrypoint.empty? %>ENTRYPOINT <%= entrypoint.to_s %><% end %>
<% if cmd && !cmd.empty? %>CMD <%= cmd.to_s %><% end %>

<% if image_user && !image_user.empty? %>USER <%= image_user.to_s %><% end %>

<% if rocker %>TAG <%= image_name %><% end %>
