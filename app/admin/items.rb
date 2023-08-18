# frozen_string_literal: true

ActiveAdmin.register Item do
  permit_params :name, :model_number, :description, :reference_url, :image_url, :size,
    inventories_attributes: [:department_id, :requested_quantity, :state, :item_version, :created_by_id]

  sidebar :history, partial: "layouts/version", only: :show
  menu false

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

    actions defaults: true do |item|
      link_to "Request", new_admin_inventory_path(item_id: item.id) if policy(item.inventories.build).new?
    end
  end

  show do |item|
    attributes_table do
      row :name
      row :model_number
      row :size
      row :reference_url do |item|
        link_to item.reference_url, item.reference_url, target: "_blank" unless item.reference_url.blank?
      end
      row :image do |item|
        image_tag item.image_url, style: "height:100px;width:auto;"
      end
    end

    panel "Inventories" do
      table_for item.inventories do
        column :department
        column :requested_quantity
        column :state do |inv|
          status_tag inv.state
        end
        column '' do |inv|
          link_to "View", admin_inventory_path(inv)
        end
      end
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
      f.input :size
      f.input :reference_url
      f.input :image_url
    end

    f.inputs for: :'inventories_attributes[0]' do |inv|
      inv.input :department_id, as: :select, collection: Department.all
      inv.input :requested_quantity, as: :number
      inv.input :state, as: :hidden, input_html: { value: "opened" }
      inv.input :item_version, as: :hidden, input_html: { value: item.versions.count.zero? ? 1 : item.versions.count }
      inv.input :created_by_id, as: :hidden, input_html: { value: current_user.id }
    end

    f.actions
  end
end
