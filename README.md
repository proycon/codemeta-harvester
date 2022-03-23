# Codemeta Harvester

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

This is a harvester for software metadata. It actively attempts to detect and
convert software metadata in source code repositories and converts this to a
unified [codemeta](https://codemeta.github.io) representation.

The tool is implemented as a simple POSIX shell script that in turn invokes a number of tools to
do the actual work:

* [codemetapy](https://github.com/proycon/codemetapy) - Conversion to codemeta from various other metadata formats
* [cffconvert](https://github.com/citation-file-format/cff-converter-python) - Conversion from CITATION.cff to codemeta
* [Software Metadata Extraction Framework (SOMEF)](https://github.com/KnowledgeCaptureAndDiscovery/somef) - Analyzes and extracts metadata from README.md and some other sources (optional dependency)

A few simple additional metadata extractions methods, as simple shell scripts, have been implemented alongside the main script.

This harvester can be used for two purposes:

1. to harvest a possibly large number of software projects, for instance to make them available in some kind of search portal.
2. as a means to produce a `codemeta.json` file for your own project

## Installation

A docker container can be build as follows:

``make docker``

A pre-built container image can also be pulled from Docker Hub once the software is released:

``docker pull proycon/codemeta-harvester``

Alternatively if you prefer not to use containers, you can also install the
software as follows:

* Run ``make env`` to build a Python virtual environment in the `env` directory with the needed dependencies. This assumes you have a Python installation on your system.
* Activate the environment with `. env/bin/activate` whenever you want to use it.
* You will need to also ensure to install the following dependencies using your system's package manager
    * git
    * curl
    * [dasel](https://github.com/TomWright/dasel)
    * [recode](https://github.com/rrthomas/recode/)
    * coreutils or busybox
    * GNU Make
    * GNU awk

## Usage: producing codemeta for your project

In your project directory, which ideally should be a git clone, you can just run codemeta-harvester to create a `codemeta.json`
file based on the files in your repository:

`codemeta-harvester`

You probably use the docker container, then the syntax is as follows:

`docker run -v .:/data proycon/codemeta-harvester`

The `-v` argument mounts your current working directory in the container.

If you want to regenerate an existing ``codemeta.json``, rather than use it as input which would be the default
behaviour, then add the ``--ignore`` parameter.

The harvester can make use of the Github API to query metdata from GitHub, but this allows only limited anonymous requests. Please set the
environment variable `$GITHUB_TOKEN` to a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token), if you use Docker you should pass it to the container using `--env-arg GITHUB_TOKEN=$GITHUB_TOKEN`.

## Usage: harvesting metadata for various projects

To harvest and collect metadata from various projects, you need to create configuration files that tells the harvester
where to look. These are simple ``yaml`` configuration files, one for each tool to harvest. They are put into a directory of your choice, and take the following format:

```yaml
source: https://github.com/user/repo
services:
    - https://example.org
```

The ``source`` property specifies a single source code repository where the source code of the tool lives. This must be  *git* repository that is publicly accessible.  Note that you can specify only one repository here, choose the one that is representative for the software as a whole.

The ``services`` property lists zero or more URLs where the tool can be accessed as a service. This may be a web application, simple webpage, or some other form of webservice. For webservices, rather than enumerate all service endpoints individually, this should be pointed to a URL that provides itself provides a specification of endpoints, for example a URL serving a [OpenAPI](https://www.openapis.org/) specification. The information provided here will be expressed in the resulting `codemeta.json` through the ``targetProduct`` schema.org property as described in issue [codemeta/codemeta#271](https://github.com/codemeta/codemeta/issues/271). This links the source code to specific instantiations of the software.

Additional properties you may specify:

* ``root`` - The root path in the source code repository where to look for metadata. This can be set if the tool lives
    as a sub-part of a larger repository. Defaults to the repository root.
* `scandirs` - Sub directories to scan for metadata, in case not everything lives in the root directory.
* `ref` - The git reference (a branch name of tag name) to use. You can set this if you want to harvest one particular
    version. If not set, codemeta-harvester will check out the latest
    version tag by default (this assumes you use some kind of semantic versioning for your tags). Only if no tags are present at all, it
    falls back to using the `master` or `main` branch directly.

Pass the directory where you put your configurations (or a single configuration file) to codemeta-harvester as follows:

`codemeta-harvester /path/to/your/configdir/`

Or for Docker:

`docker run -v /path/to/your/configdir/:/config -v .:/data proycon/codemeta-harvester /config`





