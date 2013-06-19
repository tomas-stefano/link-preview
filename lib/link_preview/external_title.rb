module LinkPreview
  class ExternalTitle < ExternalResource
    def initialize(document)
      @document = document

      super(text)
    end

    def text
      find_value(@document.css("*[property~='og:title']").first) || @document.css('title').text
    end
  end
end