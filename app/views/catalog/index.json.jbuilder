# frozen_string_literal: true

# This file exists as a port of https://github.com/projectblacklight/blacklight/pull/1941
# and can be removed once that is merged
json.links do
  json.self url_for(search_state.to_h.merge(only_path: false))
  json.prev url_for(search_state.to_h.merge(only_path: false, page: @response.prev_page.to_s)) if @response.prev_page
  json.next url_for(search_state.to_h.merge(only_path: false, page: @response.next_page.to_s)) if @response.next_page
  json.last url_for(search_state.to_h.merge(only_path: false, page: @response.total_pages.to_s))
end

json.meta do
  json.pages @presenter.pagination_info
end

json.data do
  json.array! @presenter.documents do |document|
    document_url = polymorphic_url(url_for_document(document))
    json.id document.id
    json.attributes do
      doc_presenter = index_presenter(document)

      index_fields(document).each do |field_name, field|
        next unless should_render_index_field? document, field
        json.set!(field_name) do
          json.id "#{document_url}##{field_name}"
          json.type 'document_value'
          json.attributes do
            json.value doc_presenter.field_value(field_name)
            json.label field.label
          end
        end
      end
    end

    json.links do
      json.self document_url
    end
  end
end

json.included do
  json.array! @presenter.search_facets_as_json do |facet|
    json.type 'facet'
    json.id facet['name']
    json.attributes do
      json.label facet['label']
      json.items do
        json.array! facet['items'] do |item|
          json.id
          json.attributes do
            json.label item['label']
            json.value item['value']
            json.hits item['hits']
          end
          json.links do
            json.self path_for_facet(facet['name'], item['value'], only_path: false)
          end
        end
      end
    end
    json.links do
      json.self search_facet_path(id: facet['name'], only_path: false)
    end
  end

  json.array! search_fields do |(label, key)|
    json.type 'search_field'
    json.id key
    json.attributes do
      json.label label
    end
    json.links do
      json.self url_for(search_state.to_h.merge(search_field: key, only_path: false))
    end
  end

  json.array! active_sort_fields do |key, field|
    json.type 'sort'
    json.id key
    json.attributes do
      json.label field.label
    end
    json.links do
      json.self url_for(search_state.to_h.merge(sort: key, only_path: false))
    end
  end
end
