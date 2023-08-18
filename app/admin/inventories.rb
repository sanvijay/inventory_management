# frozen_string_literal: true

ActiveAdmin.register Inventory do
  permit_params :department_id, :requested_quantity, :item_id, :state
  config.clear_action_items!

  sidebar :history, partial: "layouts/version", only: :show

  controller do
    def show
      @inventory = Inventory.includes(:versions).find(params[:id])
      @versions = @inventory.versions

      # @inventory = @inventory.versions[params[:version].to_i].reify if params[:version]
      show!
    end

    def new
      @inventory = Inventory.new(item_id: params[:item_id], state: "opened")

      new!
    end

    def create
      @inventory = Inventory.new(permitted_params[:inventory])
      @inventory.created_by = current_user
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
      row :requested_by do
        inventory.created_by
      end
      row :requested_at do
        inventory.created_at
      end
    end

    panel "Item" do
      attributes_table_for inventory.item do
        row :name
        row :model_number
        row :size
        row :reference_url do |item|
          link_to "Link", item.reference_url, target: "_blank" unless item.reference_url.blank?
        end
        row :image do |item|
          image_tag item.image_url, style: "height:100px; width:auto;"
        end
      end
    end
  end

  index do
    selectable_column

    column :item do |inventory|
      link_to inventory.item.name, admin_item_path(inventory.item, version: inventory.item_version)
    end
    column :model_number do |inventory|
      item = inventory.item.versions[inventory.item_version.to_i] ? inventory.item.versions[inventory.item_version.to_i].reify : inventory.item

      item.model_number
    end
    column :size do |inventory|
      item = inventory.item.versions[inventory.item_version.to_i] ? inventory.item.versions[inventory.item_version.to_i].reify : inventory.item

      item.size
    end
    column :reference_url do |inventory|
      item = inventory.item.versions[inventory.item_version.to_i] ? inventory.item.versions[inventory.item_version.to_i].reify : inventory.item

      link_to "Link", item.reference_url, target: "_blank" unless item.reference_url.blank?
    end

    column :department
    column :requested_quantity
    column :state do |inventory|
      status_tag inventory.state
    end
    column :image do |inventory|
      item = inventory.item.versions[inventory.item_version.to_i] ? inventory.item.versions[inventory.item_version.to_i].reify : inventory.item

      link_to image_tag(item.image_url, style: "height:60px;width:auto;"), item.image_url, target: "_blank"
    end

    actions defaults: true do |inventory|
      links = []
      links << link_to("Verify", verify_admin_inventory_path(inventory), method: :put) if policy(inventory).verify?
      links << link_to("Reorder", new_admin_inventory_path(item_id: inventory.item.id))

      links.join(" ").html_safe
    end
  end

  batch_action :bulk_verify, if: proc { policy(Inventory).bulk_verify? }  do |ids|
    batch_action_collection.where(state: "opened", id: ids).each do |inventory|
      inventory.verify!(:verified, current_user.id) if policy(inventory).verify?
    end

    redirect_to collection_path, alert: "The inventories are verified."
  end

  filter :item
  filter :department
  filter :state, as: :select, collection: Inventory.states

  member_action :verify, method: :put do
    resource.verify!(:verified, current_user.id)
    redirect_to resource_path, notice: "verified!"
  end

  action_item :verify, only: :show, if: proc { policy(resource).verify? } do
    link_to "Verify", verify_admin_inventory_path(resource), method: :put
  end

  action_item only: :index do
    link_to "Request new item", new_admin_item_path
  end

  form do |f|
    f.inputs do
      f.input :item
      f.input :department
      f.input :requested_quantity
      f.input :state, as: :hidden
    end

    f.actions
  end
end
