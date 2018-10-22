# frozen_string_literal: true

json.array! @departments do |deparment|
  json.uri deparment.uri
  json.label deparment.name
end
