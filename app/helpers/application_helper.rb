# frozen_string_literal: true

module ApplicationHelper
  def make_this_a_list(options = {})
    list = +'<ul>'
    options[:value].each { |identifier| list << "<li>#{identifier}</li>" }
    list << '</ul>'
    list
  end
end
