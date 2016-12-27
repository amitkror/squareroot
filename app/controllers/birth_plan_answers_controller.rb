class BirthPlanAnswersController < ApplicationController
  layout 'devise'
	
  def create
  	@birth_plan = BirthPlan.find(params[:birth_plan_id])
  	
  	params[:plan].each do |id, attribute| 
  		
      question_id = id.to_i
      @question = Question.find(question_id)
      @ques_type = @question.ques_type
      if @ques_type == 3
        attribute.each  do |option, value|  
          answer = BirthPlanAnswer.new
          answer.question_id = @question.id
          answer.question = @question.title
          answer.user_id = current_user.id
          answer.ques_type = @ques_type
          answer.answer =  value
          answer.birth_plan_id = @birth_plan.id
          answer.save
        end   
      else 
        answer = BirthPlanAnswer.create!(question: @question.title,
                                          user_id: current_user.id,
        	                                ques_type: @ques_type,
        	                                answer: attribute,
        	                                birth_plan_id: @birth_plan.id, 
        	                                question_id: @question.id)
      end      
    end
    redirect_to birth_plan_answer_path(@birth_plan), :notice => "Your response has been successfully submitted"
  end

  def show
    @birth_plan = BirthPlan.first
    @user = current_user
    @answers = BirthPlanAnswer.where("user_id = ?", @user.id)
    
    @questions = []
    questions = @answers.pluck(:question_id).uniq 

    questions.each do |ques|
      begin
        @questions <<  Question.find(ques)
      rescue Exception => e
        logger.error e.message    
        next
      end
    end
  end  

  def edit
    @birth_plan_answer = BirthPlan.first
    @birth_plan = BirthPlan.first
    @user = current_user
    @answers = BirthPlanAnswer.where("user_id = ?", @user.id)
  end  

  def update

  end  

  private

  def answer_params
  	params(:birth_plan_answer).permit(:id, :user_id, :answer, :question, :ques_type, :birth_plan_id)
  end 	
end