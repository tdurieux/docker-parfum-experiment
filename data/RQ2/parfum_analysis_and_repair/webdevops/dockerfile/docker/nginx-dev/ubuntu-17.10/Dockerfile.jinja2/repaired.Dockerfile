{{ docker.from("nginx", "ubuntu-17.10") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

{{ docker.expose('80 443') }}