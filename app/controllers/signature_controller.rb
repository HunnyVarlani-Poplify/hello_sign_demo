class SignatureController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_action :client, only: [:create]

  def create
    embedded_request = create_embedded_request(params[:name], params[:email])
    @sign_url = get_sign_url(embedded_request)
  end

  def check
    render json: 'Hello API Event Received', status: 200 
  end

  private

  def create_embedded_request(name, email)
    @client.create_embedded_signature_request(
      :test_mode => 1,
      :client_id => Rails.application.credentials.dig(:hello_sign, :client_id),
      :title => 'NDA with Acme Co.',
      :subject => 'The NDA we talked about',
      :message => 'Please sign this NDA and then we can discuss more. Let me know if you have any
      questions.',
      :signers => [
          {
              :email_address => email,
              :name => name
          }
      ],
    :files => [File.open('Hunny-Documents.pdf')]
    )
  end

  def get_sign_url(embedded_request)  
    sign_id = get_first_signature_id(embedded_request)  
    @client.get_embedded_sign_url(signature_id: sign_id).sign_url
  end 
  
  def get_first_signature_id(embedded_request)  
    embedded_request.signatures[0].signature_id 
  end 

  def client
    @client ||= HelloSign::Client.new(api_key: Rails.application.credentials.dig(:hello_sign, :api_key))
  end
end
