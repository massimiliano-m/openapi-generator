require "./spec_helper"

Spectator.describe Petstore::ApiClient do
  describe "#update_params_for_auth!" do
    describe "oauth2" do
      it "should add 'Authorization' to header" do
        config = Petstore::Configuration.new
        config.access_token = "xxx"

        header_params = {} of String => String
        query_params = {} of String => String
        cookie_params = {} of String => String

        api_client = Petstore::ApiClient.new(config)
        api_client.update_params_for_auth!(header_params, query_params, cookie_params, ["petstore_auth"])

        expect(header_params["Authorization"]).to eq "Bearer xxx"
        expect(query_params.size).to eq 0
      end
    end

    describe "api_key" do
      context "without api_key_prefix" do
        it "should add 'api_key' to header" do
          config = Petstore::Configuration.new
          config.api_key[:api_key] = "xxx"

          header_params = {} of String => String
          query_params = {} of String => String
          cookie_params = {} of String => String

          api_client = Petstore::ApiClient.new(config)
          api_client.update_params_for_auth!(header_params, query_params, cookie_params, ["api_key"])

          expect(header_params["api_key"]).to eq "xxx"
          expect(query_params.empty?).to be_true
        end
      end

      context "with api_key_prefix" do
        it "should add 'api_key' to header" do
          config = Petstore::Configuration.new
          config.api_key[:api_key] = "xxx"
          config.api_key_prefix[:api_key] = "Token"

          header_params = {} of String => String
          query_params = {} of String => String
          cookie_params = {} of String => String

          api_client = Petstore::ApiClient.new(config)
          api_client.update_params_for_auth!(header_params, query_params, cookie_params, ["api_key"])

          expect(header_params["api_key"]).to eq "Token xxx"
          expect(query_params.empty?).to be_true
        end
      end
    end
  end
end
