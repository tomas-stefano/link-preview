module LinkPreview
  class ExternalFavicon < ExternalImage
    attr_reader :uri, :document, :favicon_element, :itemprop_element, :open_graph_element

    def initialize(uri, document)
      @uri      = uri
      @document = document

      super(uri, favicon_path.to_s)
    end

    def favicon_path
      find_value(open_graph_element) || favicon_element['href'] || find_value(itemprop_element)
    end

    def open_graph_element
      @open_graph_element ||= document.css("*[property~='og:image']").first
    end

    def favicon_element
      @favicon_element ||= document.css("*[rel~='icon']").first || {}
    end

    def itemprop_element
      @itemprop_element ||= document.css("*[itemprop~='image']").first
    end
  end
end