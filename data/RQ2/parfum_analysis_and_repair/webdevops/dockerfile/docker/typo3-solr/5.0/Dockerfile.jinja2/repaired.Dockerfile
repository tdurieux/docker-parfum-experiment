{{ baselayout.dockerStage() }}

{{ docker.from(user="guywithnose", image="solr", tag="4.10.4") }}

{{ docker.version() }}

{{ environment.general() }}

{{ typo3Solr.guywithnose(release="1.3.0") }}