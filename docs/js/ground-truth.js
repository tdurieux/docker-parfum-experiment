angular
  .module("dinghy-website", [])
  .directive("keypressEvents", [
    "$document",
    "$rootScope",
    function ($document, $rootScope) {
      return {
        restrict: "A",
        link: function () {
          $document.bind("keydown", function (e) {
            $rootScope.$broadcast("keypress", e);
            $rootScope.$broadcast("keypress:" + e.which, e);
            $rootScope.$broadcast("keypress:" + e.key, e);
          });
        },
      };
    },
  ])
  .filter("percentage", [
    "$filter",
    function ($filter) {
      return function (input, decimals) {
        return $filter("number")(input * 100, decimals) + "%";
      };
    },
  ])
  .filter("length", function () {
    return function (input) {
      if (!input) {
        return 0;
      }
      return Object.keys(input).length;
    };
  })
  .filter("filterObj", function () {
    return function (input, search) {
      if (!input) return input;
      if (!search) return input;
      var result = {};
      angular.forEach(input, function (value, key) {
        if (search(value)) {
          result[key] = value;
        }
      });
      return result;
    };
  })
  .controller("mainController", function ($scope, $rootScope, $sce, $http) {
    $scope.samples = [];
    $scope.smells = [];
    $scope.newGroudTruth = {};
    function init() {
      monacoEditor.getModel().onDidChangeContent(() => {
        const code = monacoEditor.getValue();
      });

      monacoEditor.onDidChangeCursorPosition((e) => {
        if (!e.position) return;
        $scope.$evalAsync(() => {
          $scope.cursorPosition = monacoEditor.getSelection();
        });
      });
    }
    $scope.next = function (index) {
      if (index === undefined)
        index = $scope.filteredSamples.indexOf($scope.selectedSample);
      if (index + 1 < $scope.filteredSamples.length) {
        $scope.loadSample($scope.filteredSamples[index + 1]);
      }
    };
    $scope.previsous = function () {
      const index = $scope.filteredSamples.indexOf($scope.selectedSample);
      if (index - 1 >= 0) {
        $scope.loadSample($scope.filteredSamples[index - 1]);
      }
    };
    $rootScope.$on("keypress", function (event, e) {
      if (e.key === "ArrowDown") {
        $scope.next();
      } else if (e.key === "ArrowUp") {
        $scope.previsous();
      } else if (e.key === "s") {
        const index = $scope.filteredSamples.indexOf($scope.selectedSample);
        $scope.saveGroundTruth(() => {
          $scope.next(index);
        });
      }
    });
    function getSmells() {
      $http.get("/api/smells").then((res) => {
        $scope.smells = res.data;
        $scope.newGroudTruth.smell = $scope.smells[0];
      });
    }
    function getSamples() {
      $http.get("/data/ground-truth/dockerfiles.json").then((res) => {
        $scope.samples = res.data.map((sample) => ({
          name: sample.replace(".Dockerfile", ""),
        }));
        $scope.loadSample($scope.samples[0]);
      });
    }
    function getBinnacleResults(sample) {
      $scope.binnacleResults = [];
      $http
        .get("/data/results/binnacle/" + sample.name + ".json")
        .then((res) => {
          $scope.$evalAsync(() => {
            $scope.binnacleResults = [];
            for (const smell in res.data.all_violations) {
              $scope.binnacleResults.push({
                rule: smell,
                count: res.data.all_violations[smell],
              });
            }
          });
        });
    }
    function getGroundTruth(sample) {
      $scope.parfumResults = [];
      $http
        .get("/data/ground-truth/smells/" + sample.name + ".json")
        .then((res) => {
          sample.groundtruth = res.data;
        });
    }
    function getParfumResults(sample) {
      $scope.parfumResults = [];
      $http.get("/data/results/parfum/" + sample.name + ".json").then((res) => {
        $scope.$evalAsync(() => {
          $scope.parfumResults = res.data;
        });
      });
    }

    $scope.highlightSmell = function (position) {
      const decorations = [];
      decorations.push({
        range: new monaco.Range(
          position.lineStart + 1,
          position.columnStart + 1,
          position.lineEnd + 1,
          position.columnEnd + 1
        ),
        options: { inlineClassName: "ast-highlight" },
      });
      const decorationIds = monacoEditor.deltaDecorations([], decorations);

      $scope.clearNodeType = () => {
        monacoEditor.removeDecorations(decorationIds);
      };
    };
    $scope.clearNodeType = function () {
      monacoEditor.deltaDecorations([], []);
    };
    $scope.loadSample = (sample) => {
      monacoEditor.getModel().setValue("");
      $http
        .get("/data/ground-truth/dockerfiles/" + sample.name + ".Dockerfile")
        .then((res) => {
          $scope.selectedSample = sample;
          getGroundTruth(sample);
          getParfumResults(sample);
          getBinnacleResults(sample);
          $scope.selectedSample.dockerfile = res.data;
          monacoEditor.getModel().setValue($scope.selectedSample.dockerfile);
        });
    };
    function smellName(name) {
      name = name.replace("rule", "");
      return name[0].toLowerCase() + name.slice(1);
    }
    $scope.inGroundTruthBinnacle = (smell) => {
      if (!smell) return false;
      const rule = smellName(smell.rule);
      if (
        !$scope.selectedSample.groundtruth ||
        !$scope.selectedSample.groundtruth[rule]
      )
        return false;
      return smell.count === $scope.selectedSample.groundtruth[rule].length;
    };
    $scope.inGroundTruth = (smell) => {
      if (!smell) return false;
      if (
        !$scope.selectedSample.groundtruth ||
        !$scope.selectedSample.groundtruth[smell.rule]
      )
        return false;
      for (
        let i = 0;
        i < $scope.selectedSample.groundtruth[smell.rule].length;
        i++
      ) {
        if (
          $scope.selectedSample.groundtruth[smell.rule][i].lineStart ===
            smell.position.lineStart &&
          $scope.selectedSample.groundtruth[smell.rule][i].columnStart ===
            smell.position.columnStart &&
          $scope.selectedSample.groundtruth[smell.rule][i].lineEnd ===
            smell.position.lineEnd &&
          $scope.selectedSample.groundtruth[smell.rule][i].columnEnd ===
            smell.position.columnEnd
        ) {
          return true;
        }
      }
      return false;
    };
    $scope.removeSmell = (rule, location) => {
      if (!$scope.selectedSample.groundtruth)
        $scope.selectedSample.groundtruth = {};
      for (let i = 0; i < $scope.selectedSample.groundtruth[rule].length; i++) {
        if (
          $scope.selectedSample.groundtruth[rule][i].lineStart ===
            location.lineStart &&
          $scope.selectedSample.groundtruth[rule][i].columnStart ===
            location.columnStart &&
          $scope.selectedSample.groundtruth[rule][i].lineEnd ===
            location.lineEnd &&
          $scope.selectedSample.groundtruth[rule][i].columnEnd ===
            location.columnEnd
        ) {
          $scope.selectedSample.groundtruth[rule].splice(i, 1);
          break;
        }
        // $scope.saveGroundTruth();
      }
    };
    $scope.saveGroundTruth = (callback) => {
      if (!$scope.selectedSample.groundtruth)
        $scope.selectedSample.groundtruth = {};
      $http
        .post(
          "/api/samples/" + $scope.selectedSample.name,
          $scope.selectedSample.groundtruth
        )
        .then((res) => {
          $scope.selectedSample.saved = true;
          if (callback) callback();
        });
    };
    $scope.addSmell = (smell) => {
      if (!smell) return;
      if ($scope.inGroundTruth(smell)) return;
      if (!$scope.selectedSample.groundtruth)
        $scope.selectedSample.groundtruth = {};
      if (!$scope.selectedSample.groundtruth[smell.rule]) {
        $scope.selectedSample.groundtruth[smell.rule] = [];
      }
      $scope.selectedSample.groundtruth[smell.rule].push(smell.position);
      $scope.selectedSample.saved = false;
      // $scope.saveGroundTruth();
    };
    $scope.addGroundTruth = () => {
      if (!$scope.selectedSample.groundtruth)
        $scope.selectedSample.groundtruth = {};
      if (!$scope.selectedSample.groundtruth[$scope.newGroudTruth.smell]) {
        $scope.selectedSample.groundtruth[$scope.newGroudTruth.smell] = [];
      }
      $scope.selectedSample.groundtruth[$scope.newGroudTruth.smell].push({
        lineStart: $scope.cursorPosition.startLineNumber - 1,
        lineEnd: $scope.cursorPosition.endLineNumber - 1,
        columnStart: $scope.cursorPosition.startColumn - 1,
        columnEnd: $scope.cursorPosition.endColumn - 1,
      });
      $scope.selectedSample.saved = false;
    };
    $scope.filters = {
      onlyUnannotated: false,
    };
    $scope.filterSample = (sample) => {
      if ($scope.filters.onlyUnannotated && sample.saved !== false) {
        return false;
      }
      return true;
    };
    const initInterval = setInterval(() => {
      if (window.monacoEditor !== undefined) {
        getSamples();
        clearInterval(initInterval);
        init();
      }
    }, 100);
    getSmells();
  });
