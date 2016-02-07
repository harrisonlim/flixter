class Instructor::LessonsController < ApplicationController
before_action :authenticate_user!
before_action :require_authorized_for_current_section

	def new
		@lesson = Lesson.new
	end

	def create
		@lesson = current_section.lessons.create(lesson_params)
		redirect_to instructor_course_path(current_section.course)
	end

	private

	def require_authorized_for_current_section
		if current_section.course.user != current_user
			return render text: 'Unauthorized', status: :unauthorized
		end
	end

	helper_method :current_section
	def current_section
		@current_section ||= Section.find(params[:section_id])
	end

	def lesson_params
		params.require(:lesson).permit(:title, :subtitle)
	end
end


# Why not use a @current_section instead of current_section? Is it because
# methods can't use @ in it?

# Does this self-creation of user authorization more a feature of other
# programming languages because they don't use gems? What are the pros & cons
# of creating your own authorization logic versus using something like Devise?

# so this bit of code "before_action :require_authorized_for_current_section"
# makes it such that this is a requirement for any method called in this
# controller?