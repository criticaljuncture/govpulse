class CalendarsController < ApplicationController
  caches_page :index
  
  def index
    @year  = params[:year].to_i  || Time.now.strftime("%Y")
    @month = params[:month].to_i || Time.now.strftime("%m")
    @day   = params[:day]
    
    if @day.nil?
      date_range = [Date.new(@year, @month, 1), Date.new(@year, @month, -1)]
      @referenced_dates = ReferencedDate.find(:all, :include => {:entry => :agency}, :conditions => {:date => date_range[0]..date_range[1]}, :order => 'date ASC' )
    else                                                  
      @referenced_dates = ReferencedDate.find(:all, :include => {:entry => :agency}, :conditions => ['date = ?', Date.new(@year, @month, @day.to_i)], :order => 'date ASC' )
    end
    
    @publication_date = Date.parse("#{@year}-#{@month}-01")
    
    @prev_date = ReferencedDate.find(:first,
        :select => 'date',
        :conditions => ["date < ?", @publication_date],
        :order => 'date DESC'
    ).try(:date)
    
    @next_date = ReferencedDate.find(:first,
        :select => 'date',
        :conditions => ["date > ?", @publication_date + 1.month],
        :order => 'date'
    ).try(:date)
    
    @entries = @referenced_dates.map{|rf| rf.entry}#.uniq
    
    agencies_and_entry_counts = []
    @entries.group_by(&:agency_id).each do |agency_id, entries|
      next if agency_id.blank?
      agencies_and_entry_counts << [Agency.find(agency_id), entries.size]
    end
    
    @agency_labels = []
    @agency_values = []
    agencies_and_entry_counts.sort_by{|a| a[1]}.reverse[0,10].each do |agency, count|
      @agency_labels << "#{agency.sidebar_name}"
      @agency_values << count
    end
    
    if @agency_values.sum < @entries.size
      count = (@entries.size - @agency_values.sum)
      @agency_labels << "Other"
      @agency_values << count
    end
    
    @entry_type_labels = []
    @entry_type_values = []
    @entries.uniq.group_by(&:entry_type).each do |entry_type, entries|
      @entry_type_labels << entry_type
      @entry_type_values << entries.size
    end
    
  end
  
end
