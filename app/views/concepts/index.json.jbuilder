# frozen_string_literal: true

json.array! @concepts do |concept|
  json.uri concept.uri
  json.label concept.name
end
