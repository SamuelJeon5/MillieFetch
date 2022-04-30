class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end

  def new
    @upload= Upload.new
  end
  

  def create
    @upload= Upload.new(upload_params)
    Folder.new(:folder_title=> @upload.folder_title).save
    Metadatum.new(:FOIA_ID=> @upload.FOIA_ID,:local_id=> @upload.local_id,:status=> @upload.status,:record_collection=> @upload.record_collection,:office_origin=> @upload.office_origin,:series=> @upload.series,:subseries=> @upload.subseries,:box_type=> @upload.box_type,:box_number=> @upload.box_number,:note_field=> @upload.note_field,:folder_id=> Folder.maximum(:id)).save
    Content.new(:content_path=> @upload.attachment ,:metadatum_id=>Metadatum.maximum(:id),:folder_id=>Folder.maximum(:id)).save
    if @upload.save
      redirect_to uploads_path, notice: " The file #{@upload.FOIA_ID} is successfully uploaded."
    else
      render "new"
    end
  end
  
  

  def destroy
    @upload = Upload.find(params[:id])
    
    @upload.destroy
    redirect_to uploads_path, notice: "The file #{@upload.FOIA_ID} is successfully deleted!"
  end
  private   
    def upload_params   
    params.require(:upload).permit(:FOIA_ID,:folder_title,:local_id,:status,:record_collection,:office_origin,:series,:subseries,:box_type,:box_number,:note_field,:attachment)   
  end 
end




