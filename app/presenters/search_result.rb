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

  def self.details_accessor(*keys)
    keys.each do |key|
      define_method key do
        @result['details'][key.to_s]
      end
    end
  end

  result_accessor :title, :es_score
  details_accessor :slug, :format, :description

end
