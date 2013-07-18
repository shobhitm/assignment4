require 'rubygems'  
require 'sinatra'  
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")  
  
class Note  
  include DataMapper::Resource  
  property :id, Serial  
  property :content, Text, :required => true 
  property :announce, Text, :required => true  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!

get '/' do  
  @notes = Note.all(:order => :id.desc)
  @title = 'All Notes'  
  erb :home 
end 

post '/' do  
  n = Note.new  
  n.content = params[:content] 
  n.announce = params[:announce] 
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end

get '/all' do  
  @notes = Note.all(:order => :id.desc)
  @title = 'All Notes'  
  erb :homeall 
end 

post '/all' do  
  n = Note.new  
  n.content = params[:content] 
  n.announce = params[:announce] 
  n.created_at = Time.now  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end

get '/notes.?:format?' do
  @notes = Note.all(:order => :id.desc)
  if params[:format] == "json"
    content_type :json
    @notes.to_json
  elsif params[:format] == "xml"
    content_type :xml
    @notes.to_xml
  end
end

get '/users.?:format?' do
  @users = Note.all(:order => :id.desc)
  if params[:format] == "json"
    content_type :json
    @users.to_json(:only=>[:content])
  else
    content_type :xml
    @users.to_xml(:only=>[:content])
  end
end

get '/:id' do  
  @note = Note.get params[:id]  
  @title = "Edit note ##{params[:id]}"  
  erb :edit  
end 

put '/:id' do  
  n = Note.get params[:id]  
  n.announce = params[:announce]
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end

get '/:id/delete' do  
  @note = Note.get params[:id]  
  @title = "Confirm deletion of note ##{params[:id]}"  
  erb :delete  
end

delete '/:id' do  
  n = Note.get params[:id]  
  n.destroy  
  redirect '/'  
end




