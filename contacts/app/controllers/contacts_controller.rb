class ContactsController < ApplicationController
  def index
    render json: Contact.where(:user_id => params[:user_id])
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      render json: @contact
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity

    end
  end

    def show
      @contact = Contact.find(params[:id])
      render json: @contact
    end

    def update
      @contact = Contact.find(params[:id])

      if @contact.update(contact_params)
        render json: @contact
      else
        render json: @contact.errors.full_messages, status: :unprocessable_entity
      end
    end

    def destroy
      @contact = Contact.find(params[:id])
      @contact.destroy
      render json: "#{@contact.name} deleted!"
    end

    def favorite
      @contact = Contact.find(params[:id])
      @contact.toggle!(:favorite)
      render json: @contact
    end

    private

    def contact_params
      params[:contact].permit(:user_id, :name, :email)
    end

end
