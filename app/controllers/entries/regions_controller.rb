class Entries::RegionsController < ApplicationController
  def index
    @entry = Entry.find_by_document_number!(params[:document_number])
    extractor = RegionExtractor.new(@entry.full_xml)
    @regions = extractor.regions
    
    raise ActiveRecord::RecordNotFound if @regions.empty?
    
    respond_to do |wants|
      wants.html do
      end
      
      wants.kml do
      end
    end
  end
  
  def show
    @entry = Entry.find_by_document_number!(params[:document_number])
    @i = params[:id].to_i
    extractor = RegionExtractor.new(@entry.full_xml)
    regions = extractor.regions
    @region = regions[@i - 1]
    raise ActiveRecord::RecordNotFound unless @region
    
    respond_to do |wants|
      wants.html do
      end
      
      wants.kml do
      end
    end
  end
end