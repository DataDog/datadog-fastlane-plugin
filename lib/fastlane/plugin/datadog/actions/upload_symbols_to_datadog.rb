require 'fastlane/action'

module Fastlane
  module Actions
    class UploadSymbolsToDatadogAction < Action
      def self.run(params)
        ENV['DATADOG_API_KEY'] = params[:api_key]
        dsym_paths = params[:dsym_paths] # get array of paths
        if dsym_paths.instance_of?(String) # if a string is passed, put it in an array
          dsym_paths = [dsym_paths]
        end

        error = ''
        is_dry_run = params[:dry_run]
        dsym_paths.each do |path|
          upload_path(path, is_dry_run)
        rescue FastlaneShellError => e
          error << e.to_s
        end

        raise error unless error.empty?
      end

      def self.upload_path(path, is_dry_run)
        cmd = 'npx @datadog/datadog-ci dsyms upload '
        cmd += path
        if is_dry_run
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
        "If you are sending your crashes to Datadog, they will appear without symbol names.
        You also need to provide dSYM files to symbolicate your crash reports.
        When used with download_dsyms action, no need to specify dsym_paths parameter.
        This action is a wrapper around datadog-ci npm package, for more info: https://github.com/DataDog/datadog-ci/blob/master/src/commands/dsyms/README.md"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
          env_name: 'DATADOG_API_KEY',
          description: "Datadog API Key for upload_symbols_to_datadog",
          verify_block: proc do |value|
            UI.user_error!("No API key for UploadSymbolsToDatadogAction given, pass using `api_key: 'api_key'`") unless value && !value.empty?
          end),
          FastlaneCore::ConfigItem.new(key: :dsym_paths,
          default_value: Actions.lane_context[SharedValues::DSYM_PATHS],
          description: "An array of the folders and/or the zip files which contains the dSYM files",
          type: Array),
          FastlaneCore::ConfigItem.new(key: :dry_run,
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
          'upload_symbols_to_datadog(api_key: "my-api-key", dsym_paths: "~/Downloads/appdSYMs.zip")',
          'upload_symbols_to_datadog(api_key: "my-api-key", dsym_paths: "~/Library/Developer/Xcode/DerivedData/MyApp-somerandomstring/")'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
