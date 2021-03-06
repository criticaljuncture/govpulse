=begin Schema Information

 Table name: entries

  id                           :integer(4)      not null, primary key
  title                        :text
  abstract                     :text
  contact                      :text
  dates                        :text
  action                       :text
  type                         :string(255)
  link                         :string(255)
  genre                        :string(255)
  part_name                    :string(255)
  citation                     :string(255)
  granule_class                :string(255)
  document_number              :string(255)
  toc_subject                  :string(255)
  toc_doc                      :string(255)
  length                       :integer(4)
  start_page                   :integer(4)
  end_page                     :integer(4)
  agency_id                    :integer(4)
  publication_date             :date
  places_determined_at         :datetime
  created_at                   :datetime
  updated_at                   :datetime
  slug                         :text
  delta                        :boolean(1)      default(TRUE), not null
  source_text_url              :string(255)
  primary_agency_raw           :string(255)
  secondary_agency_raw         :string(255)
  volume                       :integer(4)
  regulationsdotgov_id         :string(255)
  comment_url                  :string(255)
  checked_regulationsdotgov_at :datetime
  full_xml_added_at            :datetime
  regulation_id_number         :string(255)

=end Schema Information

class Entry < ActiveRecord::Base
  
  DESCRIPTIONS = {
    :notice => 'This section of the Federal Register contains documents other than rules 
                or proposed rules that are applicable to the public. Notices of hearings 
                and investigations, committee meetings, agency decisions and rulings, 
                delegations of authority, filing of petitions and applications and agency 
                statements of organization and functions are examples of documents 
                appearing in this section.'
  }
  
  ENTRY_TYPES = {
    'RULE'     => 'Rule', 
    'PRORULE'  => 'Proposed Rule', 
    'NOTICE'   => 'Notice', 
    'PRESDOCU' => 'Presidential Document', 
    'CORRECT'  => 'Correction',
    'UNKNOWN'  => 'Unknown'
  }
  
  belongs_to :agency
  
  has_many :topic_assignments, :dependent => :destroy
  has_many :topics, :through => :topic_assignments, :conditions => "topics.group_name != ''", :order => 'topics.name'
  
  has_many :url_references, :dependent => :destroy
  has_many :urls, :through => :url_references
  
  has_many :place_determinations,
           :conditions => "place_determinations.confidence >= #{PlaceDetermination::MIN_CONFIDENCE}",
           :dependent => :destroy
  has_many :places, :through => :place_determinations
  
  has_many :citations,
           :foreign_key => :source_entry_id,
           :dependent => :destroy
  has_many :cited_entries,
           :class_name => 'Entry',
           :through => :citations,
           :source => :cited_entry
  
  has_many :references,
           :class_name => 'Citation',
           :foreign_key => :cited_entry_id,
           :dependent => :nullify
  has_many :referencing_entries,
           :class_name => 'Entry',
           :through => :references,
           :source => :source_entry
  has_many :graphic_usages
  has_many :graphics,
           :through => :graphic_usages
  
  acts_as_mappable :through => :places
  
  has_many :referenced_dates, :dependent => :destroy
  has_one :comments_close_date, :class_name => "ReferencedDate", :conditions => {:date_type => 'CommentDate'}
  has_one :effective_date, :class_name => "ReferencedDate", :conditions => {:date_type => 'EffectiveDate'}
  
  before_save :set_document_file_path
  
  file_attribute(:full_xml)  {"#{RAILS_ROOT}/data/xml/#{document_file_path}.xml"}
  file_attribute(:full_text) {"#{RAILS_ROOT}/data/text/#{document_file_path}.txt"}
  
  def entry_type 
    ENTRY_TYPES[granule_class]
  end
  
  define_index do
    # fields
    indexes title
    indexes abstract
    indexes "LOAD_FILE(CONCAT('#{RAILS_ROOT}/data/text/', document_file_path, '.txt'))", :as => :full_text
    indexes agency.name, :as => :agency_name
    indexes granule_class, :facet => true
    
    # attributes
    has topics(:id), :as => :topic_ids, :facet => true
    has places(:id), :as => :place_ids
    
    has agency_id, :facet => true
    has publication_date
    
    set_property :field_weights => {
      "title" => 100,
      "abstract" => 50,
      "full_text" => 25,
      "agency_name" => 10
    }
  end
  
  def month_year
    publication_date.to_formatted_s(:month_year)
  end
  
  def day
    publication_date.strftime('%d')
  end

  def active
    response_code == '200' ? true : false
  end
  
  def human_length
    if length.blank? 
      end_page - start_page + 1
    else
      length
    end
  end
  
  def slug
    self.title.downcase.gsub(/&/, 'and').gsub(/[^a-z0-9]+/, '-').slice(0,100)
  end
  
  def agency_parent_id
    agency.try(:parent_id).nil? ? agency_id : agency.parent_id
  end
  
  def comments_close_on
    comments_close_date.try(:date)
  end
  
  def effective_on
    effective_date.try(:date)
  end
  
  def source_url(format)
    format = format.to_sym
    
    case format
    when :html
      base_url = "http://www.gpo.gov/fdsys/granule/FR-#{publication_date.to_s(:db)}/#{document_number}"
    when :text
      base_url = "http://www.gpo.gov/fdsys/pkg/FR-#{publication_date.to_s(:db)}/html/#{document_number}.htm"
    when :pdf
      base_url =  "http://www.gpo.gov/fdsys/pkg/FR-#{publication_date.to_s(:db)}/pdf/#{document_number}.pdf"
    end
  end
  
  def entries_within(distance, options={})
    limit = options.delete(:limit) || 10
    count = options.delete(:count) || false
    
    if count
      entry_count = 0
      places.each do |place|
        entry_count = entry_count + Entry.count_within(distance, :origin => place.location)
      end
      entry_count
    else
      entries = []
      places.each do |place|
        entries += Entry.find_within(distance, :origin => place.location, :limit => limit, :order => 'distance')
      end
      entries.uniq.sort_by{|e| e.publication_date}[0..9].flatten
    end
  end
  
  def self.find_near(loc, dist = 100)
    places  = Place.find_places_near(loc, dist)
    entries = []
    places.each do |place|
      entries << place.entry
    end
    entries
  end
  
  def self.latest_publication_date
    find(:first, :select => "publication_date", :order => "publication_date DESC").publication_date
  end
  
  def self.find_all_by_citation(volume, page)
    all(:conditions => ["volume = ? AND start_page <= ? AND end_page >= ?", volume.to_i, page.to_i, page.to_i], :order => "entries.end_page")
  end
  
  def self.first_publication_date_before(date)
    Entry.find(:first,
        :select => 'publication_date',
        :conditions => ["publication_date < ?", date],
        :order => 'publication_date DESC'
    ).try(:publication_date)
  end
  
  def self.first_publication_date_after(date)
    Entry.find(:first,
        :select => 'publication_date',
        :conditions => ["publication_date > ?", date],
        :order => 'publication_date'
    ).try(:publication_date)
  end

  def has_type?
    entry_type != 'Unknown'
  end
  
  private
  
  def set_document_file_path
    self.document_file_path = document_number.sub(/-/,'').scan(/.{0,3}/).reject(&:blank?).join('/') if document_number.present?
  end
end
