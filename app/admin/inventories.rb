ActiveAdmin.register Inventory do
  permit_params :name, :model_number, :department_id, :description

  sidebar :history, partial: 'layouts/version', only: :show

  controller do
    def show
      @inventory = Inventory.includes(:versions).find(params[:id])
      @versions = @inventory.versions

      # @inventory = @inventory.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  index do
    selectable_column

    id_column
    column :name
    column :model_number
    column :department
    column :state

    actions defaults: true do |inventory|
      link_to 'Verify', verify_admin_inventory_path(inventory), method: :put if policy(inventory).verify?
    end
  end

  batch_action :bulk_verify, if: proc { policy(Inventory).bulk_verify? }  do |ids|
    batch_action_collection.where(state: 'created', id: ids).each do |inventory|
      inventory.verify!(:verified, current_user.id)
    end

    redirect_to collection_path, alert: "The inventories are verified."
  end

  filter :name
  filter :model_number
  filter :department

  member_action :verify, method: :put do
    resource.verify!(:verified, current_user.id)
    redirect_to resource_path, notice: "verified!"
  end

  action_item :verify, only: :show, if: proc { policy(resource).verify? } do
    link_to 'Verify', verify_admin_inventory_path(resource), method: :put
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :model_number
      f.input :department
    end

    f.actions
  end
end
