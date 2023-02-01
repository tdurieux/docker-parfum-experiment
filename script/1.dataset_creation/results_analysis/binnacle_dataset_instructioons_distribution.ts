import lzma from "lzma-native";
import tar from "tar-stream";
import fs from "fs";
import { join } from "path";
import { parseDocker } from "@tdurieux/dinghy";
import config from "../../../config";

(async () => {
  return new Promise<void>((resolve) => {
    const extract = tar.extract();

    const distribution = {};
    extract.on("entry", function (header, stream, next) {
      let fileContent = "";
      stream.on("end", async function () {
        try {
          const ast = await parseDocker(fileContent);
          distribution[ast.children.length] = distribution[ast.children.length]
            ? distribution[ast.children.length] + 1
            : 1;
        } catch (error) {
          console.log(error);
        } finally {
          next();
        }
      });
      stream.on("data", (d: Buffer) => {
        fileContent += d.toString("utf-8");
      });
    });

    extract.on("finish", function () {
      // all entries done - lets finalize it
      console.log(JSON.stringify(distribution, null, 2));
    });
    fs.createReadStream(join(config.datasetFolder, "binnacle/github.tar.xz"))
      .pipe(lzma.createDecompressor())
      .pipe(extract)
      .on("finish", () => resolve());
  });
})();
