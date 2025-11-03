# How to use codmod

For official documentation and installation instructions, please refer to:
[App Modernization Assessment Documentation](https://cloud.google.com/migration-center/docs/app-modernization-assessment)


`codmod` is an AI-powered CLI tool that automates application modernization assessments by analyzing source code with Gemini and providing recommendations based on Google Cloud best practices.

## Prerequisites

- Linux or Windows (10 or newer) workstation.
- Access to a Google Cloud project with the Vertex AI API enabled.
- `gcloud` CLI installed and authenticated.

## Installation

### Linux
```bash
version=$(curl -s https://codmod-release.storage.googleapis.com/latest)
curl -O "https://codmod-release.storage.googleapis.com/${version}/linux/amd64/codmod"
chmod +x codmod
```
Add the executable to your PATH or create an alias.

### Windows (PowerShell)
```powershell
$version=curl.exe -s https://codmod-release.storage.googleapis.com/latest
curl.exe -O "https://codmod-release.storage.googleapis.com/${version}/windows/amd64/codmod.exe"
```
Add the executable to your PATH or create an alias.

## Authentication to Google Cloud

1.  Enable the Vertex AI API for your project:
    ```bash
    gcloud services enable aiplatform.googleapis.com --project <project-id>
    ```
2.  Ensure you have the `roles/aiplatform.user` role or similar on the project.
3.  Authenticate `gcloud`:
    ```bash
    gcloud auth application-default login
    ```

## Configuration

-   **List all settings:**
    ```bash
    codmod config list
    ```
-   **Set a default value (e.g., project ID):**
    ```bash
    codmod config set project "PROJECT_ID"
codmod config set region "REGION"
    ```
-   **Get a specific value (e.g., project ID):**
    ```bash
    codmod config get project
    ```
-   **Unset a default value (e.g., project ID):**
    ```bash
    codmod config unset project
    ```

## Creating an Assessment Report

### Default Report
```bash
codmod create -c "CODEBASE_DIRECTORY" -o "OUTPUT_REPORT.html"
```
-   `CODEBASE_DIRECTORY`: Path to the source code directory. Can be specified multiple times.
-   `OUTPUT_REPORT.html`: Path to save the generated HTML report.

### Optional Flags for `codmod create`

-   `--modelset [2.0-flash|2.5-flash|2.5-pro|adaptive]`: Specifies the Gemini model to use (default: `2.5-pro`).
-   `--format <html|markdown|odt|json>`: Output report format (default: `html`).
-   `--allow-large-codebase`: Skips confirmation for codebases larger than 1 million lines of code.
-   `--improve-fidelity`: Generates sections serially for improved consistency (longer runtime).
-   `--force-include <regex>`, `--force-exclude <regex>`: Include or exclude file extensions using RE2 syntax.
-   `--experiments`: e.g., `--experiments=enable_pdf,enable_images` to support PDFs and images.
-   `--context <string>`: Additional context for the report generation.
-   `--context-file <path>`: Provides context from a file.
-   `--supporting-documents <path>`: Directory of supporting documentation (text, PDF, images).

### Full Report
```bash
codmod create full -c "~/mycodebase/" -o "report.html"
```

### Data Layer Focused Report
```bash
codmod create data-layer -c "CODEBASE" -o "OUTPUT"
```

### Intent-Focused Report
```bash
codmod create -c "CODEBASE" -o "OUTPUT" --intent "INTENT"
```
Supported intents include:
-   `MICROSOFT_MODERNIZATION`
-   `CLOUD_TO_CLOUD`
-   `JAVA_LEGACY_TO_MODERN`
-   `WILDFLY_LEGACY_TO_MODERN`
-   `ARM_MIGRATION`

### Report with Additional Sections
```bash
codmod create -c "CODEBASE" -o "OUTPUT" --optional-sections "files,classes"
```
Supported sections: `files`, `classes`.

### Custom Report
```bash
codmod create custom -c "CODEBASE" -o "OUTPUT" --context "CONTEXT"
```
-   `--from-template <path>`: Specifies a template file for document structure.
-   `--skip-template-approval`: Skips approval when using `--from-template`.

## Experimental Features

### Enhanced Object-Level Assessment for APIs and .NET Dependencies
This experimental feature enhances CodMod's analysis capabilities, providing more granular and accurate insights into your codebase. It aims to aid modernization planning through object-level aggregations.

**Key Enhancements:**
*   **Detailed API Analysis:** Improves the detection and reporting of APIs and endpoints by using a new aggregation method.
*   **.NET NuGet Package Analysis:** For .NET applications, this adds a new "Package Dependencies Analysis" section, offering a breakdown of NuGet package dependencies.

**How to Enable:**
To try this feature, enable the experiment using the flag `--experiments=enable_object_level_assessment` when running `codmod`.

**Example Commands:**
*   **Full Report:**
    ```bash
    codmod create full -c "CODEBASE" -o "OUTPUT.html" --experiments=enable_object_level_assessment
    ```
*   **Microsoft Modernization:**
    ```bash
    codmod create --intent MICROSOFT_MODERNIZATION -c "CODEBASE" -o "OUTPUT.html" --experiments=enable_object_level_assessment
    ```

## Modifying an Existing Report

Commands that modify a report require `--from-report` (path to existing HTML report) and one of `--context` or `--context-file`.

### List Sections in a Report
```bash
codmod list-sections --from-report "REPORT.html"
```

### Revise a Report Section
```bash
codmod revise section -c "CODEBASE" --from-report "REPORT.html" \
  -o "REVISED_REPORT.html" --from-section "SECTION_NAME" \
  --context "CONTEXT"
```
Note: "Summary", "Further Analysis", "Files", and "Classes" sections are not supported for revision.

### Create a New Report Section
```bash
codmod create section -c "CODEBASE" --from-report "REPORT.html" \
  -o "REGENERATED_REPORT.html" --from-section "SECTION_NAME" \
  --context "CONTEXT"
```
The `--from-section` flag is optional.

## Estimating Assessment Costs
```bash
codmod create --estimate-cost -c "CODEBASE"
```
Cost estimates are not supported for `create section` and `create custom` commands.

## Setting Verbosity Level
```bash
codmod --verbosity LEVEL
```
`LEVEL` can be `debug`, `info`, `warn`, `error`, or `none` (default: `warn`).

## Version Checks
-   Automatic checks occur every 24 hours.
-   **Disable:** `codmod config set disable_version_check true`
-   **Enable:** `codmod config set disable_version_check false`

## Command-line Completion
Enable shell completion using `codmod completion <shell_name> --help` (e.g., `codmod completion bash --help`).

## Troubleshooting
-   **Permission denied:** Ensure execute permission (`chmod +x codmod`).
-   **CLI hangs:** Verify sufficient quota for the Gemini model (default: `gemini-2.5-pro`).
-   **Reporting errors:** Collect logs with `codmod collect-logs -o "codmod_logs.zip"`.

## Gemini CLI Integration (Experimental)

`codmod` can be integrated with the Gemini CLI to expose its commands as tools. This is an experimental feature.

### Starting the MCP Server

The `codmod mcpserver` command starts a local server that integrates with the Gemini CLI.

```bash
codmod mcpserver
```

### Configuration

To enable the integration, you need to configure the Gemini CLI by editing the `~/.gemini/settings.json` file. Add or update the `mcpServers` section to include the `codmod_server` configuration:

```json
{
  "mcpServers": {
    "codmod_server": {
      "command": "/path/to/your/codmod/codmod",
      "args": [
        "mcpserver"
      ],
      "timeout": 600000,
      "trust": true
    }
  }
}
```

Replace `/path/to/your/codmod/codmod` with the actual path to your `codmod` binary.

### Available Tools

When the MCP server is running, the following `codmod` commands become available as tools in the Gemini CLI:

*   `get_codmod_version`: Get the version of the CodMod tool.
*   `assess_java_modernization`: Assess Java modernization readiness.
*   `assess_dotnet_modernization`: Assess .NET modernization readiness.
*   `create_report`: Creates a default report by analyzing your codebase.
*   `create_full_report`: Creates a full overview report.
*   `create_custom_report`: Create a custom report based on provided context.
*   `create_section_report`: Add a new section to an existing HTML report.
*   `create_data_layer_report`: Creates a data layer report.
*   `revise_section`: Revise a specific section of an existing HTML report.
*   `list_sections`: List the sections of an HTML codmod report.
*   `config_list`: Print all configuration properties.
*   `config_get`: Get a configuration property value.
*   `config_set`: Set a configuration property value.
*   `config_unset`: Reset a configuration property.
*   `collect_logs`: Create an archive of config and log files.
