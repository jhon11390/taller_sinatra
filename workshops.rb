require "sinatra"

def workshop_content(name)
    File.read("workshops/#{name}.txt")
rescue Errno::ENOENT
    return nill
end

def save_workshop(name, description)
    File.open("workshops/#{name}.txt", "w") do |file|
        file.print(description)
    end
end

def delete_workshop(name)
    File.delete("workshops/#{name}.txt")
end

get '/' do
    @files = Dir.entries("workshops")
    @files.delete("..")
    @files.delete(".")
    erb :home, layout: :main
end

get '/create' do
    erb :create, layout: :main
end

get '/:name' do
    @name = params[:name]
    @description = workshop_content(@name)
    erb :workshop, layout: :main
end

post '/create' do
    save_workshop(params["name"], params["description"])
    @message = "creado"
    @name = params["name"]
    erb :message, layout: :main
end

delete '/:name' do
    delete_workshop(params[:name])
    @name = params[:name]
    @message = "eliminado"
    erb :message, layout: :main
end

get '/:name/edit' do
    @name = params[:name]
    @description = workshop_content(@name)
    erb :edit, layout: :main
end

put '/:name' do
    save_workshop(params[:name], params["description"])
    redirect "/#{params[:name]}"
end