FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { Date.today }
    priority { 1 }
    status { 0 }
  end

  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.today }
    priority { 1 }
    status { 0 }
  end
end
