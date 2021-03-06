class ClientsController < ApplicationController

	before_filter :authenticate_user!
	load_and_authorize_resource
	def index
		@clients = current_user.is_admin? ? Client.all : current_user.clients
	end
	def new 
		@client = Client.new
	end
	def create
		@client = Client.new(client_params)
		@client.user_id = current_user.id
		if @client.save
			redirect_to clients_path
		else
			render action: "new"
		end
	end

	def show
		begin
		@client = current_user.is_admin? ? Client.find(params[:id]) : current_user.clients.find(params[:id])
	rescue ActiveRecord::RecordNotFound
		redirect_to clients_path, notice: "Record Not Found"
	end
end
	def edit
		@client = Client.find(params[:id])
	end
	def update
		@client = Client.find(params[:id])
		@client.user_id = current_user.id
		if @client.update_attributes(client_params)
			redirect_to client_path(@client.id), notice: "Successfully updated"
		else 
			render action: "edit"
		end
	end
	def destroy
		@client = Client.find(params[:id])
		@client.destroy
		redirect_to clients_path, notice: "Successfull deleted #{@client.name}"
	end
	
	private
	def client_params
		params[:client].permit(:name, :copany, :email, :mobile)
	end
		

end
