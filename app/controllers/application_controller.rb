class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
    end

    def log(*messages)
        logger.info ''
        logger.info '***********************************'
        messages.each { |message| 
            logger.info message 
            logger.info '***********************************'
        }
        logger.info '' 
    end
end
