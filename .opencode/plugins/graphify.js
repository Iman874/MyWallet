const { existsSync } = require("fs");
const { join } = require("path");

module.exports = {
  GraphifyPlugin: async ({ directory }) => {
    let reminded = false;

    return {
      "tool.execute.before": async (input, output) => {
        if (reminded) return;
        if (!existsSync(join(directory, ".graphify", "graph.json"))) return;

        if (input.tool === "bash") {
          output.args.command =
            'echo "[graphify] Knowledge graph at .graphify/. For focused questions, run graphify query "<question>" (scoped subgraph, usually much smaller than GRAPH_REPORT.md) instead of grepping raw files. Read GRAPH_REPORT.md only for broad architecture context." && ' +
            output.args.command;
          reminded = true;
        }
      },
    };
  },
};
};
