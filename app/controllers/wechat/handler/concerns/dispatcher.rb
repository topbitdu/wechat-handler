module Wechat::Handler::Concerns::Dispatcher

  extend ActiveSupport::Concern

  self.included do |includer|

    skip_before_filter :verify_authenticity_token

    def create

      signature         = params[:signature]
      timestamp         = params[:timestamp]
      nonce             = params[:nonce]
      encrypt_type      = params[:encrypt_type] # aes
      message_signature = params[:msg_signature]

      xml_text            = nil
      replying_encryption = 'raw'
      request_body        = request.body.read
      Rails.logger.warn '  >> The request.body is as the following:'
      Rails.logger.warn request_body

      if encrypt_type.blank? || 'raw'==encrypt_type

        xml_text = request_body

      elsif 'aes'==encrypt_type

        replying_encryption = 'aes'

        render status: :bad_request, text: 'sign_error' and return unless check_signature(signature, nonce, timestamp)
        encoded_message = Wechat::Callback::XmlDocument.load(request_body)['Encrypt']
        Rails.logger.info "The encoded_message is #{encoded_message.inspect}."
        render status: :bad_request, text: 'msg_sign_error' and return unless check_message_signature(message_signature, encoded_message, nonce, timestamp)

        message = Wechat::Callback::MessageDecryption.create encoded_message, Rails.application.secrets.wechat_encoding_aes_keys
        random_bytes, xml_size, xml_text, app_id, padding_bytes = Wechat::Callback::SecureMessage.load message
        Rails.logger.warn "  >> Wechat Callback >> Message Controller >> App ID of the Secure Message = #{app_id}."
        Rails.logger.warn '  >> Wechat Callback >> Message Controller >> XML Text of the Secure Message ='
        Rails.logger.warn xml_text
        render status: :bad_request, text: 'app_id_error' and return unless check_app_id(app_id)

      else

        render status: :bad_request, text: "Encrypt type #{encrypt_type} is not suppored"
        return

      end

      pairs = Wechat::Callback::XmlDocument.load xml_text
      replying_pairs = { 'ToUserName' => pairs['FromUserName'], 'FromUserName' => pairs['ToUserName'], 'CreateTime' => Time.now.to_i }

      if respond_to? :on_event
        replied_pairs  = on_event pairs
        replying_pairs = replying_pairs.merge! replied_pairs
      else
        Rails.logger.warn "The #{includer} does not have the #on_event method."
      end

      replying_xml_text = Wechat::Callback::XmlDocument.create replying_pairs

      if 'aes'==replying_encryption
        random_bytes       = Wechat::Callback::RandomByteArray.create 16
        plain_text         = Wechat::Callback::SecureMessage.create     random_bytes, replying_xml_text, wechat_app_id
        encrypted          = Wechat::Callback::MessageEncryption.create plain_text,   wechat_encoding_aes_keys
        replying_singature = Wechat::Callback::Signature.create         wechat_token, timestamp, nonce, encrypted
        encrypted_replying_pairs = {
            'Encrypt'      => encrypted,
            'MsgSignature' => replying_singature,
            'TimeStamp'    => timestamp,
            'Nonce'        => nonce
          }
        replying_xml_text = Wechat::Callback::XmlDocument.create encrypted_replying_pairs

        # debugging
        debugging_pairs = Wechat::Callback::XmlDocument.load replying_xml_text
        Rails.logger.warn '  >> Wechat Callback >> Message Controller >> Debugging Pairs ='
        Rails.logger.warn debugging_pairs.inspect
        debugging_encrypted_message = debugging_pairs['Encrypt']
        debugging_decrypted_message = Wechat::Callback::MessageDecryption.create debugging_encrypted_message, wechat_encoding_aes_keys
        Rails.logger.warn '  >> Wechat Callback >> Message Controller >> Debugging Decrypted Message ='
        Rails.logger.warn debugging_decrypted_message
        debugging_random_bytes, debugging_xml_size, debugging_xml_text, debugging_app_id, debugging_padding_bytes = Wechat::Callback::SecureMessage.load debugging_decrypted_message
        Rails.logger.warn "  >> Wechat Callback >> Message Controller >> Debugging App ID of the Secure Message = #{debugging_app_id}."
        Rails.logger.warn '  >> Wechat Callback >> Message Controller >> Debugging XML Text of the Secure Message ='
        Rails.logger.warn debugging_xml_text

      end
      Rails.logger.warn '  >> The Replying XML Text is as the following:'
      Rails.logger.warn replying_xml_text

      render status: :created, xml: replying_xml_text

    end

    def check_parameter(name, value)
      if value.blank?
        Rails.logger.warn "The #{name} parameter is blank. Failed to validate URL by Wechat."
        render text: ''
      end
      value.present?
    end

    def check_signature(signature, nonce, timestamp)
      actual  = ::Wechat::Callback::Signature.create wechat_token, timestamp, nonce
      matched = signature==actual
      Rails.logger.warn "Actual signature is #{actual}, which does not equal to the given signature #{signature}." unless matched
      matched
    end

    def check_message_signature(message_signature, encoded_message, nonce, timestamp)
      actual  = ::Wechat::Callback::MessageSignature.create encoded_message, wechat_token, timestamp, nonce
      matched = message_signature==actual
      Rails.logger.warn "Actual message signature is #{actual}, which does not equal to the given message signature #{message_signature}." unless matched
      matched
    end

    def check_app_id(app_id)
      matched = wechat_app_id==app_id
      Rails.logger.warn "Actual App ID is #{wechat_app_id}, which does not equal to the given App ID #{app_id}." unless matched
      matched
    end

    def wechat_token
      @token = @token||Rails.application.secrets.wechat_validation_token
      Rails.logger.warn 'Please configure "wechat_validation_token" in the /config/secrets.yml file. Failed to validate URL by Wechat.' if @token.blank?
      @token
    end

    def wechat_app_id
      @app_id = @app_id||Rails.application.secrets.wechat_app_id
      Rails.logger.warn 'Please configure "wechat_app_id" in the /config/secrets.yml file. Failed to validate URL by Wechat.' if @app_id.blank?
      @app_id
    end

    def wechat_encoding_aes_keys
      @encoding_aes_keys = @encoding_aes_keys||Rails.application.secrets.wechat_encoding_aes_keys
      Rails.logger.warn 'Please configure "encoding_aes_keys" in the /config/secrets.yml file. Failed to validate URL by Wechat.' if @encoding_aes_keys.blank?
      @encoding_aes_keys
    end

    private :check_parameter, :check_signature, :wechat_token

  end

end
