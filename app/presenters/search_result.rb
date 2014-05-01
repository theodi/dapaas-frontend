class SearchResult

  def initialize(result)
    @result = result.stringify_keys!
  end

  def self.result_accessor(*keys)
    keys.each do |key|
      define_method key do
        @result[key.to_s]
      end
    end
  end

  result_accessor :link, :title, :description, :format, :es_score

end
