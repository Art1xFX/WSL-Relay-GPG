# Agent instructions

## Environment files

- Never read, open, search, print, parse, or otherwise inspect the contents of `.env` files.
- Treat `.env` files as potentially containing secrets. Do not access them through editor tools, shell commands, scripts, or subprocesses.
- If a task requires values from a `.env` file outside that retry, ask the user to provide only the specific non-sensitive information needed.

## Tests

- Run only targeted tests relevant to the change when the runner supports test selection; avoid the full benchmark unless it is necessary.
- Prefer focused runs to reduce token and execution costs.

## Tools

- Prefer the available purpose-built tool for an operation and use it when one exists.
- Do not replace an available tool with a command-line binary or shell command; use the fallback commands below only when no corresponding tool is available.

## Fallbacks

- If no corresponding tool is available for searching files, use `rg` or `find`.
- Use `jq` for JSON and `yq` for YAML and TOML whenever you need to inspect, query, validate, or modify those files. Do not use Python scripts or Python libraries to process YAML or TOML, even when they are available.
- When modifying files, preserve their existing formatting, including indentation, quoting style, and blank lines. Do not add quotes where the original values were unquoted, and retain existing blank lines. Configure tools to preserve this formatting and avoid reformatting unrelated content.
