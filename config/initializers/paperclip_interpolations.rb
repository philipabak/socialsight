module Paperclip
  module Interpolations
    def message_id attachment, style_name
      raise "It's not a message attachment" unless attachment.instance.is_a?(Message)
      attachment.instance.id
    end

    def message_thread_id attachment, style_name
      raise "It's not a message attachment" unless attachment.instance.is_a?(Message)
      attachment.instance.message_thread_id
    end
  end
end