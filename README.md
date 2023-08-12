<div align="center">

# asdf-jfrog-cli [![Build](https://github.com/claygorman/asdf-jfrog-cli/actions/workflows/build.yml/badge.svg)](https://github.com/claygorman/asdf-jfrog-cli/actions/workflows/build.yml) [![Lint](https://github.com/claygorman/asdf-jfrog-cli/actions/workflows/lint.yml/badge.svg)](https://github.com/claygorman/asdf-jfrog-cli/actions/workflows/lint.yml)

[jfrog-cli](https://github.com/claygorman/asdf-jfrog-cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add jfrog-cli
# or
asdf plugin add jfrog-cli https://github.com/claygorman/asdf-jfrog-cli.git
```

jfrog-cli:

```shell
# Show all installable versions
asdf list-all jfrog-cli

# Install specific version
asdf install jfrog-cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global jfrog-cli latest

# Now jfrog-cli commands are available
jf --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/claygorman/asdf-jfrog-cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Clay Gorman](https://github.com/claygorman/)
