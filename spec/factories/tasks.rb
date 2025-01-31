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
  
  factory :resume_task, class: Task do
    title { 'Prepare resume' }
    content { 'Prepare resume' }
    deadline_on { Date.today }
    priority { 2 }
    status { 0 }
  end

  factory :linkedin_task, class: Task do
    title { 'Updpate LinkedIn' }
    content { 'Update linkedIn' }
    deadline_on { 1.day.from_now }
    priority { 1 }
    status { 1 }
  end

  factory :research_task, class: Task do
    title { 'Search companies' }
    content { 'Search companies' }
    deadline_on { 2.days.from_now }
    priority { 0 }
    status { 2 }
  end

  factory :apply_task, class: Task do
    title { 'Apply companies' }
    content { 'Apply companies' }
    deadline_on { 3.days.from_now }
    priority { 0 }
    status { 1 }
  end

end
