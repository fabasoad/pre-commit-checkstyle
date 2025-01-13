# Checkstyle pre-commit hooks

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
![GitHub release](https://img.shields.io/github/v/release/fabasoad/pre-commit-checkstyle?include_prereleases)
![security](https://github.com/fabasoad/pre-commit-checkstyle/actions/workflows/security.yml/badge.svg)
![linting](https://github.com/fabasoad/pre-commit-checkstyle/actions/workflows/linting.yml/badge.svg)
![functional-tests](https://github.com/fabasoad/pre-commit-checkstyle/actions/workflows/functional-tests.yml/badge.svg)

## Table of Contents

<!-- prettier-ignore-start -->

<!-- TOC -->
- [Checkstyle pre-commit hooks](#checkstyle-pre-commit-hooks)
  - [Table of Contents](#table-of-contents)
  - [How it works?](#how-it-works)
  - [Prerequisites](#prerequisites)
  - [Hooks](#hooks)
    - [checkstyle](#checkstyle)
    - [checkstyle-google](#checkstyle-google)
    - [checkstyle-sun](#checkstyle-sun)
  - [Customization](#customization)
    - [Description](#description)
    - [Parameters](#parameters)
      - [Checkstyle](#checkstyle-parameters)
      - [pre-commit-checkstyle](#pre-commit-checkstyle)
        - [Log level](#log-level)
        - [Log color](#log-color)
        - [Checkstyle version](#checkstyle-version)
        - [Clean cache](#clean-cache)
    - [Examples](#examples)
  - [Contributions](#contributions)
<!-- TOC -->

<!-- prettier-ignore-end -->

## How it works?

At first hook tries to use globally installed [checkstyle](https://github.com/checkstyle/checkstyle)
CLI. And if it doesn't exist then hook installs `checkstyle.jar` into a
`.fabasoad/pre-commit-checkstyle` temporary directory that will be removed after
scanning is completed.

## Prerequisites

The following tools have to be available on a runner prior using this pre-commit
hook:

- [bash >=4.0](https://www.gnu.org/software/bash/)
- [curl](https://curl.se/)

## Hooks

<!-- markdownlint-disable-next-line MD013 -->

> `<rev>` in the examples below, is the latest revision tag from [fabasoad/pre-commit-checkstyle](https://github.com/fabasoad/pre-commit-checkstyle/releases)
> repository.

### checkstyle

This hook runs `checkstyle` without specifying config file. Config file parameter
is required and must be specified by the user:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle
        args:
          - --checkstyle-args=-c config.xml
```

### checkstyle-google

This hook runs `checkstyle` with [google_checks.xml](https://github.com/checkstyle/checkstyle/blob/master/src/main/resources/google_checks.xml)
config file. User does not have to define anything using this hook:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle-google
```

### checkstyle-sun

This hook runs `checkstyle` with [sun_checks.xml](https://github.com/checkstyle/checkstyle/blob/master/src/main/resources/sun_checks.xml)
config file. User does not have to define anything using this hook:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle-sun
```

## Customization

### Description

There are 2 ways to customize scanning for both `checkstyle` and `pre-commit-checkstyle`:
environment variables and arguments passed to [args](https://pre-commit.com/#config-args).

You can pass arguments to the hook as well as to the `checkstyle` itself. To distinguish
parameters you need to use `--checkstyle-args` for `checkstyle` arguments and `--hook-args`
for `pre-commit-checkstyle` arguments. Supported delimiter is `=`. So, use `--hook-args=<arg>`
but not `--hook-args <arg>`. Please find [Examples](#examples) for more details.

### Parameters

#### Checkstyle Parameters

You can [install](https://github.com/checkstyle/checkstyle?tab=readme-ov-file#quick-start)
`checkstyle.jar` locally and run `java -jar checkstyle.jar --help` to see all the
available arguments:

<!-- markdownlint-disable MD013 -->

```shell
$ java -jar checkstyle.jar --version
Checkstyle version: 10.21.1

$ java -jar checkstyle.jar --help
Usage: checkstyle [-dEghjJtTV] [-b=<xpath>] [-c=<configurationFile>] [-f=<format>]
                  [-o=<outputPath>] [-p=<propertiesFile>] [-s=<suppressionLineColumnNumber>]
                  [-w=<tabWidth>] [-e=<exclude>]... [-x=<excludeRegex>]... <files>...
Checkstyle verifies that the specified source code files adhere to the specified rules. By default,
violations are reported to standard out in plain format. Checkstyle requires a configuration XML
file that configures the checks to apply.
      <files>...            One or more source files to verify
  -b, --branch-matching-xpath=<xpath>
                            Shows Abstract Syntax Tree(AST) branches that match given XPath query.
  -c=<configurationFile>    Specifies the location of the file that defines the configuration
                              modules. The location can either be a filesystem location, or a name
                              passed to the ClassLoader.getResource() method.
  -d, --debug               Prints all debug logging of CheckStyle utility.
  -e, --exclude=<exclude>   Directory/file to exclude from CheckStyle. The path can be the full,
                              absolute path, or relative to the current path. Multiple excludes are
                              allowed.
  -E, --executeIgnoredModules
                            Allows ignored modules to be run.
  -f=<format>               Specifies the output format. Valid values: xml, sarif, plain for
                              XMLLogger, SarifLogger, and DefaultLogger respectively. Defaults to
                              plain.
  -g, --generate-xpath-suppression
                            Generates to output a suppression xml to use to suppress all violations
                              from user's config. Instead of printing every violation, all
                              violations will be catched and single suppressions xml file will be
                              printed out. Used only with -c option. Output location can be
                              specified with -o option.
  -h, --help                Show this help message and exit.
  -j, --javadocTree         This option is used to print the Parse Tree of the Javadoc comment. The
                              file has to contain only Javadoc comment content excluding '/**' and
                              '*/' at the beginning and at the end respectively. It can only be
                              used on a single file and cannot be combined with other options.
  -J, --treeWithJavadoc     This option is used to display the Abstract Syntax Tree (AST) with
                              Javadoc nodes of the specified file. It can only be used on a single
                              file and cannot be combined with other options.
  -o=<outputPath>           Sets the output file. Defaults to stdout.
  -p=<propertiesFile>       Sets the property files to load.
  -s=<suppressionLineColumnNumber>
                            Prints xpath suppressions at the file's line and column position.
                              Argument is the line and column number (separated by a : ) in the
                              file that the suppression should be generated for. The option cannot
                              be used with other options and requires exactly one file to run on to
                              be specified. Note that the generated result will have few queries,
                              joined by pipe(|). Together they will match all AST nodes on
                              specified line and column. You need to choose only one and recheck
                              that it works. Usage of all of them is also ok, but might result in
                              undesirable matching and suppress other issues.
  -t, --tree                This option is used to display the Abstract Syntax Tree (AST) without
                              any comments of the specified file. It can only be used on a single
                              file and cannot be combined with other options.
  -T, --treeWithComments    This option is used to display the Abstract Syntax Tree (AST) with
                              comment nodes excluding Javadoc of the specified file. It can only be
                              used on a single file and cannot be combined with other options.
  -V, --version             Print version information and exit.
  -w, --tabWidth=<tabWidth> Sets the length of the tab character. Used only with -s option. Default
                              value is 8.
  -x, --exclude-regexp=<excludeRegex>
                            Directory/file pattern to exclude from CheckStyle. Multiple excludes
                              are allowed.
```

<!-- markdownlint-enable MD013 -->

#### pre-commit-checkstyle

Here is the precedence order of `pre-commit-checkstyle` tool:

- Parameter passed to the hook as argument via `--hook-args`.
- Environment variable.
- Default value.

For example, if you set `PRE_COMMIT_CHECKSTYLE_LOG_LEVEL=warning` and `--hook-args=--log-level
error` then `error` value will be used.

##### Log level

With this parameter you can control the log level of `pre-commit-checkstyle` hook
output. It doesn't impact `checkstyle` log level output. To control `checkstyle`
log level output please look at the [Checkstyle parameters](#checkstyle).

- Parameter name: `--log-level`
- Environment variable: `PRE_COMMIT_CHECKSTYLE_LOG_LEVEL`
- Possible values: `debug`, `info`, `warning`, `error`
- Default: `info`

##### Log color

With this parameter you can enable/disable the coloring of `pre-commit-checkstyle`
hook logs. It doesn't impact `checkstyle` logs coloring.

- Parameter name: `--log-color`
- Environment variable: `PRE_COMMIT_CHECKSTYLE_LOG_COLOR`
- Possible values: `true`, `false`
- Default: `true`

##### Checkstyle version

Specifies specific `checkstyle` version to use. This will work only if `checkstyle`
is not globally installed, otherwise globally installed `checkstyle` takes precedence.

- Parameter name: `--checkstyle-version`
- Environment variable: `PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION`
- Possible values: Checkstyle version that you can find [here](https://github.com/checkstyle/checkstyle/releases)
- Default: `latest`

##### Clean cache

With this parameter you can choose either to keep cache directory (`.fabasoad/pre-commit-checkstyle`),
or to remove it. By default, it removes cache directory. With `false` parameter
cache directory will not be removed which means that if `checkstyle` is not installed
globally every subsequent run won't download `checkstyle` again. Don't forget to
add cache directory into the `.gitignore` file.

- Parameter name: `--clean-cache`
- Environment variable: `PRE_COMMIT_CHECKSTYLE_CLEAN_CACHE`
- Possible values: `true`, `false`
- Default: `true`

### Examples

Pass arguments separately from each other:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle
        args:
          - --hook-args=--log-level debug
          - --checkstyle-args=-c config.xml
          - --checkstyle-args=--debug
```

Pass arguments altogether grouped by category:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle
        args:
          - --hook-args=--log-level debug
          - --checkstyle-args=-c config.xml --debug
```

Set these parameters to have the minimal possible logs output:

```yaml
repos:
  - repo: https://github.com/fabasoad/pre-commit-checkstyle
    rev: <rev>
    hooks:
      - id: checkstyle-google
        args:
          - --hook-args=--log-level=error
```

## Contributions

<!-- TODO: -->
