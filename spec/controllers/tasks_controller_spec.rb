require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe TasksController do
  before do
    @mock_user = mock_model(User, :email => 'admin@admin.adm')
    @task = mock_model(Task)
    @task_common = mock_model(Task)
    Task.stub!(:all).and_return([@task, @task_common])
    @mock_user.stub!(:tasks).and_return([@task])
    controller.stub!(:current_user).and_return @mock_user
  end

  describe "GET #index" do
    it 'should render index.html' do
      get :index
      assigns[:tasks].should include(@task)
      response.should render_template(:index)
    end
  end

  describe "GET #other_tasks" do
    it 'should render index.html' do
      get :other_tasks
      assigns[:tasks].should include(@task_common)
      response.should render_template(:index)
    end
  end

  describe "GET #new" do
    before do
      params = {:id => 1}
      Task.stub!(:new).and_return @task
    end

    it 'should render new.html' do
      get :new
      assigns[:task].should == @task
      response.should render_template(:new)
    end
  end

  describe "GET #:id/edit" do
    before do
      Task.stub!(:find).and_return @task
    end

    it 'should render edit.html' do
      get :edit, id: 1
      assigns[:task].should == @task
      response.should render_template(:edit)
    end

  end

  describe "POST #create" do
    before do
      Task.stub!(:new).and_return @task
      @task.stub!(:save).and_return true
      controller.stub!(:assign_task).and_return true
    end

    it 'should render index.html' do
      post :create, :task => 'task', :assigned => ['1']
      assigns[:task].should == @task
      assigns[:tasks].should include(@task)
      response.should redirect_to(tasks_path)
    end
  end

  describe "PUT #update" do
    before do
      @task.stub!(:update_attributes).and_return true
      controller.stub!(:assign_task).and_return true
      Task.stub!(:find).and_return @task
    end

    it 'should render index.html' do
      put :update, id: 1, :task => 'task', :assigned => ['1']
      assigns[:task].should == @task
      assigns[:tasks].should include(@task)
      response.should redirect_to(tasks_path)
    end
  end

  describe "DELETE #update" do
    before do
      @task.stub!(:destroy).and_return true
      Task.stub!(:find).and_return @task
    end

    it 'should render index.html' do
      delete :destroy, id: 1
      assigns[:task].should == @task
      response.should redirect_to(tasks_path)
    end
  end

end