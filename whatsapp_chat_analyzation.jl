# julia 1.2.0
using Pkg
using Unicode

message_regex = r"(^[\[]?[\d]+\/[\d]{1,2}\/[\d]{1,2}[,]\s[\d]{1,2}[:][\d]{1,2}([:][\d]{1,2}[\]]|[\s]\-[\s])).*[\:].*"
admin_opperation_regex = r"(^[\[]?[\d]+\/[\d]{1,2}\/[\d]{1,2}[,]\s[\d]{1,2}[:][\d]{1,2}[:]?[\d]?[\d]?).*"

fname = joinpath(homedir(),"Documents","whatsapp_chat.txt")
f = open(fname,"r")
l = readlines(f)

messages = []
count = 1
message_count = 1
err_count = 0
err_dict = Dict()
chat_admin_opperations = Dict()

for x in l
    global err_count
    global messages
    global count
    global err_dict
    global message_count
    global chat_admin_opperations
    
    x = Unicode.normalize(x, stripignore=true)
    if occursin(message_regex,x)
        push!(messages,x)
        message_count += 1
        
    else 
        if occursin(admin_opperation_regex,x)
            chat_admin_opperations[err_count] = x
            
        elseif haskey(err_dict, message_count - 1)
            err_dict[message_count - 1] *= " " * x
            
        else
            err_dict[message_count - 1] = x
            
        end
        err_count += 1
    end
    count += 1
end
for (k,v) in err_dict
    messages[k] *= " " * v
end

println("number of admin opperations => ", length(chat_admin_opperations))
println(message_count, " message_count")
println(err_count, " Err count")
println(count, " Total count")

decomposed_messages = []
i=1

for s in messages

    global i
    global decomposed_messages

    i += 1
    if s[1:1] == "["
        date = s[2:8]
        time = s[11:18]
        rest_message = s[21:end]
        
    else
        date = s[1:7]
        time = s[10:14]
        rest_message = s[18:end]

    end

    sender = rest_message[1:first(findfirst(":",rest_message)) - 1]
    message = rest_message[first(findfirst(":",rest_message)) + 2:end]
    push!(decomposed_messages,[date, time, sender, message])
    
end 

println(decomposed_messages[1])

