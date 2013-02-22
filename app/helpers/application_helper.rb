module ApplicationHelper

  def render_sign_up
    (current_user ? '' : "<li><a href='" + signup_path + "'>Sing up</a></li>").html_safe
  end

  def render_log_in
    (current_user ? '' : "<li><a href='" + login_path + "'>Log in</a></li>").html_safe
  end

  def render_sender task
    tasks_user = current_user.tasks_users.find_by_task_id(task.id)
    email = tasks_user.sender.email if tasks_user
    email == current_user.email ? 'me' : email
  end
end
