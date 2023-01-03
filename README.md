# Codemeta Harvester
 
[![Project Status: Active -- The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

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

You can use ``make devenv`` if you want to rely on the latest development release of codemetapy, rather than the latest
stable version (this will create a `devenv/` dir instead of `env/`)

## Usage: producing codemeta for your project

In your project directory, which ideally should be a git clone, you can just run codemeta-harvester to create a `codemeta.json`
file based on the files in your repository:

`codemeta-harvester`

You probably use the docker container, then the syntax is as follows:

`docker run -v $(pwd):/data proycon/codemeta-harvester`

The `-v` argument mounts your current working directory in the container, you may adapt it according to your needs.

If you want to regenerate an existing ``codemeta.json``, rather than use it as input which would be the default
behaviour, then add the ``--regen`` parameter. This overwrites any existing `codemeta.json`.

The harvester can make use of the Github/GitLab API to query metdata from GitHub/GitLab, but this allows only limited anonymous requests. Please set the
environment variable `$GITHUB_TOKEN`/`$GITLAB_TOKEN` to a [github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) / [gitlab personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html), if you use Docker you should pass it to the container using `--env-arg GITHUB_TOKEN=$GITHUB_TOKEN`/`--env-arg GITLAB_TOKEN=$GITLAB_TOKEN`.

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
* `tagprefix` - A prefix used for the git tags (only applicable in edge cases), the last part of the tag must still comply to a semantic versioning scheme.

Pass the directory where you put your configurations (or a single configuration file) to codemeta-harvester as follows:

`codemeta-harvester /path/to/your/configdir/`

Or for Docker:

`docker run -v /path/to/your/configdir/:/config -v $(pwd):/data proycon/codemeta-harvester /config`

## Composition and precedence

Codemeta-harvester relies [codemetapy](https://github.com/proycon/codemetapy) to combine different input sources into one `codemeta.json`, we call this *composition*. 

When a certain input source defines a property (on `schema:SoftwareSourceCode`), it will *overwrite* any values that were set earlier by previous sources. This entails that there is a certain order of precedence in which sources codemeta-harvester considers more important than others. The priority is roughly the following:

1. ``codemeta.json``, if this file is provided, the harvest won't look at anything else (aside from the three exceptions mentioned at the end).
2. ``codemeta-harvest.json``
3. ``CITATION.cff``
3. Language specific metadata from ``setup.py``, ``pyproject.toml``, ``pom.xml``, ``package.json`` and similar.
4. files such as `LICENSE`,  `CONTRIBUTORS`, `AUTHORS`, `README`
5. Information from git (e.g. contributors, git tag for version, date of first/last commit)
6. Information from the github or gitlab API (e.g. project name/description)

Three notable exceptions are:

1. For development status, repostatus badge in the `README.md` *in the git master/main branch* takes precendence over all else (overriding whatever is in codemeta.json!)
2. For maintainers, the parsing of `MAINTAINERS` *in the git master/main branch* is always taken into account (merged with anything in codemeta.json)
3. If the harvester finds a version-specific DOI at [Zenodo](https://zenodo.org) for your software, it will always use that (overriding whatever is in codemeta.json)

## Acknowledgement

This software was funded in the scope of the [CLARIAH-PLUS project](https://clariah.nl).
