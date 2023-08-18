# frozen_string_literal: true

ActiveAdmin.register Item do
  permit_params :name, :model_number, :description, :reference_url, :image_url,
    inventories_attributes: [:department_id, :requested_quantity, :state, :item_version]

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
    column :image do |item|
      image_tag item.image_url, style: "height:60px;width:auto;"
    end

    actions
  end

  show do |item|
    attributes_table do
      row :name
      row :model_number
      row :description
      row :reference_url
      row :image do |item|
        image_tag item.image_url, style: "height:100px;width:auto;"
      end
    end

    table_for item.inventories do
      column :department
      column :requested_quantity
      column :state
    end
  end

  action_item :request_item, only: :show do
    link_to "Request this Item", new_admin_inventory_path(item_id: resource.id)
  end

  filter :name
  filter :model_number

  form do |f|
    f.inputs do
      f.input :name
      f.input :model_number
      f.input :reference_url
      f.input :image_url
    end

    f.inputs for: :'inventories_attributes[0]' do |inv|
      inv.input :department_id, as: :select, collection: Department.all
      inv.input :requested_quantity
      inv.input :state, as: :hidden, input_html: { value: "opened" }
      inv.input :item_version, as: :hidden, input_html: { value: item.versions.count.zero? ? 1 : item.versions.count }
    end

    f.actions
  end
end
