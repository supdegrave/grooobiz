module ApplicationHelper
    def log(*messages)
        msg_array = []
        msg_array.push ''
        msg_array.push '-----------------------------------'
        messages.each { |message| 
            msg_array.push message 
            msg_array.push '-----------------------------------'
        }
        msg_array.push 'logged from ApplicationHelper'
        msg_array.push '-----------------------------------'
        
        msg_array.each do |msg| 
            logger.info msg 
        end
        
        javascript_tag "console.log('" + msg_array.join('\n') + "');"
    end
end
