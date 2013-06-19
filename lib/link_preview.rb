require 'link_preview/version'
require 'httparty'
require 'nokogiri'
require 'active_support/core_ext/object'

module LinkPreview
  autoload :ExternalDescription, 'link_preview/external_description'
  autoload :ExternalFavicon,     'link_preview/external_favicon'
  autoload :ExternalImage,       'link_preview/external_image'
  autoload :ExternalResource,    'link_preview/external_resource'
  autoload :ExternalTitle,       'link_preview/external_title'
  autoload :Parser,              'link_preview/parser'
  autoload :Page,                'link_preview/page'
end
