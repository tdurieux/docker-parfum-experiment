{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("solr", "6.3.0") }}

{{ docker.version() }}

{{ environment.general() }}

{{ typo3Solr.official('7.0.0') }}