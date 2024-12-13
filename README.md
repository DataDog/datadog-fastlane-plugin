# datadog plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-datadog)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-datadog`, add it to your project by running:

```bash
fastlane add_plugin datadog
```

## About datadog

Datadog plugin helps you uploading dSYM files to Datadog in order to symbolicate crash reports.

If you are sending crashes to Datadog, they will appear without symbol names. You also need to provide dSYM files to symbolicate your crash reports.

When used with `download_dsyms` action, no need to specify `dsym_paths` parameter.
This action is a wrapper around `datadog-ci` npm package, you can look at [`datadog-ci` documentation](https://github.com/DataDog/datadog-ci/blob/master/src/commands/dsyms/README.md) for more info.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

You can use `DATADOG_API_KEY` environment variable instead of `api_key` parameter in `Fastfile` as well as the `DATADOG_SITE` instead of the `site` parameter.

To validate the paths of dSYM files, you can enable the `throw_errors` parameter to raise an error if any files are missing.

```ruby
# upload symbols from...
lane :upload_dsyms do |options|
  upload_symbols_to_datadog(
    api_key: "datadog-api-key",
    dsym_paths: [
      "~/Downloads/appdSYMs.zip", # ...a zip file...
      "~/some/folder/with/dsym/files/" # ...or from a folder
    ],
    dry_run: options[:dry_run],
    throw_errors: options[:throw_errors]
  )
end

# download_dsyms action feeds dsym_paths automatically
lane :upload_dsym_with_download_dsyms do |options|
  download_dsyms options
  upload_symbols_to_datadog(api_key: "datadog-api-key")
end

# Upload to EU site
lane :upload_dsym_with_download_dsyms do |options|
  download_dsyms options
  upload_symbols_to_datadog(
    api_key: "datadog-api-key",
    site: 'datadoghq.eu'
  )
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
