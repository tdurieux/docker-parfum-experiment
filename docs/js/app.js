angular
  .module("jdbl-website", ["ngRoute", "anguFixedHeaderTable"])
  .config(function ($routeProvider) {
    $routeProvider.when("/:lib/:version/:project", {
      controller: "mainController",
    });
  })
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
  .controller(
    "mainController",
    function ($scope, $http, $routeParams, $location) {
      $scope.filters = {
        libDebloatTest: "all",
        libDebloat: "all",
        clientDebloatTest: "all",
        clientDebloat: "all",
        client: "pass",
      };
      if (localStorage.getItem("jdbl-dashboard.filters") != null) {
        $scope.filters = JSON.parse(
          localStorage.getItem("jdbl-dashboard.filters")
        );
      }

      // create the list of sushi rolls
      $scope.analysis = [];
      $scope.all_original_violations = {};
      $scope.all_repaired_violations = {};

      function getAnalysis() {
        $scope.libAnalysis = "";
        $scope.clientAnalysis = "";
        $http.get("data/analysis.json").then(function (response) {
          $scope.analysis = Object.values(response.data);
          for (const a of $scope.analysis) {
            for (const v of a.original_violations) {
              $scope.all_original_violations[v] = ($scope.all_original_violations[v] || 0) + 1; 
            }
            for (const v of a.repaired_violations) {
              $scope.all_repaired_violations[v] = ($scope.all_repaired_violations[v] || 0) + 1; 
            }
          }
          $scope.filters.original_violations = Object.keys($scope.all_original_violations)
          $scope.filters.repaired_violations = Object.keys($scope.all_repaired_violations)
          setTimeout(() => {
            $('.custom-select').selectpicker();
          }, 1000)
        });
      }
      getAnalysis();

      $scope.$watch(
        "filters",
        () => {
          localStorage.setItem(
            "jdbl-dashboard.filters",
            JSON.stringify($scope.filters)
          );
          console.log($scope.filters)
        },
        true
      );
      $scope.libFilter = function (lib) {
        const nbClient = Object.values(lib).filter($scope.versionFilter).length;
        return nbClient != 0;
      };
      $scope.anaFilter = function (ana) {
        
        if ($scope.filters.original_violations.length != Object.keys($scope.all_original_violations).length && !ana.original_violations.some((v) => $scope.filters.original_violations.includes(v))) {
          return false;
        }
        if ($scope.filters.repaired_violations.length != Object.keys($scope.all_repaired_violations).length && !ana.repaired_violations.some((v) => $scope.filters.repaired_violations.includes(v))) {
          return false;
        }
        return true
      }

      $scope.openAnalysis = function (analysis) {
        $scope.currentFile = analysis.file;
        $scope.current = analysis;
        $location.path(`/${$scope.currentFile}`);

        $scope.getPatch();
        $scope.getRepairedViolations();
        $scope.getViolations();
        $scope.getRepairedDocker();
      };

      $scope.analyze = function () {
        $http.post("api/analyze/" + $scope.currentFile).then(function (response) {
          $scope.getPatch();
          $scope.getRepairedViolations();
          $scope.getViolations();
          $scope.getRepairedDocker();
        });
      }

      $scope.getPatch = function () {
        $http.get("data/analysis/" + $scope.currentFile + "/repair.patch").then(
          function (response) {
            $scope.diff = response.data;
          },
          () => {
            $scope.diff = "";
          }
        );
      };

      $scope.getRepairedViolations = function () {
        $http.get("data/analysis/" + $scope.currentFile + "/repaired_violations.json").then(
          function (response) {
            $scope.repaired_violations = response.data;
          },
          () => {
            $scope.repaired_violations = [];
          }
        );
      };

      $scope.getViolations = function () {
        $http.get("data/analysis/" + $scope.currentFile + "/violations.json").then(
          function (response) {
            $scope.violations = response.data;
          },
          () => {
            $scope.violations = [];
          }
        );
      };

      $scope.getRepairedDocker = function () {
        $http.get("data/analysis/" + $scope.currentFile + "/repaired.Dockerfile").then(
          function (response) {
            $scope.repaired_dockerfile = response.data;
          },
          () => {
            $scope.repaired_dockerfile = "";
          }
        );
      };

      $scope.naturalCompare = function (a, b) {
        if (a.type === "number") {
          return a.value - b.value;
        }
        return naturalSort(a.value, b.value);
      };
    }
  );
