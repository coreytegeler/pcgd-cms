class ApplicationController < ActionController::Base
  # include ActionView::Helpers::UrlHelper
  protect_from_forgery with: :exception

  before_filter :select_palette, only: [:index]
  before_filter :select_logo, only: [:index]
  before_filter :select_gradient, only: [:index]
  before_filter :select_pattern, only: [:index]

  def index 
  	@groups = Group.sorted
  end

  def logged_in?
  	!!session[:admin_id]
  end

  def confirm_logged_in
    unless session[:admin_id]
      flash[:notice] = "You are not logged in"
      redirect_to(:controller => 'access', :action => 'login')
      return false
    else
      return true
    end
  end

  def next_palette
    session[:palette] = session[:next_palette]
    find_next_palette
  end

  def next_logo
    session[:logo] = session[:next_logo]
    find_next_logo
  end

  def next_gradient
    session[:no_gradient] = false
    session[:gradient] = session[:next_gradient]
    find_next_gradient
  end

  def next_pattern
    session[:no_pattern] = false
    session[:pattern] = session[:next_pattern]
    find_next_pattern
  end

  def clear_gradient
    session[:no_gradient] = true
    redirect_to(:controller => 'public', :action => 'index')
  end

  def clear_pattern
    session[:no_pattern] = true
    redirect_to(:controller => 'public', :action => 'index')
  end

  private

      def select_palette
        palettes = Palette.sorted
        if !params[:palette].nil?
          palette = palettes.where(:id => params[:palette]).first
          flash[:notice] = back_link(palette.name)
          flash[:type] = 'neutral'
          session[:palette] = [palette.primary_color, palette.secondary_color, palette.position]
        elsif session[:palette].nil?
          random = rand(1..palettes.length)
          palette = palettes.where(:position => random).first
          session[:palette] = [palette.primary_color, palette.secondary_color, palette.position]
        end

        current_palette = session[:palette]

        @p = current_palette.first
        @s = current_palette.second

        if session[:next_palette].nil?
          find_next_palette
        end

        @next_p = session[:next_palette].first
        @next_s = session[:next_palette].second

      end

      def find_next_palette
        palettes = Palette.all
        current_pos = session[:palette].last
        next_pos = next_check(current_pos, palettes)
        next_palette = palettes.where(:position => next_pos).first
        session[:next_palette] = [next_palette.primary_color, next_palette.secondary_color, next_palette.position]  
        redirect_to(:controller => 'public', :action => 'index')
      end

      def back_link(name)
        "This is #{name}, do you want to try <a href='/palettes/admin'>another one</a>?"
      end

      def select_logo
        logos = Logo.sorted
        if session[:logo].nil? || logos.where(:position => session[:logo]).first.nil?
          random = rand(1..logos.length)
          logo = logos.where(:position => random).first
          session[:logo] = logo.position
        end

        current_logo_pos = session[:logo]

        @logo = logos.where(:position => current_logo_pos).first.file

        if session[:next_logo].nil?
          find_next_logo
        end

        @next_logo = logos.where(:position => session[:next_logo]).first.file

      end

      def find_next_logo
        logos = Logo.all
        current_pos = session[:logo]
        next_pos = next_check(current_pos, logos)
        session[:next_logo] = next_pos
        redirect_to(:controller => 'public', :action => 'index')
      end

      def select_gradient
        gradients = Gradient.sorted
        if session[:gradient].nil? || gradients.where(:position => session[:gradient]).first.nil?
          random = rand(1..gradients.length)
          gradient = gradients.where(:position => random).first
          session[:gradient] = gradient.position
        end

        current_gradient_pos = session[:gradient]

        if session[:no_gradient] != true
          @gradient = gradients.where(:position => current_gradient_pos).first.file
          @gradient_state = 'on'
        else
          @gradient = nil
          @gradient_state = 'off'
        end

        if session[:next_gradient].nil?
          find_next_gradient
        end

        @next_gradient = gradients.where(:position => session[:next_gradient]).first.file

      end

      def find_next_gradient
        gradients = Gradient.all
        current_pos = session[:gradient]
        next_pos = next_check(current_pos, gradients)
        session[:next_gradient] = next_pos
        redirect_to(:controller => 'public', :action => 'index')
      end

      def select_pattern
        patterns = Pattern.sorted
        if session[:pattern].nil? || patterns.where(:position => session[:pattern]).first.nil?
          random = rand(1..patterns.length)
          pattern = patterns.where(:position => random).first
          session[:pattern] = pattern.position
        end

        current_pattern_pos = session[:pattern]

        if session[:no_pattern] != true
          @pattern = patterns.where(:position => current_pattern_pos).first.tile
          @pattern_state = 'on'
        else
          @pattern = nil
          @pattern_state = 'off'
        end

        if session[:next_pattern].nil?
          find_next_pattern
        end

        @next_pattern = patterns.where(:position => session[:next_pattern]).first.tile
      end

      def find_next_pattern
        patterns = Pattern.all
        current_pos = session[:pattern]
        next_pos = next_check(current_pos, patterns)
        session[:next_pattern] = next_pos
        redirect_to(:controller => 'public', :action => 'index')
      end

      def next_check(i, q)
        if i != q.length
          i + 1
        else
          1
        end
      end
         
end
