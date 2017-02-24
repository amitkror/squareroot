class ChecklistAnswersController < ApplicationController
  before_action :set_checklist_answer, only: [:show, :edit, :update, :destroy]

  # GET /checklist_answers
  def index
    @checklist_answers = ChecklistAnswer.all
  end

  # GET /checklist_answers/1
  def show
  end

  # GET /checklist_answers/new
  def new
    @checklist_answer = ChecklistAnswer.new
  end

  # GET /checklist_answers/1/edit
  def edit
  end

  # POST /checklist_answers
  def create
    @checklist_answer = ChecklistAnswer.new(checklist_answer_params)

    if @checklist_answer.save
      redirect_to @checklist_answer, notice: 'Checklist answer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /checklist_answers/1
  def update
    if @checklist_answer.update(checklist_answer_params)
      redirect_to @checklist_answer, notice: 'Checklist answer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /checklist_answers/1
  def destroy
    @checklist_answer.destroy
    redirect_to checklist_answers_url, notice: 'Checklist answer was successfully destroyed.'
  end

  def toggle
    checklist = Checklist.find_by(title: params[:title])
    checklist ||= ChecklistAnswer.find_by(title: params[:title])
    if params[:is_checked] == 'true' && checklist.present?      
      current_user.checklist_answers.create(title: checklist.title, checklist_id: checklist.id, category: checklist.category)
    elsif params[:is_checked] == 'true' && checklist.blank? 
      current_user.checklist_answers.create(title: params[:title], category: params[:category])
    elsif params[:is_checked] == 'false' && checklist.present? 
      current_user.checklist_answers.find_by(title: checklist.title).destroy
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checklist_answer
      @checklist_answer = ChecklistAnswer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def checklist_answer_params
      params.require(:checklist_answer).permit(:title, :user_id, :checklist_id, :category)
    end
end
