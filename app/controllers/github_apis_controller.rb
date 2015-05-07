class GithubApisController <ApplicationController

  require 'open-uri'

  def index
    @array_of_user_hashes = Array.new
    unless params[:search].nil?
      user_names_array = params[:search].split(",")
      unless user_names_array.blank?
        user_names_array.each do |user_name|
          owner_specific_commits_counter = 0
          repos_json = JSON.load(open("https://api.github.com/users/#{user_name}/repos?access_token=b0b348536d604f036e0d448450272438867fbbf4"))
          repos_json.each do |repo|
            commits_count_json = JSON.load(open("https://api.github.com/repos/#{user_name}/#{repo['name']}/stats/participation?access_token=b0b348536d604f036e0d448450272438867fbbf4"))
            owner_repo_commits_count_array = commits_count_json['owner']
            unless owner_repo_commits_count_array.nil?
              owner_specific_commits_counter = owner_specific_commits_counter + owner_repo_commits_count_array.inject { |sum, x| sum + x }
            end
          end
          @array_of_user_hashes << {user_name: user_name, commits_count: owner_specific_commits_counter}
        end
      end
    end
    @users = @array_of_user_hashes.sort_by { |hsh| -hsh[:commits_count] }
  end
end