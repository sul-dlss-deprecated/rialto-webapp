# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document

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

  # Turns URI text into an HTML anchor
  def linked_dois
    dois = fetch('doi_ssim', [])
    return '' if dois.empty?
    dois.map do |doi|
      "<a href=\"#{doi}\">#{doi}</a>"
    end.to_sentence.html_safe
  end

  # Produces a list of authors with links to the frontend app for each.
  def linked_authors
    linked_fields(label: 'author_labels_tsim', uri: 'authors_ssim')
  end

  # Produces a list of PIs with links to the frontend app for each.
  def linked_pi
    linked_fields(label: 'pi_label_tsim', uri: 'pi_ssim')
  end

  # Produces a list of PIs with links to the frontend app for each.
  def linked_assigned
    linked_fields(label: 'assigned_label_tsim', uri: 'assigned_ssim')
  end

  private

  def linked_fields(label:, uri:)
    tuples = fetch(label, []).zip(fetch(uri, []))
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
