module LinkPreview
  class ExternalDescription < ExternalResource
    attr_reader :document

    def initialize(document)
      @document = document

      super(text.to_s)
    end

    def text
      open_graph_description || meta_description
    end

    def open_graph_description
      find_value(document.css("*[property~='og:description']").first)
    end

    def meta_description
      find_value(document.css("*[name~='description']").first)
    end
  end
end