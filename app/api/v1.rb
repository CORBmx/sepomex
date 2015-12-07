module API
  class V1 < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    helpers ApplicationHelper

    get :zip_codes do
      zip_codes = ZipCode.search(params).page(params[:page]).per(50)
      render zip_codes, meta: pagination_json(zip_codes, 50)
    end

    namespace :states do

      get "/" do
        State.all
      end

      get ":id", root: "state" do
        State.find(params[:id])
      end

      get ":id/municipalities", root: "municipalities" do
        state = State.find(params[:id])
        state.municipalities.order(:id)
      end

    end


    namespace :municipalities do

      get "/" do
        municipalities = Municipality.search(params).page(params[:page]).per(50)
        render municipalities, meta: pagination_json(municipalities, 50)
      end

      get ":id" do
        Municipality.find(params[:id])
      end

    end
  end
end