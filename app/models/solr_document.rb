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

  # Produces a list of authors with links to the frontend app for each.
  def linked_authors
    tuples = fetch('author_labels_tsim', []).zip(fetch('authors_ssim', []))
    parts = tuples.map do |author|
      "<a href=\"#{search_link(author.last)}\">#{author.first}</a>"
    end
    parts.to_sentence.html_safe
  end

  # Create a link to the VueJS path for showing all the documents with this author
  # @param String the uri for the author
  def search_link(author_uri)
    "/#/catalog/#{CGI.escape(author_uri)}"
  end
end
