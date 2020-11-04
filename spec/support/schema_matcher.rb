# Useful to quickly test if return json is structured as expected

RSpec::Matchers.define :match_response_schema do |schema|
  match do |body|
    schema_directory = "#{Dir.pwd}/spec/support/api/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, body, strict: true)
  end
end