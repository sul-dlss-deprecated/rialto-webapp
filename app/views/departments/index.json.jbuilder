# frozen_string_literal: true

json.array! @departments do |deparment|
  json.id deparment.id
  json.label deparment.name
end
