module LinkPreview
  class Parser < Hash
    attr_reader :document, :title, :images, :uri

    def initialize(uri)
      @uri = uri

      super()
    end

    # Parse title, favicon and images from an external page.
    #
    def parse!
      merge!(link: @uri, title: title, favicon: favicon, images: images, type: type, description: description)
    rescue StandardError => exception
      merge!(error: exception.message)
    end

    # @return [True, False] return false if self contain error node. True otherwise.
    #
    def valid?
      self[:error].blank?
    end

    # Return the title from HTML document.
    #
    # @return [String]
    #
    def title
      LinkPreview::ExternalTitle.new(document)
    end

    # Return the description from HTML document.
    #
    # @return [String]
    #
    def description
      LinkPreview::ExternalDescription.new(document)
    end

    # For now all links are considering external.
    # In the future this could be: external, youtube, images.
    #
    def type
      'external'
    end

    # Return the absolute path from a favicon element.
    #
    # @return [String]
    #
    def favicon
      @favicon ||= LinkPreview::ExternalFavicon.new(uri, document)
    end

    # Return all images from the page.
    #
    # @return [Array]
    #
    def images
      @images ||= LinkPreview::ExternalImage.parse(uri, document).unshift(favicon).reject(&:blank?)
    end

    # Convenience method to be used in the active model serializers.
    #
    def read_attribute_for_serialization(attribute)
      self[attribute.to_sym]
    end

    private

    def document
      @document ||= Nokogiri::HTML(HTTParty.get(@uri))
    end
  end
end
