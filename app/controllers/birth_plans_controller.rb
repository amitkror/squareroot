class BirthPlansController < ApplicationController
  layout "devise"
  before_action :authenticate_user!, except: [:index]
  def index

  end

  def active_plan
    birth_plan_record = BirthPlanAnswer.find_by_user_id(current_user.id)
    @birth_plan = BirthPlan.first
    if birth_plan_record.present?
      redirect_to birth_plan_answer_path(@birth_plan)
    else
      @birth_plan_answer = BirthPlanAnswer.new
    end  
  end
 #{"ques"=>"29", "option"=>"38"}

  def set_birth_plan
    birth_plan_record   = BirthPlanAnswer.find_by_user_id(current_user.id)
    @birth_plan         = BirthPlan.first
    @checklists         = Checklist.order(:category)
    @category           = @checklists.map(&:category).uniq.compact
    @checklist_answers  = current_user.checklist_answers
    @self_checklists    = current_user.checklist_answers.where(checklist_id: [nil, ''])
    @cat_id             = params[:c_id].present? ? params[:c_id].to_i : 0
    @questions          = Question.where(category: Question::CATEGORY_TYPES[@cat_id])
    if birth_plan_record.present?
      redirect_to birth_plan_answer_path(@birth_plan)
    else
      @birth_plan_answer = BirthPlanAnswer.new
    end  
  end

 private

 def birth_plan_params
   params.require(:birth_plan).permit(:title, :status, :description, birth_plan_answer_attributes: [:id, :question, :answer, :ques_type, :user_id])
 end

end