module APIHelpers
  def json_body
    JSON.parse(response.body)
  end
end

RSpec::Matchers.define :have_json_attributes_and_values do |expected|
  match do |actual|
    matches = true
    expected.each do |key, value|
      case value
      when Regexp
        matches = actual.has_key?(key.to_s) && actual[key.to_s].match(value)
      else
        matches = actual.has_key?(key.to_s) && actual[key.to_s] == value
      end
      break unless matches
    end

    matches
  end
end
