require 'fastlane/action'

module Fastlane
  module Actions
    class UploadSymbolsToDatadogAction < Action
      def self.run(params)
        ENV['DATADOG_API_KEY'] = params[:api_key]
        cmd = 'npx @datadog/datadog-ci dsyms upload '
        cmd += params[:dsym_path]
        if params[:dry_run]
          cmd += ' --dry-run'
        end

        sh(cmd)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Uploads dSYM files to Datadog in order to symbolicate crash reports"
      end

      def self.details
        "When used with download_dsyms action, no need to specify dsym_path parameter.
        If you are sending your crashes to Datadog, they will appear without symbol names.
        You also need to provide dSYM files to symbolicate your crash reports.
        This action is a wrapper around datadog-ci npm package, for more info: https://github.com/DataDog/datadog-ci/blob/master/src/commands/dsyms/README.md"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: 'FL_DATADOG_API_KEY',
                                       default_value: ENV['DATADOG_API_KEY'],
                                       description: "Datadog API Key for UploadSymbolsToDatadogAction",
                                       verify_block: proc do |value|
                                         UI.user_error!("No API key for UploadSymbolsToDatadogAction given, pass using `api_key: 'api_key'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: "FL_DSYM_PATH",
                                       default_value: Actions.lane_context[SharedValues::DSYM_PATHS],
                                       description: "Either the folder or the zip file which contains the dSYM files"),
          FastlaneCore::ConfigItem.new(key: :dry_run,
                                       env_name: "FL_DRY_RUN",
                                       description: "No upload to Datadog",
                                       default_value: false,
                                       is_string: false)
        ]
      end

      def self.authors
        ["buranmert", "ncreated", "maxep"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.example_code
        [
          'upload_symbols_to_datadog(api_key: "my-api-key", dsym_path: "~/Downloads/appdSYMs.zip")',
          'upload_symbols_to_datadog(api_key: "my-api-key", dsym_path: "~/Library/Developer/Xcode/DerivedData/")'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
