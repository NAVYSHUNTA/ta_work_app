module WorksHelper
  def display_content(content)
    content.present? ? content : "未入力"
  end

  def display_note(note)
    note.present? ? note : "なし"
  end
end
