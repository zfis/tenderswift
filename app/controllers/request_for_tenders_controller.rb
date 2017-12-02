class RequestForTendersController < ApplicationController
  before_action :set_request, only: [:show,
                                     :destroy,
                                     :email_request_for_tender]

  before_action :authenticate_quantity_surveyor!


  DEFAULT_BROADCAST_CONTENT = "If you have any questions you can reply me here".freeze

  # GET /requests
  # GET /requests.json
  def index
    @requests = current_quantity_surveyor.request_for_tenders.order(updated_at: :desc)
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    unless @request.winner.nil?
      @winner = Participant.find_by(auth_token: @request.winner.auth_token)
    end
    gon.jbuilder
  end

  # GET /requests/new
  def new
    country = Country.first
    @request = RequestForTender.new(project_name: 'Untitled Project',
                                    country: country,
                                    deadline: Time.current + 7.days)
    @request.quantity_surveyor = current_quantity_surveyor
    @request.create_blank_boq
    @request.save!
    create_chat_room_for @request
    redirect_to edit_tender_information_path @request
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = RequestForTender.new(request_params)
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html {
            if params[:commit] == 'Send Request Out'
              redirect_to email_request_for_tender_path(@request)
            elsif params[:commit] == 'Calculate Budget Differences'
              redirect_to @request
            end
        }
        format.json { render :show, status: :ok, location: @request }
        format.js
      else
        format.html { render :edit }
        format.js
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to request_for_tenders_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # GET /email_request_for_tender/1
  def email_request_for_tender
    if @request.submitted?
      redirect_to @request,
                  notice: 'The participants of this request have been contacted already'
    elsif @request.participants.empty?
      redirect_to edit_tender_participants_path(@request),
                  alert: 'You did not specify any participants in this request.'
    else
      if @request.chatroom.nil?
        create_chat_room_for @request
      end
      #create default broadcast message for the request
      broadcast = BroadcastMessage.new
      broadcast.content = DEFAULT_BROADCAST_CONTENT
      broadcast.chatroom = @request.chatroom
      broadcast.save!

      @request.participants.each do |participant|
        # Tell the ParticipantMailer to send a request_for_tender email
        ParticipantMailer.request_for_tender_email(participant, @request).deliver_later
      end

      BroadcastEmailJob.perform_later(broadcast) #send another mail about the default broadcast message

      @request.update(submitted: true)
      redirect_to @request, notice: 'An email has been sent to each participant of this request.'
    end
  end



  def set_winner
    request = RequestForTender.find(params[:id])
    participant = Participant.find(params[:participant])
    if request.winner = Winner.cast_participant(participant)
      disqualified_message = params[:request_for_tender][:notify_disqualified_contractors_message]
      winner_message = params[:request_for_tender][:final_email_message]
      notify_disqualified_contractors(request, disqualified_message)
      send_out_final_invitation(request, winner_message)
      render json: request
    else
      render json: request.errors.messages
    end  
  end


  private

  # Use to create a chatroom for a request
  def create_chat_room_for request_for_tender
    chatroom = Chatroom.new
    chatroom.request_for_tender = request_for_tender
    chatroom.save!
  end


  #Notify all disqualified contractors
  def notify_disqualified_contractors(request, body)
    request.get_disqualified_contractors.each do |contractor|
      DecisionMailer.notify_disqualified(contractor, request, body).deliver_now
    end
  end


  #POST /requests/send_out/:id
  #Send final inivitation out to shortlisted participants
  def send_out_final_invitation(request, body)
    DecisionMailer.award_contract(request, body).deliver_later
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :country_id,
                  :city,
                  :description,
                  :budget_currency,
                  :budget,
                  :final_email_message,
                  :notify_disqualified_contractors_message,
                  :contract_sum,
                  :contract_sum_currency,
                  project_documents_attributes: [:id,
                                                 :document,
                                                 :_destroy],
                  participants_attributes: [:id,
                                            :email,
                                            :phone_number,
                                            :company_name,
                                            :_destroy],
                  questions_attributes: [:id,
                                         :number,
                                         :title,
                                         :description,
                                         :question_type,
                                         :can_attach_documents,
                                         :mandatory,
                                         :_destroy],
                  excel_attributes: [:id,
                                     :document])
  end
end
