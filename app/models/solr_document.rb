# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document

  DOI_HTTP_PREFIX = 'https://doi.org/'

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  attribute :title, Blacklight::Types::String, 'title_tesi'

  # Turns URI text into an HTML anchor
  def linked_dois
    dois = fetch('doi_ssim', [])
    return '' if dois.empty?
    dois.map do |doi|
      "<a href=\"#{doi}\">#{doi.remove(DOI_HTTP_PREFIX)}</a>"
    end.to_sentence.html_safe
  end

  # Produces a list of authors with links to the frontend app for each.
  def linked_authors
    linked_fields(label: 'author_labels_tsim', uri: 'authors_ssim')
  end

  # Produces a list of Grants with links to the frontend app for each.
  def linked_grants
    linked_fields(label: 'grant_labels_ssim', uri: 'grants_ssim')
  end

  # Produces a list of PIs with links to the frontend app for each.
  def linked_pi
    linked_fields(label: 'pi_label_tsim', uri: 'pi_ssim')
  end

  # Produces a list of PIs with links to the frontend app for each.
  def linked_assigned
    linked_fields(label: 'assigned_label_tsim', uri: 'assigned_ssim')
  end

  # A list of publications for this person
  def person_publications
    linked_publications(author: id)
  end

  # A list of publications for this person
  def grant_publications
    linked_publications(grant: id)
  end

  private

  delegate :blacklight_config, to: CatalogController

  # A list of publications for this person
  def linked_publications(params)
    search_service = Blacklight::SearchService.new(config: blacklight_config,
                                                   user_params: params,
                                                   search_builder_class: PublicationSearchBuilder)
    response, _deprecated_stuff = search_service.search_results
    docs = response.documents
    tuples = docs.map do |doc|
      "<li><a href=\"#{search_link(doc.id)}\">#{doc.title}</a></li>"
    end
    "<ul>#{tuples.join}</ul>".html_safe
  end

  def linked_fields(label:, uri:)
    tuples = fetch(label, []).zip(fetch(uri, []))
    linked_fields_to_links(tuples)
  end

  def linked_fields_to_links(tuples)
    parts = tuples.map do |labeled|
      "<a href=\"#{search_link(labeled.last)}\">#{labeled.first}</a>"
    end
    parts.to_sentence.html_safe
  end

  # Create a link to the VueJS path for showing all the documents with this author
  # @param String the uri for the author
  def search_link(uri)
    "/#/item/#{CGI.escape(uri)}"
  end
end
