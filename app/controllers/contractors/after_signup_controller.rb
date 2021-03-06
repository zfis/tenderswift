# frozen_string_literal: true

class Contractors::AfterSignupController < ContractorsController
  def edit
    authorize current_contractor
  end

  def update
    authorize current_contractor
    contractor = current_contractor

    params[:contractor][:status] = 'active'
    if contractor.update(contractor_params)
      sign_out contractor
      sign_in :contractor, contractor
      redirect_to contractor_root_path
    else
      render :edit
    end
  end

  def contractor_params
    params.require(:contractor).permit(
      :full_name,
      :email,
      :phone_number,
      :company_name,
      :company_logo,
      :password,
      :password_confirmation,
      :status
    )
  end
end
