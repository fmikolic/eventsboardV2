module ApplicationHelper
    def full_title(page_title = " ")
        default_title = "Events board"
        if page_title.empty?
            default_title
        else
            "#{page_title} | #{default_title}"
        end
    end

    def time_format(event_date)
        event_date&.strftime("%A, %d %b %Y %l:%M %p")
    end

    def event_status(event)
        if event.end_date <= Date.today
            content_tag(:span, "", class: "past")
        else
            content_tag(:span, "", class: "upcoming")
        end 
    end

    def admins_only(&block)
        block.call if current_user.try(:admin?)
    end

    def avatar_url(user)
        hash = Digest::MD5.hexdigest(user.email.downcase)
        "https://www.gravatar.com/avatar/#{hash}"
    end
end
