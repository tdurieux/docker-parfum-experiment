import express from "express";
import compression from "compression";
import bodyParser from "body-parser";
import { analyzeDockerfile } from "./script/2.RQ1/2.analyze_repair_new_dataset";
import { basename, join } from "path";
import { readFile, writeFile } from "fs/promises";
import * as dockerfile from "@tdurieux/dinghy";
import { BINNACLE_RULES, Matcher } from "@tdurieux/docker-parfum";
import { nodeType, File } from "@tdurieux/dinghy";
import { walkSync } from "./script/utils";
import config from "./config";
import { readFileSync } from "fs";

const app = express();
app.use(bodyParser.json());
app.use(compression());
app.use(express.static("docs"));

const PORT = process.env.PORT || 8881;
app.post("/api/parse", async (req, res) => {
  const dockerParser = new dockerfile.dockerfileParser.DockerParser(
    new File(undefined, req.body.data.dockerfile)
  );
  try {
    const ast = await dockerParser.parse();
    // if (dockerParser.errors.length > 0) {
    //   for (const error of dockerParser.errors) {
    //     console.log(error.message);
    //   }
    //   // console.log(fileContent);
    // }
    const matcher = new Matcher(ast);
    const violations = matcher.matchAll();

    const output: {
      queries: any;
      violations: any[];
    } = { queries: {}, violations: [] };
    output.queries.packages = ast
      .find(nodeType.Q("SC-APT-PACKAGE"))
      .map((n) => n.toString())
      .filter((v, i, a) => a.indexOf(v) === i);
    output.queries.urls = ast
      .find(nodeType.Q("ABS-PROBABLY-URL"))
      .map((n) => n.toString())
      .filter((v, i, a) => a.indexOf(v) === i);
    output.queries.paths = ast
      .find(nodeType.Q("ABS-MAYBE-PATH"))
      .map((n) => n.toString())
      .concat(ast.find(nodeType.Q("BASH-PATH")).map((n) => n.toString()))
      .filter((v, i, a) => a.indexOf(v) === i);
    output.queries.commands = ast
      .find(nodeType.Q(nodeType.BashCommandCommand))
      .map((n) => n.toString())
      .filter((v, i, a) => a.indexOf(v) === i);
    for (const v of violations) {
      const node = await v.repair({ clone: true });
      output.violations.push({
        rule: v.rule,
        position: v.node.position,
        repaired: (node.getParent(nodeType.DockerFile) || node).toString(true),
      });
    }
    console.log(`Analyzed docker file with ${violations.length} violations`);
    res.send(output);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});

app.post("/api/analyze/*", async (req, res) => {
  const path = req.path.replace("/api/analyze/", "");

  const dockerPath = join(__dirname, "data/evaluation/dockerfiles", path);
  const outputPath = join(__dirname, "data/evaluation/repaired", path);

  try {
    const out = await analyzeDockerfile(
      await readFile(dockerPath, "utf-8"),
      dockerPath,
      outputPath
    );
    console.log(dockerPath, outputPath);
    console.log(out?.map((o) => o.rule.name));
  } catch (e) {
    console.error(e);
  } finally {
    res.send("ok");
  }
});

app.get("/api/smells/", async (req, res) => {
  res.json(BINNACLE_RULES.map((r) => r.name));
});
app.get("/api/samples/:file/parfum", async (req, res) => {
  const file = req.params.file;
  const parfumResultPath = join(
    config.defaultBinnacleAnalysisAndRepairPath,
    file.replace(".Dockerfile", ".json")
  );
  res.sendFile(parfumResultPath);
});
const binnacleResultPath = join(
  config.dataFolder,
  "dataset/binnacle/results-github-individual.txt"
);
const binnacleResults = readFileSync(binnacleResultPath, "utf-8").split("\n");
app.get("/api/samples/:file/binnacle", async (req, res) => {
  const file = req.params.file.replace(".Dockerfile", "");
  for (const line of binnacleResults) {
    if (!line.endsWith(`"${file}"}`)) continue;
    try {
      const d = JSON.parse(line);
      if (d.file_sha != file) {
        continue;
      }
      return res.json(d);
    } catch (error) {}
  }
  res.json(null);
});
app.get("/api/samples/:file", async (req, res) => {
  const file = req.params.file;
  const dockerPath = join(
    config.datasetFolder,
    "ground-truth/dockerfiles",
    file
  );
  res.sendFile(dockerPath);
});
app.get("/api/samples", async (req, res) => {
  const files = walkSync(
    join(config.datasetFolder, "ground-truth/dockerfiles")
  );
  const output = files.map((f) => {
    const o = {
      name: basename(f),
      groundtruth: undefined,
    };
    try {
      o.groundtruth = JSON.parse(
        readFileSync(
          join(
            config.datasetFolder,
            "ground-truth/smells",
            basename(f).replace(".Dockerfile", ".json")
          ),
          "utf-8"
        ) as string
      );
    } catch (e) {}

    return o;
  });
  res.json(output);
});

app.post("/api/samples/:file", async (req, res) => {
  const file = req.params.file;
  const outputPath = join(
    config.datasetFolder,
    "ground-truth/smells",
    basename(file).replace(".Dockerfile", ".json")
  );
  try {
    await writeFile(outputPath, JSON.stringify(req.body));
    res.send("ok");
  } catch (e) {
    res.status(500).send(e.message);
  }
});
app.listen(PORT, function () {
  console.log("Example app listening on port " + PORT);
});
