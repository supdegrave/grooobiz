module Log
    include ActiveSupport::Logger
    
    def self.log(*messages)
        logger.info ''
        logger.info '***********************************'
        messages.each { |message| 
            logger.info message 
            logger.info '***********************************'
        }
        logger.info '' 
    end
end