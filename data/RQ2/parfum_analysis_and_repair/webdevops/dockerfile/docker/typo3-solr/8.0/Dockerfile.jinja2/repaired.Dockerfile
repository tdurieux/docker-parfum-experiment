{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("solr", "6.6.2") }}

{{ docker.version() }}

{{ environment.general() }}

{{ typo3Solr.official('8.0.0') }}