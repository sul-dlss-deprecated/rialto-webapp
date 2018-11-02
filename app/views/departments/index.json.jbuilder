# frozen_string_literal: true

json.array! @departments do |department|
  json.uri department.uri
  json.label department.name
end
