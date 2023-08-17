# frozen_string_literal: true

ActiveAdmin.register Item do
  permit_params :name, :model_number, :description, :reference_url, :image_url

  sidebar :history, partial: "layouts/version", only: :show

  controller do
    def show
      @item = Item.includes(:versions).find(params[:id])
      @versions = @item.versions

      @item = @item.versions[params[:version].to_i] ? @item.versions[params[:version].to_i].reify : @item if params[:version]

      show!
    end
  end

  index do
    selectable_column

    id_column
    column :name
    column :model_number
    column :reference_url

    actions
  end

  show do
    attributes_table do
      row :name
      row :model_number
      row :description
      row :reference_url
      row :image do |item|
        image_tag item.image_url, style: "height:100px;width:auto;"
      end
    end
  end

  filter :name
  filter :model_number

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :model_number
      f.input :reference_url
      f.input :image_url
    end

    f.actions
  end
end
