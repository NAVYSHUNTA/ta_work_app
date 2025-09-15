module WorksHelper
  def display_content(content)
    if content.present?
      content
    else
      "未入力"
    end
  end
end
