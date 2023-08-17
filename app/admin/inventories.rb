# frozen_string_literal: true

ActiveAdmin.register Inventory do
  permit_params :department_id, :requested_quantity, :item_id

  sidebar :history, partial: "layouts/version", only: :show

  controller do
    def show
      @inventory = Inventory.includes(:versions).find(params[:id])
      @versions = @inventory.versions

      # @inventory = @inventory.versions[params[:version].to_i].reify if params[:version]
      show!
    end

    def create
      @inventory = Inventory.new(permitted_params[:inventory])
      @inventory.item_version = Item.find(permitted_params[:inventory][:item_id]).versions.count

      create!
    end
  end

  show do
    attributes_table do
      row :item do |inventory|
        link_to inventory.item.name, admin_item_path(inventory.item, version: inventory.item_version)
      end

      row :department
      row :requested_quantity
      row :state
      row :verified_at
      row :verified_by
    end
  end

  index do
    selectable_column

    id_column
    column :item do |inventory|
      link_to inventory.item.name, admin_item_path(inventory.item, version: inventory.item_version)
    end
    column :department
    column :state
    column :image do |inventory|
      item = inventory.item.versions[inventory.item_version.to_i] ? inventory.item.versions[inventory.item_version.to_i].reify : inventory.item

      image_tag item.image_url, style: "height:60px;width:auto;"
    end

    actions defaults: true do |inventory|
      link_to "Verify", verify_admin_inventory_path(inventory), method: :put if policy(inventory).verify?
    end
  end

  batch_action :bulk_verify, if: proc { policy(Inventory).bulk_verify? }  do |ids|
    batch_action_collection.where(state: "created", id: ids).each do |inventory|
      inventory.verify!(:verified, current_user.id) if policy(inventory).verify?
    end

    redirect_to collection_path, alert: "The inventories are verified."
  end

  filter :item
  filter :department

  member_action :verify, method: :put do
    resource.verify!(:verified, current_user.id)
    redirect_to resource_path, notice: "verified!"
  end

  action_item :verify, only: :show, if: proc { policy(resource).verify? } do
    link_to "Verify", verify_admin_inventory_path(resource), method: :put
  end

  form do |f|
    f.inputs do
      f.input :item
      f.input :department
      f.input :requested_quantity
    end

    f.actions
  end
end
