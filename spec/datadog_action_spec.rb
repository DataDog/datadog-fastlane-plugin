describe Fastlane do
  describe Fastlane::FastFile do
    describe "upload_symbols_to_datadog" do
      before(:each) do
        ENV['DATADOG_API_KEY'] = nil
        ENV['DATADOG_SITE'] = nil
      end

      it "set env variables" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/')).shellescape

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with("npx @datadog/datadog-ci dsyms upload #{dsym_path} --dry-run")

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: true
            )
          end"
        ).runner.execute(:test)

        expect(ENV['DATADOG_API_KEY']).to eq("mock-api-key")
        expect(ENV['DATADOG_SITE']).to eq("datadoghq.com")
      end

      it "set custom site env" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/')).shellescape

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with("npx @datadog/datadog-ci dsyms upload #{dsym_path} --dry-run")

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              site: 'datadoghq.eu',
              dsym_paths: '#{dsym_path}',
              dry_run: true
            )
          end"
        ).runner.execute(:test)

        expect(ENV['DATADOG_SITE']).to eq("datadoghq.eu")
      end

      it "fails with wrong site" do
        expect do
          Fastlane::FastFile.new.parse(
            "lane :test do
              upload_symbols_to_datadog(
                api_key: 'mock-api-key',
                site: 'wrong.site',
                dsym_paths: 'some-path',
                dry_run: true
              )
            end"
          ).runner.execute(:test)
        end.to raise_error(
          FastlaneCore::Interface::FastlaneError,
          "`site` parameter should be 'datadoghq.com' or 'datadoghq.eu'"
        )
      end

      it "uploads dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/')).shellescape

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with("npx @datadog/datadog-ci dsyms upload #{dsym_path} --dry-run")

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: true
            )
          end"
        ).runner.execute(:test)
      end

      it "uploads zip file containing dSYM files" do
        dsym_path = File.expand_path(File.join('./spec/fixtures/dSYM/Themoji.dSYM.zip')).shellescape

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with("npx @datadog/datadog-ci dsyms upload #{dsym_path} --dry-run")

        Fastlane::FastFile.new.parse(
          "lane :test do
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dsym_paths: '#{dsym_path}',
              dry_run: 'true'
            )
          end"
        ).runner.execute(:test)
      end

      it "uploads multiple folders" do
        dsym_paths = [
          File.expand_path(File.join('./spec/fixtures/dSYM1/')).shellescape,
          File.expand_path(File.join('./spec/fixtures/dSYM2/')).shellescape
        ]

        commands = dsym_paths.map do |path|
          "npx @datadog/datadog-ci dsyms upload #{path} --dry-run"
        end

        commands.each do |cmd|
          expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh).with(cmd)
        end

        Fastlane::FastFile.new.parse(
          "lane :test do
              upload_symbols_to_datadog(
                api_key: 'mock-api-key',
                dsym_paths: #{dsym_paths},
                dry_run: true
              )
          end"
        ).runner.execute(:test)
      end

      it "uses lane context to get dsym_path" do
        dsym_path = 'some-path'

        expect(Fastlane::Actions::UploadSymbolsToDatadogAction).to receive(:sh)
          .with("npx @datadog/datadog-ci dsyms upload #{dsym_path} --dry-run")

        Fastlane::FastFile.new.parse(
          "lane :test do
            Actions.lane_context[SharedValues::DSYM_PATHS] = ['#{dsym_path}']
            upload_symbols_to_datadog(
              api_key: 'mock-api-key',
              dry_run: 'true'
            )
          end"
        ).runner.execute(:test)
      end
    end
  end
end
