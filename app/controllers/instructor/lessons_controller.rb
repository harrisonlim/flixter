class Instructor::LessonsController < ApplicationController
before_action :authenticate_user!
before_action :require_authorized_for_current_section, only: [:new, :create]
before_action :require_authorized_for_current_lesson, only: [:update]

	def new
		@lesson = Lesson.new
	end

	def create
		@lesson = current_section.lessons.create(lesson_params)
		redirect_to instructor_course_path(current_section.course)
	end

	def update
		current_lesson.update_attributes(lesson_params)
		render text: 'updated!'
	end

	private

	def require_authorized_for_current_lesson
		if current_lesson.section.course.user != current_user
			render text: 'Unauthorized', status: :unauthorized
		end
	end

	def current_lesson
		@current_lesson ||= Lesson.find(params[:id])
	end

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
		params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
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
