class Story < ActiveRecord::Base
  belongs_to :iteration
  has_many :tasks, :dependent => :destroy
  has_many :notes, :class_name => 'StoryNote', :foreign_key => "story_id"#, :dependent => :destroy

  validates_numericality_of :pivotal_identifier, :greater_than_or_equal_to => 1, :only_integer => true, :allow_nil => true
  validates_uniqueness_of :pivotal_identifier, :case_sensitive => false, :scope => :iteration_id
  validates_presence_of :story_type, :url, :status, :name, :pivotal_identifier

  named_scope :accepted,
              :conditions => {:status => "accepted"}
  named_scope :pushed,
              :conditions => {:status => "pushed"}
  named_scope :pointed,
              :conditions => ['points >= 0']
  named_scope :conditional_pushed,
              lambda { |param| return {} if param.nil? or param == "Y"
              {:conditions => ["stories.status <> ?", "pushed"]}
              }
  named_scope :conditional_not_accepted,
              lambda { |param| return {} if param.nil? or param == "Y"
              {:conditions => ["status != 'accepted'"]}
              }


  def self.sort_by_status stories
    stories.sort_by do |s|
      case s.status
        when "accepted" then
          1
        when "delivered" then
          2
        when "finished" then
          3
        when "rejected" then
          4
        when "started" then
          5
        when "unstarted" then
          6
        when "pushed" then
          7
      end
    end
  end
end
