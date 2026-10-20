describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_symbols_to_datadog" do
      before(:each) do
        ENV['DATADOG_API_KEY'] = nil
        ENV['DATADOG_SITE'] = nil
      end

      it "set datadog-ci env variables" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/'))

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', dsym_path, '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              site: 'datadoghq.eu',
              dsym_paths: '#{dsym_path}',
              dry_run: true,
              throw_errors: false
            )
          end"
        ).runner.execute(:test)

        expect(ENV['DATADOG_API_KEY']).to eq("mock-api-key")
        expect(ENV['DATADOG_SITE']).to eq("datadoghq.eu")
      end

      it "uploads dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/'))

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', dsym_path, '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: true,
              throw_errors: false
            )
          end"
        ).runner.execute(:test)
      end

      it "uploads zip file containing dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/Themoji.dSYM.zip'))

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', dsym_path, '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: 'true',
              throw_errors: false
            )
          end"
        ).runner.execute(:test)
      end

      it "passes paths with special characters verbatim" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/My dSYMs (debug) & $tuff/'))

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', dsym_path, '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: true,
              throw_errors: false
            )
          end"
        ).runner.execute(:test)
      end

      it "uploads multiple folders" do
        dsym_paths = [
          File.expand_path(File.join('./spec/fixtures/dSYM1/')),
          File.expand_path(File.join('./spec/fixtures with spaces/dSYM2/'))
        ]

        dsym_paths.each do |path|
          expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
            .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', path, '--dry-run')
        end

        Fastlane::FastFile.new.parse(
          "lane :test do
              upload_symbols_to_datadog(
                api_key: 'mock-api-key',
                dsym_paths: #{dsym_paths},
                dry_run: true,
                throw_errors: false
              )
          end"
        ).runner.execute(:test)
      end

      it "expands home-relative paths before upload" do
        dsym_path = '~/Downloads/app dSYMs.zip'

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', File.expand_path(dsym_path), '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: true,
              throw_errors: false
            )
          end"
        ).runner.execute(:test)
      end

      it "uses lane context to get dsym_path" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/'))

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with('npx', '@datadog/datadog-ci', 'dsyms', 'upload', dsym_path, '--dry-run')

        Fastlane::FastFile.new.parse(
          "lane :test do
            Actions.lane_context[SharedValues::DSYM_PATHS] = ['#{dsym_path}']
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dry_run: true,
              throw_errors: false
            )
          end"
        ).runner.execute(:test)
      end
    end
  end
end
