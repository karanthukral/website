class Interest < ActiveRecord::Base
  acts_as_taggable
  attr_accessor :interest_type_hash, :doc_id

  has_many :images, as: :owner
  accepts_nested_attributes_for :images

  def initialize(attributes = {}, options = {})
    super(attributes, options)
    initialize_with_attributes(attributes) if attributes.present?
  end

  def screencap_link
    self.images.first.try(:url)
  end

  def take_screencap!
    Image.capture_screenshot(url, self) unless Rails.env.test?
  end

  def embed?
    Interest.interest_types.find { |d| d["name"] == self.provider }.try(:[], "embeddable")
  end

  def document_profile(url)
    hashes = Interest.interest_types.keep_if do |interest_type| 
      interest_type["supported_schemas"].any? do |schema| 
        if url =~ /#{escape(schema)}/
          matches = /#{escape(schema)}/.match(url)
          self.doc_id = matches[matches.size - 1]
          true
        end
      end
    end
    hashes.first
  end

  def self.supported_types
    interest_types.collect { |interest_type| interest_type["name"] }
  end

private

  def initialize_with_attributes(attributes)
    self.interest_type_hash = document_profile(attributes[:url]) || { "url" => url, "treatment" => "link", "type" => "website" }
    self.doc_id = url if self.doc_id.blank?
    self.url = url
    self.treatment = self.interest_type_hash["treatment"]
    self.interest_type = self.interest_type_hash["type"]
    self.provider = self.interest_type_hash["name"]
    self.embed_url = self.interest_type_hash["url"] % { :id => self.doc_id } if self.interest_type_hash["url"]
    set_title_from_url(url)
    self.take_screencap! unless embed?
  end

  def set_title_from_url(url)
    m = Mechanize.new
    m.user_agent_alias = "Mac Safari"
    self.title = m.get(url).title.gsub(/- #{self.provider}/i, '')
  end

  def escape(url)
    regex = Regexp.escape(url)
    regex.gsub!(/\\\*/,"(.*)")
    regex.gsub!(/http:/, "(https|http):")
    regex
  end

  def self.interest_types
    file_path = Rails.root.join('config', 'supported_documents.yml')
    YAML.load_file(file_path)["interest_types"]
  end
end