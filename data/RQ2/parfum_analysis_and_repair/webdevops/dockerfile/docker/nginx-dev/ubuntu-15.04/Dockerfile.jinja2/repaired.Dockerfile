{{ docker.from("nginx", "ubuntu-15.04") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

{{ docker.expose('80 443') }}