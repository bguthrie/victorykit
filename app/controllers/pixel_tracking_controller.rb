class PixelTrackingController < ApplicationController

  def new
    if email = SentEmail.find_by_hash(params[:n])
      begin
        email.update_attribute(:opened_at, Time.now) if email.opened_at.blank?
      rescue => error
        Rails.logger.error "Exception while trying to mark a sent email as opened: #{error}"
      end
    end
    send_file Rails.root.join("public","tracking_pixel.gif"), type: 'image/gif', disposition: "inline" 
  end
end
