module LinkPreview
  class ExternalImage < ExternalResource
    attr_reader :image_path

    def self.parse(uri, document)
      document.css("img").collect { |image|
        self.new(uri, image.attributes['src'].value) if image.attributes['src'].present?
      }
    end

    def initialize(uri, image_path)
      @uri        = uri
      @image_path = image_path

      super(path)
    end

    def path
      return '' if image_path.blank?

      if URI.regexp !~ image_path
        "#{File.join(@uri, image_path)}"
      else
        image_path
      end
    end
  end
end