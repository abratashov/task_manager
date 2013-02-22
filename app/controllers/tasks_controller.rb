class TasksController < ApplicationController
  before_filter :require_login#, :only => :desktop
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks
    @is_index = true

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  def other_tasks
    @tasks = Task.all - current_user.tasks
    @is_index = false

    respond_to do |format|
      format.html { render "tasks/index" }
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @tasks = current_user.tasks

    respond_to do |format|
      if @task.save
        assign_task(@task, params['assigned'])
        # format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.html { redirect_to tasks_path }
        format.json { render json: @task, status: :created, location: @task }
      else
        error = @task.errors.messages[:description]
        flash.now.alert = error.first if error && error.first
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    @tasks = current_user.tasks
    assign_task(@task, params['assigned'])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        # format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.html { redirect_to tasks_path }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private

  def assign_task task, assign_list
    unless assign_list
      users = task.users
      users.each do |user|
        tasks_user = user.tasks_users.find_by_task_id(task.id)
        p tasks_user
        tasks_user.destroy if tasks_user
      end
    else
      assign_list = assign_list.map{|id| id.to_i}
      p "assign_list: #{assign_list}"
      current_list = task.users.map{|user| user.id}
      p "current_list: #{current_list}"
      assign_add_list = assign_list - current_list
      p "assign_add_list: #{assign_add_list}"
      assign_add_list.each do |user_id|
        tasks_user = TasksUser.new({
          :user_id => user_id,
          :task_id => task.id,
          :sender_id => current_user.id,
        })
        unless tasks_user.save
          error = tasks_user.errors.messages[:description]
          flash.now.alert = error.first if error && error.first
        end
      end
      
      assign_remove_list = current_list - assign_list
      p "assign_remove_list: #{assign_remove_list}"
      assign_remove_list.each do |user_id|
        p "user_id: #{user_id}, task.id: #{task.id}"
        tasks_user = User.find(user_id).tasks_users.find_by_user_id_and_task_id(user_id, task.id)
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Removed: #{tasks_user}"
        unless tasks_user.destroy
          error = tasks_user.errors.messages[:description]
          flash.now.alert = error.first if error && error.first
        end
      end
    end
  end
end
