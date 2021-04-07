class Question < ApplicationRecord

  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  after_create :set_statistic

  # Kaminari
  paginates_per 5

  # Scopes
  scope :_search_, lambda { |page, term|
    includes(:answers)
      .where("lower(description) LIKE ?", "%#{term.downcase}%")
      .page(page)
  }

  scope :_search_subject_, lambda { |page, subject_id|
    includes(:answers)
      .where(subject_id: subject_id)
      .page(page)
  }

  scope :last_questions, lambda { |page|
    includes(:answers, :subject).order("created_at DESC").page(page)
  }

  private

    def set_statistic
      AdminStatistic.set_event(AdminStatistic::EVENTS[:total_questions])
    end

end
