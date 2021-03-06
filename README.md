# Sanctify

Sanctify is a gem that allows you to scan the git diff of any repo for secrets before you commit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem install 'sanctify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sanctify

## Usage

Run sanctify as part of the pre-commit hook, which will make sure to find and deny secrets before commit and PR. You can use the [precommit hook project](http://pre-commit.com/) to easily integrate this script with your repo. You can also run as a standalone command. If it fails, you'll get an exit code of 1 otherwise, 0 so you can very easily integrate it into bash scripts.

Sancitfy has very simple usage:

```
Usage: sanctify [-r REPO_PATH] [-c CONFIG_PATH] [-d FROM_COMMIT..TO_COMMIT | -d FROM_COMMIT]
    -r, --repo REPO                  Repo to test
    -c, --config CONFIG              Configuration file in YAML
    -d, --diff DIFF                  Specify a diff or commit from which to check secrets
    -v, --version                    Prints the version and exits
    -h, --help                       Prints this help
```

To integrate with pre-commit, add the following to your `pre-commit-config.yaml`:

```
repos:
-   repo: https://github.com/onetwopunch/sanctify
    sha: v0.2.5
    hooks:
    -   id: sanctify
        args:
        - -c
        - sanctify.yml
```

## Configuration

Sanctify supports two top-level objects in the config: `ignored_paths` and `custom_matchers`. Currently sanctify supports a number of default matchers, but you are free to add more to your config file under custom_matchers. If there is a file that you know has secrets or is a false positive, you can add a list of Ruby-style regexes to ignore certain files.

Here's an example config file:

```yaml
---
custom_matchers:
  - description: "Test Description"
    regex: "secret.*"

ignored_paths:
  - test.*
  - .*thing.rb

```

The list of current default matchers are located in  `lib/sanctify/matcher_list.rb`:

```ruby
[
  {
    description: "AWS Access Key ID",
    regex: /AKIA[0-9A-Z]{16}/
  },
  {
    description: "SSH RSA Private Key",
    regex: /^-----BEGIN RSA PRIVATE KEY-----$/
  },
  ...
]
```

If you see any problem with a default matcher list or would like to add another to the default list, please feel free to make a pull request.

## Troubleshooting

- If you are facing an issue with integration with a Rail project, where you are using rbenv, and get the following error:
```
An unexpected error has occurred: CalledProcessError: Command: (u'/bin/bash', u'/Users/ryan/.rbenv/shims/gem', 'build', 'sanctify.gemspec')
Return code: 1
Expected return code: 0
Output: (none)
Errors:
    WARNING:  See http://guides.rubygems.org/specification-reference/ for help
    ERROR:  While executing gem ... (Gem::InvalidSpecificationException)
        ["travis.yml", "literally every file in your Rails repo", ...]
```

This is an issue with pre-commit since they build their own version of rbenv that conflicts under certain circumstances I have yet to fully grok. The best way to get around this is to install sanctify external to the pre-commit repo.

In your pre-commit-config.yaml:

```yaml
-   repo: local
    hooks:
    -   id: secret-check-hook
        name: "Sanctify Secret Scanner"
        entry: ./bin/secret-check
        language: script
        files: .
```

And then in the `./bin/secret-check` file just install and run sanctify:

```bash
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ ! $(which sanctify) ]]; then
  gem install sanctify
fi

sanctify -c $DIR/sanctify.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/onetwopunch/sanctify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sanctify project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/onetwopunch/sanctify/blob/master/CODE_OF_CONDUCT.md).
