describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_symbols_to_datadog" do
      it "uploads dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/')).shellescape
        api_key = 'mock-api-key'

        command = []
        command << 'npx @datadog/datadog-ci dsyms upload'
        command << dsym_path
        command << '--dry-run'

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh).with(command.join(" "))

        Fastlane::FastFile.new.parse("lane :test do
          upload_symbols_to_datadog(
          api_key: '#{api_key}',
          dsym_paths: '#{dsym_path}',
          dry_run: true)
        end").runner.execute(:test)
      end

      it "uploads zip file containing dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/Themoji.dSYM.zip')).shellescape
        api_key = 'mock-api-key'

        command = []
        command << 'npx @datadog/datadog-ci dsyms upload'
        command << dsym_path
        command << '--dry-run'

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh).with(command.join(" "))

        Fastlane::FastFile.new.parse("lane :test do
          upload_symbols_to_datadog(
          api_key: '#{api_key}',
          dsym_paths: '#{dsym_path}',
          dry_run: 'true')
        end").runner.execute(:test)
      end

      it "uploads multiple folders" do
        api_key = 'mock-api-key'

        dsym_paths = [
          File.expand_path(File.join('./spec/fixtures/dSYM1/')).shellescape,
          File.expand_path(File.join('./spec/fixtures/dSYM2/')).shellescape
        ]
        commands = dsym_paths.map do |path|
          cmd = []
          cmd << 'npx @datadog/datadog-ci dsyms upload'
          cmd << path
          cmd << '--dry-run'

          cmd
        end

        commands.each do |cmd|
          expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh).with(cmd.join(" "))
        end

        Fastlane::FastFile.new.parse("lane :test do
          upload_symbols_to_datadog(
          api_key: '#{api_key}',
          dsym_paths: #{dsym_paths},
          dry_run: true)
        end").runner.execute(:test)
      end

      it "uses lane context to get dsym_path" do
        dsym_path = 'some-path'
        api_key = 'mock-api-key'

        command = []
        command << 'npx @datadog/datadog-ci dsyms upload'
        command << dsym_path
        command << '--dry-run'

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh).with(command.join(" "))

        Fastlane::FastFile.new.parse("lane :test do
          Actions.lane_context[SharedValues::DSYM_PATHS] = ['#{dsym_path}']
          upload_symbols_to_datadog(
          api_key: '#{api_key}',
          dry_run: 'true')
        end").runner.execute(:test)
      end
    end
  end
end
