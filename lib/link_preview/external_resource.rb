module LinkPreview
  class ExternalResource < String
    def find_value(element)
      element.attributes['content'] if element.present?
    end
  end
end