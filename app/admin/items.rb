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

    def create
      create! do |format|
        format.html { redirect_to new_admin_inventory_path(item_id: @item.id) }
      end
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

    div class: 'panel' do
      h3 'Inventories'
      div class: 'attributes_table' do
        table do
          tr do
            th 'Department'
            th 'Requested Quantity'
            th 'State'
          end
          item.inventories.each do |inventory|
            tr do
              td link_to inventory.department.name, admin_department_path(inventory.department)
              td inventory.requested_quantity
              td inventory.state
            end
          end
        end
      end
    end
  end

  action_item :request_item, only: :show do
    link_to 'Request this Item', new_admin_inventory_path(item_id: resource.id)
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
