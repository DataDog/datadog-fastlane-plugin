# datadog plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-datadog)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-datadog`, add it to your project by running:

```bash
fastlane add_plugin datadog
```

## About datadog

Datadog plugin helps you uploading dSYM files to Datadog in order to symbolicate crash reports.

When used with `download_dsyms` action, no need to specify `dsym_path` parameter.
If you are sending your crashes to Datadog, they will appear without symbol names. You also need to provide dSYM files to symbolicate your crash reports.
This action is a wrapper around `datadog-ci` npm package, for more info: https://github.com/DataDog/datadog-ci/blob/master/src/commands/dsyms/README.md

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```ruby
# upload symbols from a zip file
lane :upload_dsym do
  upload_symbols_to_datadog(
    api_key: "some-api-key", 
    dsym_path: "~/Downloads/appdSYMs.zip"
  )
end

# upload symbols from a folder
lane :upload_dsym do
  upload_symbols_to_datadog(
    api_key: "some-api-key", 
    dsym_path: "~/some/folder/with/dsym/files/"
  )
end

# with download_dsyms action which feeds dsym_path automatically
lane :upload_dsym do
  download_dsyms
  upload_symbols_to_datadog(api_key: "some-api-key")
end

```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
