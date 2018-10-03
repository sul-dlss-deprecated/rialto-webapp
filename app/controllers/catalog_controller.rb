# frozen_string_literal: true

class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10,
      qf: %(title_tesi name_tsim author_label_tsim abstract_tesim)
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'
    # config.document_solr_path = 'get'

    # items to show per page, each number in the array represent another option to choose from.
    # config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = 'name_tsim'
    config.index.display_type_field = 'type_ssi'

    # config.index.thumbnail_field = 'thumbnail_path_ss'

    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)
    config.add_show_tools_partial(:citation)

    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # solr field configuration for document/show views
    # config.show.title_field = 'title_tsim'
    config.show.display_type_field = 'type_ssi'
    # config.show.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field 'type_ssi', label: 'Type'
    config.add_facet_field 'pub_year_ssim', label: 'Publication Year', single: true
    config.add_facet_field 'subject_label_ssim', label: 'Topic', limit: 20, index_range: 'A'..'Z'
    config.add_facet_field 'institute_ssim', label: 'Institute', limit: true
    config.add_facet_field 'department_label_ssim', label: 'Department'
    config.add_facet_field 'school_label_ssim', label: 'School'
    config.add_facet_field 'subdivision_ssim', label: 'Subdivision'
    config.add_facet_field 'division_ssim', label: 'Division'
    config.add_facet_field 'institution_label_ssim', label: 'University'
    config.add_facet_field 'agent_ssim', label: 'Agent'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'abstract_tesim', label: 'Abstract'
    config.add_index_field 'author_label_tsim', label: 'Author'
    config.add_index_field 'profiles_tesim', label: 'Profiles'
    config.add_index_field 'cites_ssim', label: 'Cites'
    config.add_index_field 'date_created_dtsi', label: 'Created'
    config.add_index_field 'description_tesim', label: 'Description'
    config.add_index_field 'doi_ssim', label: 'DOI'
    config.add_index_field 'editor_label_tsim', label: 'Editor'
    config.add_index_field 'identifier_ssim', label: 'Identifier'
    config.add_index_field 'funded_by_ssim', label: 'Funded By'
    config.add_index_field 'has_instrument_ssim', label: 'Has Instrument'
    config.add_index_field 'journal_issue_ssim', label: 'Journal Issue'
    config.add_index_field 'link_ssim', label: 'Link'
    config.add_index_field 'publisher_label_tsim', label: 'Publisher'
    config.add_index_field 'same_as_ssim', label: 'Same As'
    config.add_index_field 'sponsor_label_tsim', label: 'Sponsor'
    config.add_index_field 'subject_label_tsim', label: 'Subject'
    config.add_index_field 'title_tesi', label: 'Title'
    config.add_index_field 'alternative_title_tesim', label: 'Alternate Title'

    config.for_display_type 'Person' do
      config.add_index_field 'name_tsim', label: 'Name'
      config.add_index_field 'department_label_ssim', label: 'Department'
      config.add_index_field 'school_label_ssim', label: 'School'
      config.add_index_field 'institution_label_ssim', label: 'University'
    end

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'abstract_tesim', label: 'Abstract'
    config.add_show_field 'author_label_tsim', label: 'Author'
    config.add_show_field 'profiles_tesim', label: 'Profiles'
    config.add_show_field 'cites_ssim', label: 'Cites'
    config.add_show_field 'date_created_dtsi', label: 'Created'
    config.add_show_field 'description_tesim', label: 'Description'
    config.add_show_field 'doi_ssim', label: 'DOI'
    config.add_show_field 'editor_label_tsim', label: 'Editor'
    config.add_show_field 'identifier_ssim', label: 'Identifier'
    config.add_show_field 'funded_by_ssim', label: 'Funded By'
    config.add_show_field 'has_instrument_ssim', label: 'Has Instrument'
    config.add_show_field 'journal_issue_ssim', label: 'Journal Issue'
    config.add_show_field 'link_ssim', label: 'Link'
    config.add_show_field 'publisher_label_tsim', label: 'Publisher'
    config.add_show_field 'same_as_ssim', label: 'Same As'
    config.add_show_field 'sponsor_label_tsim', label: 'Sponsor'
    config.add_show_field 'subject_label_tsim', label: 'Subject'
    config.add_show_field 'title_tesi', label: 'Title'
    config.add_show_field 'alternative_title_tesim', label: 'Alternate Title'
    config.for_display_type 'Person' do
      config.add_show_field 'name_tsim', label: 'Name'
      config.add_show_field 'department_label_ssim', label: 'Department'
      config.add_show_field 'school_label_ssim', label: 'School'
      config.add_show_field 'institution_label_ssim', label: 'University'
    end

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = {
        'spellcheck.dictionary': 'title',
        qf: 'title_tesi',
        pf: 'title_tesi'
      }
    end

    config.add_search_field('author') do |field|
      field.solr_parameters = {
        'spellcheck.dictionary': 'author',
        qf: '${author_qf}',
        pf: '${author_pf}'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.qt = 'search'
      field.solr_parameters = {
        'spellcheck.dictionary': 'subject',
        qf: '${subject_qf}',
        pf: '${subject_pf}'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_si desc, title_si asc', label: 'relevance'
    config.add_sort_field 'pub_date_si desc, title_si asc', label: 'year'
    config.add_sort_field 'author_si asc, title_si asc', label: 'author'
    config.add_sort_field 'title_si asc, pub_date_si desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end
end
