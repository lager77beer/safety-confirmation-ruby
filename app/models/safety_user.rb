class SafetyUser < ApplicationRecord

  self.primary_key = 'id' #←これを追加

  # $safety_user->safety で disaster_idとuser_idをキーに　Safety 
  def safety()
      return Safety.where(disaster_id: self.disaster_id).where(user_id: self.user_id).first
  end

end

