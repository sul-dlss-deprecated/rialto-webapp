# frozen_string_literal: true

json.array! @schools do |school|
  json.uri school.uri
  json.label school.name
end
