# Jenkins Docker image

This image is based on the "official" [Jenkins Docker image](https://github.com/jenkinsci/docker).

Please have a look at the [Dockerfile](https://github.com/devopskube/docker-jenkins/blob/master/Dockerfile).

The system property "jenkins.install.runSetupWizard" is set to false, so that the setup wizard is not run. Furthermore the plugins listed in the file plugins.txt are installed (latest version).

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/devopskube/docker-jenkins/issues) they may encounter

## Building

If you would like to build this docker image, you are able to use our Makefile. This file invokes `docker build` if the target `make build` is called. Another interesting target is the `make bump` target. With this target the version is bumped and a tag in the git repository is created. This is done using the python "[bumpversion](https://pypi.python.org/pypi/bumpversion)" tool, which can be installed using `pip install --upgrade bumpversion`. Per default, the patch number is incremented. to bump the minor and/or major number, please call make using the `PART`-parameter using the corresponding parameter (patch|minor|major). By default PART is set to `patch`. The following call will bump the minor number:

```bash
make bump PART=minor
```

Please note, that the above mentioned script will only work, if the git repository is clean (no local changes). It will change the version in the project.yml file, commit it and create a tag. All of this is then pushed automatically to the remote repository. Most of the behavior bumpversion can be modified using the .bumpversion.cfg.
